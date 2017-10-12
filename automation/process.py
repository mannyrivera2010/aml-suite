"""
Automated Release Process

* Edit ~/.gitconfig with current user
* Run latest-update.sh
* Check Github for Version Numbers for each repo
* Check Github PRs for each repo
  * If open or approve PRs get instruction form PR owner
*

Reference:
https://github.com/ozone-development/ozp-documentation/wiki/CI-and-Release-Process
"""
import argparse
import io
import logging
import os
import sys

import traceback
import json

from git import Repo
from git.exc import GitCommandError
from git.remote import RemoteProgress

from githubinfo import GithubRequests

import detectors
import log
import settings
import utils


log.configure_logging()
logger = logging.getLogger('default')


class DataStore(object):

    def __init__(self):
        self.data_store = {}
        self.data_store['meta'] = {}
        self.data_store['meta']['repos'] = settings.REPOS
        self.data_store['meta']['release_directory'] = settings.GIT_BASE_DIR

        self.data_store['repo'] = {}

    def __str__(self):
        return json.dumps(self.data_store, indent=2)

    def repos(self):
        return self.data_store['meta']['repos']

    def update_meta(self, data):
        for key_item, value_item in data.items():
            self.data_store['meta'][key_item] = value_item
        return data

    def get_meta_key(self, key):
        return self.data_store['meta'][key]

    def update_repo(self, repo_name, data):
        """
        Update Repo
        """
        if self.data_store['repo'].get(repo_name) is None:
            self.data_store['repo'][repo_name] = {}

        for key_item, value_item in data.items():
            self.data_store['repo'][repo_name][key_item] = value_item
        return self.data_store['repo'][repo_name]

    def append_repo_errors(self, repo_name, error):
        self.data_store['repo'][self.repo_name]['errors'].append(error)

    def get_repo_key(self, repo_name, key):
        return self.data_store['repo'][repo_name][key]


datastore = DataStore()


class ProgressListener(RemoteProgress):
    """
    Git Progress Listener
    https://gitpython.readthedocs.io/en/0.3.4/reference.html?highlight=remoteprogress#git.remote.RemoteProgress
    """
    def __init__(self, name):
        super(ProgressListener, self).__init__()
        self.name = name

    def new_message_handler(self):
        """
        :return:
            a progress handler suitable for handle_process_output(), passing lines on to this Progress
            handler in a suitable format"""
        def handler(line):
            logger.info('Cloning Progress For %s - %s ' %
                        (self.name, line.rstrip()))
        return handler


class DirectoryState(object):
    NOT_EXIST = 'NOT_EXIST'
    EXIST = 'EXIST'
    GIT_CORRUPT = 'GIT_CORRUPT'
    CLONED = 'CLONED'


def get_directory_state(directory_path):
    """
    Return directory of repo
    """
    if os.path.isdir(directory_path):
        if os.path.isdir(os.path.join(directory_path, '.git')):
            return DirectoryState.EXIST
        else:
            return DirectoryState.GIT_CORRUPT
    else:
        return DirectoryState.NOT_EXIST


