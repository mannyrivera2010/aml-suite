"""
This script is used on CI boxes. It downloads a given artifact from Jenkins
and deploys it to the local box. The followings command line arguments
should be provided:

job_name: The Jenkins project name to download
build_number: The Jenkins build number to download
"""
import argparse
import logging
import os
import sys
from subprocess import call

import requests
from requests.auth import HTTPBasicAuth

# local directory where ansible playbooks are located
ANSIBLE_DIR = '/home/jenkins/ozp-ansible'
ANSIBLE_INSTALL = '/home/jenkins/ansible'

# setup logging
logger = logging.getLogger('jenkins_ansible_deployer')
logger.setLevel(logging.DEBUG)

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# set formattting
formatter = logging.Formatter('%(levelname)s: %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)

def run():
    parser = argparse.ArgumentParser()
    parser.add_argument("job_name", metavar='job_name', type=str,
                        help="Jenkins project name", choices=[
                            "build-center-release",
                            "build-hud-release",
                            "build-webtop-release",
                            "build-iwc-release",
                            "build-backend-release",
                            "build-demo-release",
                            "build-help-release",
                            "build-center-latest",
                            "build-hud-latest",
                            "build-webtop-latest",
                            "build-iwc-latest",
                            "build-demo-latest",
                            "build-help-latest",
                            "build-backend-latest"],
                        default="build-center-release")
    parser.add_argument("build_number", metavar='build_number', type=int,
                        help="Jenkins build number to deploy")
    parser.add_argument("--es_enabled", metavar='es_enabled', type=str,
                    help="Enable Elasticsearch", choices=[
                        "False",
                        "True"],
                    default="False")

    args = parser.parse_args()
    logger.info("Parsed Arguments %s" % args)
    # set the ansible playbook to use based on the Jenkins job name
    if "build-center" in args.job_name:
        ansible_playbook = "ozp_deploy_center"
    if "build-hud" in args.job_name:
        ansible_playbook = "ozp_deploy_hud"
    if "build-webtop" in args.job_name:
        ansible_playbook = "ozp_deploy_webtop"
    if "build-iwc" in args.job_name:
        ansible_playbook = "ozp_deploy_iwc"
    if "build-backend" in args.job_name:
        ansible_playbook = "ozp_deploy_backend"
    if "build-help" in args.job_name:
        ansible_playbook = "ozp_deploy_help"
    if "build-demo" in args.job_name:
        ansible_playbook = "ozp_deploy_demo_apps"

    if not ansible_playbook:
        logger.error("No ansible playbook selected")
        sys.exit(1)

    logger.info("Running ansible playbook %s" % ansible_playbook)
    command = 'ansible-playbook %s.yml -i hosts_local -u jenkins --connection=local --extra-vars "download_from=jenkins jenkins_project=%s jenkins_build_number=%s es_enabled=%s"' % (
        ansible_playbook, args.job_name, args.build_number, args.es_enabled)

    logger.info("Running command: %s" % command)
    call(command, cwd=ANSIBLE_DIR, shell=True)

if __name__ == '__main__':
    run()
