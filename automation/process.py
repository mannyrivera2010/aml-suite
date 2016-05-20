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
import os
import sys
import logging
import io
import socket
import argparse
import re

import github
from git import Repo
from git.exc import GitCommandError
from git.remote import RemoteProgress
from github import Github

import constants
from versions import Version
from versions import parse_version_string
import cmd_utils
import log

log.configure_logging()
logger = logging.getLogger('default')


class ProgressListener(RemoteProgress):
    """
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
            logger.info('Cloning Progress For %s - %s '%(self.name, line.rstrip()))
        # end
        return handler


class MyProgressPrinter(RemoteProgress):

    def update(self, op_code, cur_count, max_count=None, message=''):
        logger.info(op_code, cur_count, max_count, cur_count / (max_count or 100.0), message or "NO MESSAGE")
    # end


def get_releases_from_logs(current_git_obj):
    releases = []

    log_output = current_git_obj.log('--pretty=format:%h - %cd - %an - %d %s','--date=short', stdout_as_string=False)
    string_io = io.StringIO(log_output.decode('utf-8'))
    log_output_lines = string_io.readlines()

    for line in log_output_lines:
        version1 = None
        version2 = None
        line = line.rstrip('\n')

        release_detected = 'release-' in line or 'chore(release):' in line

        if release_detected:
            if 'release-' in line:
                version1 = line[line.find('release-')+8::]
            elif 'chore(release):' in line:  # IWC
                version1 = line[line.find('chore(release):')+15::]

            if '(tag: v' in line:
                version2 = line[line.find('(tag: v')+5 : line.find(',')]

            if not version1 and not version2 and release_detected:
                logger.debug('Could not find version : %s' % line)
            elif not version1 and version2 and release_detected:
                version1 = version2
                logger.debug('Replaced Commit Version with Tag Version : %s' % line)

            if version1:
                version_obj = parse_version_string(version1)

                if version_obj.error:
                    logger.debug('%s - %s' % (version_obj.error,line))
                else:
                    releases.append(version_obj)

    string_io.close()

    return releases

# class TaskBase(object):
#     def pre_execute(self, args, **kargs):
#         pass
#
#     def post_execute(self, args, **kargs):
#         pass
#
#     def _execute(self, **kargs):
#         self.pre_execute(**kargs)
#         self.execute(**kargs)
#         self.post_execute(**kargs)

class TaskBase(object):

    def execute(self):
        raise NotImplementedError()

    def handel_exception(self, exception):
        raise exception

    def start(self):
        try:
            self.execute()
        except Exception as err:
            self.handle_exception(err)


class UpdateRepoTask(TaskBase):

    def _git_dir_helper(self, repo_name):
        if os.path.isdir(os.path.join(constants.GIT_BASE_DIR, repo_name)):
            if os.path.isdir(os.path.join(constants.GIT_BASE_DIR, repo_name, '.git')):
                return True
            else:
                logger.warning('Repo directory [%s] seems to be corrupt' % repo_name)
        else:
            logger.warning('Repo directory [%s] seems does not exist' % repo_name)
        return False

    def execute(self, repo_name):
        """
        Args:
            repo_name: The name of the Repo (ozp-backend, ozp-hud)

        """
        repo_info = {}

        if self._git_dir_helper(repo_name):
            logger.info('************ %s ***************' % (repo_name))
            repo = Repo(os.path.join(constants.GIT_BASE_DIR, repo_name)) #, odbt=GitDB)
            git_obj = repo.git

            #logger.info('%s'%git_obj.config('-l'))
            # Set Username  - git config --global user.name "Billy Everyteen"
            # Set email - git config --global user.email "Billy Everyteen"

            # Delete all local tags
            for tag in repo.tags:
                repo.delete_tag(tag)

            logger.info('%s - %s' % (repo_name, git_obj.fetch('--all', '--tags')))

            logger.info('%s - %s' % (repo_name, git_obj.checkout('master')))

            current_head_str = git_obj.reset('--hard','origin/master')

            #current_head_str = ''

            # print('*'*100)
            # print(current_head_str)
            # print('*'*100)

            # Detect if repos needs version incremented
            # If the head is not a release then it needs to be released
            releases_from_logs = get_releases_from_logs(git_obj)

            release_in_head = False

            if 'release-' in current_head_str:
                release_in_head = True

            if 'chore(release):' in current_head_str:
                release_in_head = True

            repo_info = {'repo_dir':os.path.abspath(os.path.join(constants.GIT_BASE_DIR, repo_name)),
                                                  'repo':repo,
                                                  'releases_from_logs':releases_from_logs,
                                                  'release_in_head':release_in_head}

            logger.info('%s - %s' % (repo_name, current_head_str))
            logger.info('%s - Last 5 Release Versions - %s' % (repo_name, releases_from_logs[0:5] ))

            log_output = git_obj.log('--pretty=format:%h - %cd - %an - %d %s','--date=short','--since="14 days ago"', stdout_as_string=False)
            string_io = io.StringIO(log_output.decode('utf-8'))
            log_output_lines = string_io.readlines()

            if log_output_lines:
                for line in log_output_lines:
                    logger.info('%s - %s' % (repo_name, line.rstrip('\n')))
            else:
                logger.info('%s - %s' % (repo_name, 'No Logs'))

            string_io.close()

        return repo_info


class RepoTask(TaskBase):
    """
    repo_info = {'repo_dir':os.path.abspath(os.path.join(constants.GIT_BASE_DIR, repo_name)),
                                          'repo':repo,
                                          'releases_from_logs':releases_from_logs,
                                          'release_in_head':release_in_head}
    """

    def __init__(self, repo_name, info_map):
        self.repo_name = repo_name
        self.repo_dir = info_map.get('repo_dir', None)
        self.repo = info_map.get('repo', None)
        self.releases_from_logs = info_map.get('releases_from_logs', None)
        self.release_in_head = info_map.get('release_in_head', None)

    def detect_python_version_file(self):
        """
        This is used to detect if the repo has a _version.py file
        If it does run 'glup changelog'
        """
        if os.path.isfile(os.path.join(self.repo_dir, '_version.py')):
            return os.path.join(self.repo_dir, '_version.py')
        return None

    def change_python_version_file(self, input_file_dir, lastest_version_number):
        lines = []
        with open(input_file_dir, 'r') as f:
            lines = f.readlines()

        output_lines = []

        version_flag = True

        for line in lines:
            if version_flag:
                if line.find('version') >= 1:
                    version_flag = False
                    line = line = re.sub(r'"(\d+\.{0,1})+"', '"%s"' % str(lastest_version_number), line)
                    output_lines.append(line)
                else:
                    output_lines.append(line)
            else:
                output_lines.append(line)

        with open(input_file_dir, 'w') as f:
            for current_line in output_lines:
                f.write(current_line)

    def detect_package_file(self):
        """
        This is used to detect if the repo has a package.json file
        If it does run 'glup changelog'
        """
        if os.path.isfile(os.path.join(self.repo_dir, 'package.json')):
            return os.path.join(self.repo_dir, 'package.json')
        return None

    def change_package_file(self, input_file_dir, lastest_version_number):
        lines = []
        with open(input_file_dir, 'r') as f:
            lines = f.readlines()

        output_lines = []

        version_flag = True

        for line in lines:
            if version_flag:
                if line.find('version') >= 1:
                    version_flag = False
                    line = line = re.sub(r'"(\d+\.{0,1})+"', '"%s"' % str(lastest_version_number), line)
                    output_lines.append(line)
                else:
                    output_lines.append(line)
            else:
                output_lines.append(line)

        with open(input_file_dir, 'w') as f:
            for current_line in output_lines:
                f.write(current_line)

    def detect_changelog(self):
        """
        This is used to detect if the repo has a changelog.md file
        If it does run 'glup changelog'
        """
        if os.path.isfile(os.path.join(self.repo_dir, 'CHANGELOG.md')):
            return os.path.join(self.repo_dir, 'CHANGELOG.md')
        return None

    def run_gulp(self):
        """
        Generate the changelog.

        For center and hud: gulp changelog
        For webtop: grunt changelog
        None of the other repos have changelogs
        """
        # os.remove(self.detect_changelog())
        #

        if self.repo_name == 'ozp-center' or self.repo_name == 'ozp-hud':
            # print('(cd %s && npm install gulp)' % self.repo_dir)
            # print('(cd %s && rm node_modules/ -rf)' % self.repo_dir)
            # print('(cd %s && npm install)' % self.repo_dir)
            print('(cd %s && gulp changelog)' % self.repo_dir)

            command_results = cmd_utils.call_command('(cd %s && gulp changelog)' % self.repo_dir)

            if command_results.return_code != 0:
                raise Exception(command_results.pipe)

        elif self.repo_name == 'ozp-center':
            print('(cd %s && grunt changelog)' % self.repo_dir)

            command_results = cmd_utils.call_command('(cd %s && grunt changelog)' % self.repo_dir)
            if command_results.return_code != 0:
                raise Exception(command_results.pipe)


    def status(self):
        git_obj = self.repo.git
        log_output = git_obj.status(stdout_as_string=False)

        string_io = io.StringIO(log_output.decode('utf-8'))
        log_output_lines = string_io.readlines()

        if log_output_lines:
            for line in log_output_lines:
                if line.strip():
                    logger.info('%s - status - %s' % (self.repo_name, line.rstrip('\n')))

        string_io.close()

    def execute(self):
        """
        execute
        """
        lastest_version_number = self.releases_from_logs[0].increment()
        logger.info('%s - Should be updated to version %s' % (self.repo_name, lastest_version_number))
        logger.info('%s - detect_package_file: %s' % (self.repo_name, self.detect_package_file()))
        if self.detect_package_file():
            self.change_package_file(self.detect_package_file(), lastest_version_number)
            # os.remove(self.detect_package_file())

        logger.info('%s - detect_python_version_file: %s' % (self.repo_name, self.detect_python_version_file()))
        if self.detect_python_version_file():
            self.change_python_version_file(self.detect_python_version_file(), lastest_version_number)
            # os.remove(self.detect_package_file())

        logger.info('%s - detect_changelog: %s' % (self.repo_name, self.detect_changelog()))
        if self.detect_changelog():
            self.run_gulp()


        git_obj = self.repo.git

        # Commit - git commit -am "release-$1"
        commit_release_string = ("release-%s"%str(lastest_version_number))
        tag_release_string = ("release/%s"%str(lastest_version_number))
        tag_v_release_string_ow = ('v%s'%str(lastest_version_number))
        tag_v_release_string = ('"v%s"'%str(lastest_version_number))

        git_output = git_obj.commit('-am',commit_release_string,stdout_as_string=False)
        string_io = io.StringIO(git_output.decode('utf-8'))
        log_output_lines = string_io.readlines()

        if log_output_lines:
            for line in log_output_lines:
                if line.strip():
                    logger.info('%s - commit - %s' % (self.repo_name, line.rstrip('\n')))


        # git commit -am "release-$1"
        # git tag -a release/$1 -m "v$1"
        try:
            git_output = git_obj.tag('-a',tag_release_string,'-m',tag_v_release_string,stdout_as_string=False)
            string_io = io.StringIO(git_output.decode('utf-8'))
            log_output_lines = string_io.readlines()

            if log_output_lines:
                for line in log_output_lines:
                    if line.strip():
                        logger.info('%s - tag 1 - %s' % (self.repo_name, line.rstrip('\n')))
        except GitCommandError as error:
            logger.warn(error)
            raise


        # git tag -a v$1 -m "v$1"
        try:
            git_output = git_obj.tag('-a',tag_v_release_string_ow,'-m',tag_v_release_string,stdout_as_string=False)
            string_io = io.StringIO(git_output.decode('utf-8'))
            log_output_lines = string_io.readlines()

            if log_output_lines:
                for line in log_output_lines:
                    if line.strip():
                        logger.info('%s - tag 1 - %s' % (self.repo_name, line.rstrip('\n')))
        except GitCommandError as error:
            logger.warn(error)
            raise

        self.status()


class CheckIfRepoExistCreateTask(TaskBase):

    def execute(self):
        """
        Check to see if ozp repo exist, if not exist clone it from github repo clone url

        Ignores Github Rate Limiting and logs a warning

        Return:
            { '{repo name}':{repo obj} ....}
        """
        self.github_client = Github()
        repos_info_map = {}

        try:
            #Check to see if git repos exists
            for repo in self.github_client.get_organization('ozone-development').get_repos():
                if repo.name in constants.REPOS:
                    repos_info_map[repo.name] = repo

                    if os.path.isdir(os.path.join(constants.GIT_BASE_DIR, repo.name)):
                        logger.info('%s is already clone' % (repo.name))
                    else:
                        logger.info('%s - %s' % (repo.name, repo.clone_url))
                        Repo.clone_from(repo.clone_url, os.path.join(constants.GIT_BASE_DIR, repo.name), ProgressListener(repo.name))

        except github.GithubException as err:
            repos_info_map = None
            logger.warn('Github issue: %s ' % err)
        except socket.timeout as err:
            repos_info_map = None
            logger.warn('Github timeout issue : %s ' % err)

        return repos_info_map


class RepoManager(object):

    def __init__(self):
        logger.info("Starting Release Process")
        self.github_client = Github()

    def set_repo(self, github_repo, path):
        """
        Args:
            github_repo: github Repo Object
            path: path of repo
        """
        pass

    def run(self):
        repos_info_map = CheckIfRepoExistCreateTask().start()
        #logger.info('repos_info_map : %s ' % repos_info_map)
        repos_to_update_version = self.update_repos_to_latest()

        logger.info('******** Repos to update version ************')
        for repo_name in repos_to_update_version.keys():
            repo_info_map = repos_to_update_version[repo_name]
            #print(repo_info_map)
            if repo_info_map['releases_from_logs'] and not repo_info_map['release_in_head']:
                logger.info('-------------Detected Repo: %s - Previous 5 Release: %s  -----------------' % (repo_name, repo_info_map['releases_from_logs'][0:5]))
                RepoTask(repo_name, repo_info_map).execute()

    def update_repos_to_latest(self):
        """
        Replaces lastest-updates.sh
        """
        repos_to_update_version = {}

        for repo_name in constants.REPOS:
            repo_info = UpdateRepoTask().execute(repo_name)
            repos_to_update_version[repo_name] = repo_info

        return repos_to_update_version

def main():
    # dag = Dag()
    # dag.add(CheckIfRepoExistCreateTask)  # Start of Dag
    # dag
    parser = argparse.ArgumentParser(description='Release')
    parser.add_argument('--github-username', type=str)
    parser.add_argument('--github-password', type=str)

    # parser.add_argument('integers',default=[1,3], metavar='N', type=int, nargs='+',
    #                    help='an integer for the accumulator')
    #
    # parser.add_argument('--sum', dest='accumulate', action='store_const',
    #                    const=sum, default=max,
    #                    help='sum the integers (default: find the max)')

    args = parser.parse_args()

    print(args)

    # if args.github-username and github-password:
    #     print()

    repo_manager = RepoManager()
    repo_manager.run()

    # print(args.accumulate(args.integers))

if __name__ == '__main__':
    main()