class RepoHelper(object):
    """
    This class handles everything todo with a repo
    """
    def __init__(self, repo_name, repo_working_directory_obj):
        self.repo_name = repo_name
        self.detector_list = None
        self.commit_log = []
        self.releases = []
        self.repo_working_directory_obj = repo_working_directory_obj

    def init_detectors(self):
        if not self.detector_list:
            self.detector_list = []
            self.detector_list.append(detectors.PythonFileDetector(self))
            self.detector_list.append(detectors.PackageFileDetector(self))
            self.detector_list.append(detectors.NpmShrinkwrapDetector(self))
            self.detector_list.append(detectors.ChangeLogDetector(self))

    def _log_git_output(self, desc, git_output):
        string_io = io.StringIO(git_output.decode('utf-8'))
        log_output_lines = string_io.readlines()

        if log_output_lines:
            for line in log_output_lines:
                line = line.strip().rstrip('\n')
                if line:
                    logger.info('{} - {} - {}'.format(self.repo_name, desc, line))
        string_io.close()

    def _commit_log(self):
        self.commit_log = utils.repo_commits_log(self.repo)

        self.releases = []
        for commit in self.commit_log:
            if commit['is_release'] is True:
                self.releases.append(commit['version_object'])

        is_head_release_commit = (self.commit_log[0]['is_head'] and self.commit_log[0]['is_release'])
        datastore.update_repo(self.repo_name, {'current_version': str(self.releases[0]),
                                                'next_version': str(self.releases[0].increment()),
                                                'release_flag': not is_head_release_commit})

    def initize_repo(self, create_if_not_exist=False):
        """
        Return if git directory is valid
        """
        repo_working_directory = datastore.get_repo_key(self.repo_name, 'working_directory')
        repo_directory_state = datastore.get_repo_key(self.repo_name, 'directory_state')
        repo_github_url = datastore.get_repo_key(self.repo_name, 'github_repo_url')

        if repo_directory_state == 'NOT_EXIST':
            logger.info('%s - %s' % (self.repo_name, 'Cloning Repo'))
            Repo.clone_from(repo_github_url, repo_working_directory, ProgressListener(self.repo_name))
            datastore.update_repo(self.repo_name, {'directory_state': DirectoryState.CLONED })

        self.repo = Repo(repo_working_directory)
        self.git = self.repo.git
        self._commit_log()

        logger.info('{} - {}'.format(self.repo_name, 'Repo directory is valid'))
        return True

    def reset_update_repo(self):
        """
        Reset Repo
        """
        repo_directory_state = datastore.get_repo_key(self.repo_name, 'directory_state')

        if not (repo_directory_state == DirectoryState.EXIST or repo_directory_state == DirectoryState.CLONED):
            raise Exception('Need to run initize_repo method first')

        self._log_git_output('config', self.git.config('--global', 'user.name', '"{0}"'.format(settings.GIT_USERNAME), stdout_as_string=False))
        self._log_git_output('config', self.git.config('--global', 'user.email', settings.GIT_EMAIL, stdout_as_string=False))

        # Delete all local tags
        for tag in self.repo.tags:
            self.repo.delete_tag(tag)

        self._log_git_output('fetch', self.git.fetch('--all', '--tags', stdout_as_string=False))
        self._log_git_output('checkout', self.git.checkout('master', stdout_as_string=False))
        self._log_git_output('reset', self.git.reset('--hard', 'origin/master', stdout_as_string=False))

        self._commit_log()

    def prep_release(self):
        """
        Prep release
        """
        self.init_detectors()
        # If the head commit is not a release then need to make a release
        # If force_flag is true then need to make a release
        current_version = datastore.get_repo_key(self.repo_name, 'current_version')
        next_version = datastore.get_repo_key(self.repo_name, 'next_version')
        force_flag = datastore.get_repo_key(self.repo_name, 'force_flag')
        release_flag = datastore.get_repo_key(self.repo_name, 'release_flag')

        if release_flag or force_flag:
            logger.info('%s - Need to Release(%s) to (%s) - Forced: %s' % (self.repo_name,
                                                                           current_version,
                                                                           next_version,
                                                                           force_flag))
            for detector_obj in self.detector_list:
                detector_name = type(detector_obj).__name__
                detector_detect_flag = detector_obj.detect()
                if detector_detect_flag:
                    logger.info('{} - {} - Detected File({})'.format(self.repo_name, detector_name, detector_detect_flag))
            datastore.update_repo(self.repo_name, {'push_flag': True})
        else:
            logger.info('{} - Does not need to release({})'.format(self.repo_name, current_version))

        return release_flag

    def release_modifications_commit(self):
        if not self.detector_list:
            self.prep_release()

        datastore.update_repo(self.repo_name, {'safe_commit': True})
        force_flag = datastore.get_repo_key(self.repo_name, 'force_flag')
        release_flag = datastore.get_repo_key(self.repo_name, 'release_flag')

        if release_flag or force_flag:
            for detector_obj in self.detector_list:
                try:
                    if detector_obj.execute():
                        logger.info('%s - %s - Changed file(%s)' %
                                    (self.repo_name, type(detector_obj).__name__, detector_obj.detect()))
                except Exception as error:
                    datastore.update_repo(self.repo_name, {'safe_commit': False})

                    logger.info('%s - %s - Failed Execution File(%s) - %s' %
                                (self.repo_name, type(detector_obj).__name__, detector_obj.detect(), error))

                    datastore.append_repo_errors(self.repo_name, str(error))
                    exc_info = sys.exc_info()
                    traceback.print_exception(*exc_info)

            if self.repo_working_directory_obj.data_store['repo'][self.repo_name]['safe_commit']:
                datastore.update_repo(self.repo_name, {'push_flag': True})
                self.commit()
            else:
                datastore.update_repo(self.repo_name, {'push_flag': False})
                logger.info('%s - Not Committing due to failure' % self.repo_name)
        else:
            logger.info('%s - No Need for Modifications' % (self.repo_name))

    def log_commits(self):
        for entry in self.commit_log[0:15]:
            logger.info('{} - {} - {} - {}'.format(self.repo_name,
                                                   entry['authored_date_time'],
                                                   entry['author'],
                                                   entry['summary']))

    def commit(self):
        lastest_version_number = datastore.get_repo_key(self.repo_name, 'next_version')
        git_obj = self.repo.git
        commit_release_string = ("release-%s" % str(lastest_version_number))
        tag_release_string = ("release/%s" % str(lastest_version_number))
        tag_v_release_string_ow = ('v%s' % str(lastest_version_number))
        tag_v_release_string = ('"v%s"' % str(lastest_version_number))

        try:
            git_output = git_obj.commit('-am', commit_release_string, stdout_as_string=False)
            self._log_git_output('commit', git_output)

            git_output = git_obj.tag('-a', tag_release_string, '-m', tag_v_release_string, stdout_as_string=False)
            self._log_git_output('tag', git_output)

            git_output = git_obj.tag('-a', tag_v_release_string_ow, '-m', tag_v_release_string, stdout_as_string=False)
            self._log_git_output('tag', git_output)

            log_output = git_obj.status(stdout_as_string=False)
            self._log_git_output('status', log_output)

        except GitCommandError as error:
            logger.warn(error)
            raise

    def __repr__(self):
        return '(%s, %s, %s)' % (self.repo_name,
                                 datastore.get_repo_key(self.repo_name, 'working_directory'),
                                 datastore.get_repo_key(self.repo_name, 'directory_state'))

    def __str__(self):
        return '(%s, %s, %s)' % (self.repo_name,
                                 datastore.get_repo_key(self.repo_name, 'working_directory'),
                                 datastore.get_repo_key(self.repo_name, 'directory_state'))


