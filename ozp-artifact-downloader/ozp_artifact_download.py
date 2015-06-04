"""
This script reaches out to Jenkins and GitHub and checks to see if any of the
resources have been updated since the last download. If so, they are
downloaded.

This script is meant to be run in a polling manner (e.g. with cron)

Requires download_config.py, a config file containing sensitive info

To start fresh, just manually delete the json tracker file and the download dir
"""
import glob
import json
import logging
import os
import shutil
import sys
import zipfile

import requests
from requests.auth import HTTPBasicAuth

import download_config as cfg

# file must live in same directory as this script
TRACKER_FILE='download_tracker.json'
DOWNLOAD_DIR='latest_download'
TMP_DIR='tmp'

GITHUB_URL_PREFIX='https://github.com/ozone-development'
GITHUB_API_URL_PREFIX='https://api.github.com/repos/ozone-development'

# setup logging
logger = logging.getLogger('ozp_downloader')
logger.setLevel('DEBUG')

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# set formattting
formatter = logging.Formatter('%(levelname)s: %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)


def create_tracker_file():
	"""
	Writes a JSON file to keep track of the last downloaded builds
	"""
	data = {
		'jenkins_projects': [
			{
				'jenkins_name': 'build-ozp-center-master',
				'last_successful_build_number': '0',
				'artifact-prefix': 'center-'
			},
			{
				'jenkins_name': 'build-ozp-hud-master',
				'last_successful_build_number': '0',
				'artifact-prefix': 'hud-'

			},
			{
				'jenkins_name': 'build-ozp-webtop-master',
				'last_successful_build_number': '0',
				'artifact-prefix': 'webtop-'
			},
			{
				'jenkins_name': 'build-ozp-iwc-master',
				'last_successful_build_number': '0',
				'artifact-prefix': 'iwc-prod'
			},
			{
				'jenkins_name': 'build-ozp-iwc-owf7-widget-adapter-master',
				'last_successful_build_number': '0',
				'artifact-prefix': 'iwc-owf7'
			},
			{
				'jenkins_name': 'build-ozp-rest-master',
				'last_successful_build_number': '0',
				'artifact-prefix': 'rest-backend'
			},
			{
				'jenkins_name': 'build-ozp-demo-master-deploy-master',
				'last_successful_build_number': '0',
				'artifact-prefix': 'demo-apps'
			}
		],
		'github_repos': [
			{
				'name': 'piwik-theme-AppsMallTheme',
				'last_sha': 'none',
				'branch': 'master'
			},
			{
				'name': 'piwik-plugin-LoginPKI',
				'last_sha': 'none',
				'branch': 'master'
			},
			{
				'name': 'piwik',
				'last_sha': 'none',
				'branch': 'ozone-enhancements'
			},
			{
				'name': 'piwik-plugin-ClientCertificates',
				'last_sha': 'none',
				'branch': 'master'
			}
		]
	}

	with open(TRACKER_FILE, 'w') as outfile:
		json.dump(data, outfile, separators=(',', ': '), sort_keys=True, indent=4)

def write_tracker_file(data):
	with open(TRACKER_FILE, 'w') as outfile:
		json.dump(data, outfile, separators=(',', ': '), sort_keys=True, indent=4)

def setup():
	"""
	Create the tracker file if needed, create a clean temp directory, and make
	the download directory

	Return the tracker file data as a dict
	"""
	# check that the tracker file exists - if not, create it
	if not os.path.isfile(TRACKER_FILE):
		logger.info('creating file: %s' % TRACKER_FILE)
		create_tracker_file()


	# check that download directory exists - if not, create it
	if not os.path.exists(DOWNLOAD_DIR):
		os.makedirs(DOWNLOAD_DIR)

	# create local temp directory
	if os.path.exists(TMP_DIR):
		# clean it out (remove it)
		shutil.rmtree(TMP_DIR)
	# recreate it
	os.makedirs(TMP_DIR)


	# get the current state
	with open(TRACKER_FILE) as data_file:
		tracker = json.load(data_file)
	return tracker

def get_jenkins_artifacts(tracker):
	"""
	Download the latest build artifacts from the jenkins jenkins projects

	For each Jenkins project:
		* Get the last successful build number from Jenkins - if it differs from
			the build number in the tracker file, download it
		* Remove any existing artifacts for this project, unzip the outer
			layer of the artifact (it contains a tarball), and update the
			tracker file

	The outer zip file extracts into an unnecessary archive/ directory - at the
	end, move all artifacts up a level and remove the archive directory
	"""
	# for each Jenkins build artifact, check if there is a new build. If so,
	# pull it down, and remove the previous build artifact for this project
	for i in tracker['jenkins_projects']:
		j_name = i['jenkins_name']
		logger.info('checking jenkins project: %s' % j_name)
		last_build_url='%s/view/OZP/job/%s/lastSuccessfulBuild/buildNumber' % (
			cfg.config['JENKINS_URL_PREFIX'], j_name)
		r = requests.get(last_build_url, auth=(cfg.config['JENKINS_USER'], cfg.config['JENKINS_PW']))
		last_build_number = r.text
		if last_build_number != i['last_successful_build_number']:
			logger.info('Found new build for %s. Previous downloaded build: %s - current build: %s' % (
				j_name, i['last_successful_build_number'], last_build_number))
			# remove the current artifact(s)
			for f in glob.glob('%s/%s*' % (DOWNLOAD_DIR, i['artifact-prefix'])):
				logger.debug('removing file %s' % f)
				os.remove(f)
			# download the latest artifact
			r = requests.get(
				'%s/view/OZP/job/%s/lastSuccessfulBuild/artifact/*zip*/archive.zip' % (
					cfg.config['JENKINS_URL_PREFIX'], j_name),
					auth=(cfg.config['JENKINS_USER'], cfg.config['JENKINS_PW']), stream=True)
			if r.status_code == 200:
				with open('%s/%s.zip' % (TMP_DIR, j_name), 'wb') as outfile:
					shutil.copyfileobj(r.raw, outfile)
				# unzip the outer zip, revealing the tarball
				with zipfile.ZipFile('%s/%s.zip' % (TMP_DIR, j_name)) as z:
					# extract the zip to reveal the tarball within
					z.extractall(DOWNLOAD_DIR)
			else:
				logger.error('ERROR getting jenkins build artifact for %s' % j_name)

			# update the tracker file
			i['last_successful_build_number'] = last_build_number
			write_tracker_file(tracker)

			# optionally copy the file to a new location as well
			if cfg.config['COPY_DIR']:
				for f in glob.glob('%s/archive/%s*' % (DOWNLOAD_DIR, i['artifact-prefix'])):
					logger.info('copying file %s to %s' % (f, cfg.config['COPY_DIR']))
					try:
						# just get the filename, remove the 'archive/' part
						f_remove = '%s/%s' % (cfg.config['COPY_DIR'], f.rsplit('/', 1)[1])
						logger.debug('removing file %s' % f_remove)
						os.remove(f_remove)
					except Exception:
						# it might not exist
						logger.warning('failed to remove file %s' % f_remove)
					shutil.copy(f, cfg.config['COPY_DIR'])

		else:
			logger.debug('no new build for %s' % j_name)

	# move all tarfiles from <download_dir>/artifact/* to <download_dir>/
	if os.path.exists('%s/archive' % DOWNLOAD_DIR):
		files = os.listdir('%s/archive/' % DOWNLOAD_DIR)
		for f in files:
			shutil.move('%s/archive/%s' % (DOWNLOAD_DIR, f), DOWNLOAD_DIR)
		shutil.rmtree('%s/archive' % DOWNLOAD_DIR)


def get_github_repos(tracker):
	"""
	Download the latest source from each of the GitHub projects

	For each GitHub project:
		* get the current SHA of the last commit on the master branch from
			GitHub - if it differs from the corresponding SHA in the tracker
			file, download it
		* Remove the old artifact and update the tracker file
	"""
	# for each GitHub repo, check if there is a new commit on master. If so,
	# pull it down, and remove the previous download of this repository
	for i in tracker['github_repos']:
		name = i['name']
		logger.info('checking github repo: %s' % i['name'])
		url = '%s/%s/commits/%s' % (GITHUB_API_URL_PREFIX, name, i['branch'])
		r = requests.get(url)
		last_sha = r.json()['sha']
		if last_sha != i['last_sha']:
			logger.info('Found new code for %s' % name)
			# remove the current artifact(s) (no wildcards here)
			for f in glob.glob('%s/%s.zip' % (DOWNLOAD_DIR, i['name'])):
				logger.debug('removing file %s' % f)
				os.remove(f)
			# download the latest artifact
			url = '%s/%s/archive/master.zip' % (GITHUB_URL_PREFIX, name)
			r = requests.get(url, stream=True)
			if r.status_code == 200:
				with open('%s/%s.zip' % (DOWNLOAD_DIR, name), 'wb') as outfile:
					shutil.copyfileobj(r.raw, outfile)
			else:
				logger.error('bad response: %s' % r.status_code)
			# update the tracker file
			i['last_sha'] = last_sha
			write_tracker_file(tracker)
			# optionally copy the file to a new location as well
			if cfg.config['COPY_DIR']:
				for f in glob.glob('%s/%s.zip' % (DOWNLOAD_DIR, name)):
					logger.info('copying file %s to %s' % (f, cfg.config['COPY_DIR']))
					f_remove = '%s/%s' % (cfg.config['COPY_DIR'], f.rsplit('/', 1)[1])
					try:
						logger.debug('removing file %s' % f_remove)
						os.remove(f_remove)
					except Exception:
						logger.warning('failed to remove file %s' % f_remove)
					shutil.copy(f, cfg.config['COPY_DIR'])


def cleanup():
	# clean up the tmp directory
	shutil.rmtree(TMP_DIR)
	# shutil.rmtree('%s/archive' % DOWNLOAD_DIR)


def run():
	tracker = setup()
	get_jenkins_artifacts(tracker)
	get_github_repos(tracker)
	cleanup()


if __name__ == '__main__':
	run()