class RepoWorkingDirectory(object):
    """
    Class to manage working git directory
    """
    def __init__(self, github_info=None):
        for repo_name in datastore.repos():
            current_working_directory = os.path.join(datastore.get_meta_key('release_directory'), repo_name)

            datastore.update_repo(repo_name,
                {'working_directory': current_working_directory,
                 'github_repo_url': utils.generate_github_repo_url(repo_name),
                 'directory_state': get_directory_state(current_working_directory),
                 'next_version': None,
                 'current_version': None,
                 'force_flag': False,
                 'release_flag': False,
                 'push_flag': False,
                 'errors': []})

        datastore.update_meta({'safe_push_flag': False})

        if github_info:
            self.github_info = github_info
        else:
            self.github_info = GithubRequests()

        self.repos = {}
        for name in datastore.repos():
            self.repos[name] = RepoHelper(name, self)

    def initize_repos(self):
        """
        Check if repos exist, if not clone repo from github
        """
        logger.info('******** Initize Repos **********')
        for name in datastore.repos():
            self.repos[name].initize_repo()

    def reset_update_repos(self):
        """
        Reset and Update Repos
        """
        logger.info('******** Reset Update Repos **********')
        for name in datastore.repos():
            self.repos[name].reset_update_repo()
            self.repos[name].log_commits()

    def prep_for_releases(self):
        """
        Check to see what repos need to be release and file modifications

        if ozp-hud or ozp-center needs a releases
            force ozp-react-commons to make a release
        """
        logger.info('******** Pre Repos Release **********')
        for repo_name in datastore.repos():
            release_flag = datastore.get_repo_key(repo_name, 'release_flag')
            force_flag = datastore.get_repo_key(repo_name, 'force_flag')

            if release_flag and repo_name == 'ozp-react-commons':
                datastore.update_repo('ozp-hud', {'force_flag': True})
                datastore.update_repo('ozp-center', {'force_flag': True})

            logger.info('{} - release_flag: {} - force_flag: {}'.format(repo_name, release_flag, force_flag))

        logger.info('******** Prep Repos **********')
        for repo_name in datastore.repos():
            release_flag = self.repos[repo_name].prep_release()

    def repos_release_modifications_commit(self):
        """
        Make Release Modifications and commit
        """
        logger.info('******** Release Modifications **********')
        datastore.update_meta({'safe_push_flag': True})

        for repo_name in datastore.repos():
            self.repos[repo_name].release_modifications_commit()


            if not datastore.get_repo_key(repo_name, 'safe_commit'):
                datastore.update_meta({'safe_push_flag': False})

    def repos_release_push(self):
        """
        Repos release push
        """
        logger.info('******** Start Shell Push Commands **********')
        if datastore.get_meta_key('safe_push_flag'):
            for repo_name in datastore.repos():
                push_flag = datastore.get_repo_key(repo_name, 'push_flag')
                if push_flag:
                    # logger.info('%s - Push : ' % (name))
                    print('(cd git-working/{}/ && git push --follow-tags)'.format(repo_name))
        else:
            logger.info('Detected a repo modification failure - Will not push any repos')

    def __repr__(self):
        return '%s' % (self.repos)

    def __str__(self):
        return '%s' % (self.repos)


def main():
    parser = argparse.ArgumentParser(description='Release')
    parser.add_argument('--github-token', type=str)
    parser.add_argument('--check_open_pull_request', action="store_true")
    parser.add_argument('--skip_repo_release', action="store_false")

    args = parser.parse_args()

    print('args: {}'.format(args))
    # if args.github-username and github-password:
    #     print()
    githubinfo = GithubRequests()

    if args.check_open_pull_request:
        logger.info("******** Checking Open Pull Requests for all repos *********")
        githubinfo.check_open_pull_requests()

    if args.skip_repo_release:
        repos_obj = RepoWorkingDirectory(githubinfo)
        repos_obj.initize_repos()
        repos_obj.reset_update_repos()
        repos_obj.prep_for_releases()
        repos_obj.repos_release_modifications_commit()
        repos_obj.repos_release_push()

        print('*-*-')
        print(datastore)
        print('*-*-')

if __name__ == '__main__':
    main()
