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
import time
import binascii

from git import Repo
from git.exc import GitCommandError
from git.remote import RemoteProgress

from versions import Version
from versions import parse_version_string
import cmd_utils
import log
from githubinfo import GitHubInfo
import detectors
from settings import settings_instance

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
            logger.info('Cloning Progress For %s - %s ' %
                        (self.name, line.rstrip()))
        # end
        return handler


def generate_github_repo_url(repo_name):
    """
    https://github.com/ozone-development/ozp-backend.git
    https://github.com/ozone-development/ozp-hud.git

    """
    return 'https://github.com/ozone-development/%s.git' % repo_name


def get_release_from_log(repo_commits_log_list):
    releases = []

    for commit_entry in repo_commits_log_list:
        version1 = None
        version2 = None

        line = commit_entry.summary
        is_head = commit_entry.is_head

        release_detected = 'release-' in line or 'chore(release):' in line

        if release_detected:
            if 'release-' in line:
                version1 = line[line.find('release-') + 8::]
            elif 'chore(release):' in line:  # IWC
                version1 = line[line.find('chore(release):') + 15::]

            if '(tag: v' in line:
                version2 = line[line.find('(tag: v') + 5: line.find(',')]

            if not version1 and not version2 and release_detected:
                logger.debug('Could not find version : %s' % line)
            elif not version1 and version2 and release_detected:
                version1 = version2
                logger.debug(
                    'Replaced Commit Version with Tag Version : %s' % line)

            if version1:
                version_obj = parse_version_string(version1, is_head)

                if version_obj.error:
                    logger.debug('%s - %s' % (version_obj.error, line))
                else:
                    releases.append(version_obj)

    return releases


class CommitEntry(object):

    def __init__(self, commit_sha, authored_date, committer, summary, is_head, tags):
        self.commit_sha = commit_sha
        self.authored_date = authored_date
        self.committer = committer
        self.summary = summary
        self.is_head = is_head
        self.tags = tags

    def __str__(self):
        return('%s - %s - %s - %s - HEAD(%s) - Tags: %s' % (self.commit_sha,
                                    self.authored_date,
                                    self.committer,
                                    self.summary,
                                    self.is_head,
                                    self.tags))


def repo_commits_log(repo):
    """
    # http://gitpython.readthedocs.io/en/stable/reference.html#module-git.objects.commit
    Args:
        repo: repo obj

    Returns:
        [CommitEntry, ..]
    """
    output = []

    repo_tag_mapping = {}

    for tag in repo.tags:
        tag_commit = str(tag.commit)
        if tag_commit not in repo_tag_mapping:
            repo_tag_mapping[tag_commit] = [str(tag)]
        else:
            repo_tag_mapping[tag_commit].append(str(tag))

    heads_hexsha = [head.commit.hexsha for head in repo.heads]

    for commit_obj in repo.iter_commits():

        commit_sha = binascii.hexlify(commit_obj.binsha).decode('utf8')
        authored_date = time.strftime(
            "%Y-%m-%d  %H:%M:%S", time.gmtime(commit_obj.authored_date))
        commit_obj_tags = repo_tag_mapping.get(commit_sha, [])

        current_entry = CommitEntry(commit_sha, authored_date, commit_obj.committer,
                                    commit_obj.summary, (commit_sha in heads_hexsha),
                                    commit_obj_tags)

        output.append(current_entry)

    return output


def valid_git_dir_helper(repo_name):
    """
    Return directory of repo
    """
    git_base_dir = settings_instance.git_base_dir()

    if os.path.isdir(os.path.join(git_base_dir, repo_name)):
        if os.path.isdir(os.path.join(git_base_dir, repo_name, '.git')):
            return os.path.join(git_base_dir, repo_name)
        else:
            logger.warning(
                'Repo directory [%s] seems to be corrupt' % repo_name)
    else:
        logger.warning('Repo directory [%s] seems does not exist' % repo_name)
    return None


class RepoHelper(object):
    """
    This class handles everything todo with a repo
    """

    def __init__(self, repo_name, repo_working_directory_obj):
        self.repo_name = repo_name
        self.git_directory = None
        self.valid = False
        self.release_flag = False
        self.detector_list = None
        self.releases = []
        self.push_flag = True
        self.repo_working_directory_obj = repo_working_directory_obj

    def repo_directory_next_version(self, name):
        return self.repo_working_directory_obj.get_repo_next_version(name)

    def get_push_flag(self):
        return self.push_flag

    def force_release(self):
        self.release_flag = True

    def init_detectors(self):
        if not self.detector_list:
            self.detector_list = []
            self.detector_list.append(detectors.PythonFileDetector(self))
            self.detector_list.append(detectors.PackageFileDetector(self))
            self.detector_list.append(detectors.NpmShrinkwrapDetector(self))
            self.detector_list.append(detectors.ChangeLogDetector(self))

    def is_head_release_commit(self):
        if not self.releases:
            return False
        return self.releases[0].is_head

    def prep_release(self):
        """
        Prep release
        """
        self.init_detectors()

        if not self.is_head_release_commit() or self.release_flag:
            logger.info('%s - Detected need to Release(%s) to (%s) - Forced: %s' % (self.repo_name,
                                                                                    self.get_current_version_number(),
                                                                                    self.get_next_version_number(),
                                                                                    self.release_flag))
            for detector_obj in self.detector_list:
                if detector_obj.detect():
                    logger.info('%s - %s - Detected File(%s)' %
                                (self.repo_name, type(detector_obj).__name__, detector_obj.detect()))
            self.release_flag = True
        else:
            logger.info('%s - Does not need to  Release(%s)' %
                        (self.repo_name, self.get_current_version_number()))

        return self.release_flag

    def get_current_version_number(self):
        return self.releases[0]

    def get_next_version_number(self):
        return self.releases[0].increment()

    def check_release(self):
        return self.release_flag

    def make_release(self):
        if not self.detector_list:
            self.prep_release()

        if self.release_flag:
            safe_commit = True

            for detector_obj in self.detector_list:
                try:
                    if detector_obj.execute():
                        logger.info('%s - %s - Changed file(%s)' %
                                    (self.repo_name, type(detector_obj).__name__, detector_obj.detect()))
                except Exception as error:
                    safe_commit = False
                    logger.info('%s - %s - Failed Execution File(%s) - %s' %
                                (self.repo_name, type(detector_obj).__name__, detector_obj.detect(), error))

                    import traceback
                    import sys
                    exc_info = sys.exc_info()
                    traceback.print_exception(*exc_info)



            if safe_commit:
                self.push_flag = True
                self.commit(self.get_next_version_number())
            else:
                self.push_flag = False
                logger.info('%s - Not Committing due to failure' % self.repo_name)

        else:
            logger.info('%s - No Need for Modifications' % (self.repo_name))

    def directory_exist(self):
        git_base_dir = settings_instance.git_base_dir()

        if os.path.isdir(os.path.join(git_base_dir, self.repo_name)):
            if os.path.isdir(os.path.join(git_base_dir, self.repo_name, '.git')):
                return True
        return False

    def get_directory_name(self):
        git_base_dir = settings_instance.git_base_dir()
        return os.path.join(git_base_dir, self.repo_name)

    def _commit_log(self):
        self.commit_log = repo_commits_log(self.repo)
        self.releases = get_release_from_log(self.commit_log)

    def validate(self, create_if_not_exist=False):
        """
        Return if git directory is valid
        """
        directory_exist = self.directory_exist()
        git_repo_directory = self.get_directory_name()

        if not directory_exist and create_if_not_exist:
                url = generate_github_repo_url(self.repo_name)
                Repo.clone_from(url, git_repo_directory,
                                ProgressListener(self.repo_name))

        if git_repo_directory:
            self.repo = Repo(git_repo_directory)
            self.git = self.repo.git
            self.git_directory = git_repo_directory
            self._commit_log()
            self.valid = True
            logger.info('%s - %s' % (self.repo_name, 'Repo directory is valid'))
            # print(self.releases)
            return True

        logger.info('%s - %s' % (self.repo_name, 'Repo directory is not valid'))
        return False

    def change_git_user_email(self, user, email):
        """
        Used to change user name and email in git config
        """
        logger.info('%s - %s' % (self.repo_name,
                                 self.git.config('--global', 'user.name', '"{0}"'.format(user))))
        logger.info('%s - %s' % (self.repo_name, self.git.config('--global',
                                                                 'user.email', email)))

    def reset_update_repo(self):
        """
        Reset Repo
        """
        if not self.valid:
            raise Exception('Need to run validate method first')

        self.change_git_user_email('Manny Rivera', 'mannyrivera2010@gmail.com')
        # Delete all local tags
        for tag in self.repo.tags:
            self.repo.delete_tag(tag)

        git_obj = self.repo.git
        logger.info('%s - %s' %
                    (self.repo_name, self.git.fetch('--all', '--tags')))
        logger.info('%s - %s' % (self.repo_name, self.git.checkout('master')))
        current_head_str = self.git.reset('--hard', 'origin/master')

        self._commit_log()

    def commit(self, lastest_version_number):
        git_obj = self.repo.git
        # Commit - git commit -am "release-$1"
        commit_release_string = ("release-%s" % str(lastest_version_number))
        tag_release_string = ("release/%s" % str(lastest_version_number))
        tag_v_release_string_ow = ('v%s' % str(lastest_version_number))
        tag_v_release_string = ('"v%s"' % str(lastest_version_number))

        git_output = git_obj.commit(
            '-am', commit_release_string, stdout_as_string=False)
        string_io = io.StringIO(git_output.decode('utf-8'))
        log_output_lines = string_io.readlines()

        if log_output_lines:
            for line in log_output_lines:
                if line.strip():
                    logger.info('%s - commit - %s' %
                                (self.repo_name, line.rstrip('\n')))

        # git commit -am "release-$1"
        # git tag -a release/$1 -m "v$1"
        try:
            git_output = git_obj.tag(
                '-a', tag_release_string, '-m', tag_v_release_string, stdout_as_string=False)
            string_io = io.StringIO(git_output.decode('utf-8'))
            log_output_lines = string_io.readlines()

            if log_output_lines:
                for line in log_output_lines:
                    if line.strip():
                        logger.info('%s - tag 1 - %s' %
                                    (self.repo_name, line.rstrip('\n')))
        except GitCommandError as error:
            logger.warn(error)
            raise

        # git tag -a v$1 -m "v$1"
        try:
            git_output = git_obj.tag(
                '-a', tag_v_release_string_ow, '-m', tag_v_release_string, stdout_as_string=False)
            string_io = io.StringIO(git_output.decode('utf-8'))
            log_output_lines = string_io.readlines()

            if log_output_lines:
                for line in log_output_lines:
                    if line.strip():
                        logger.info('%s - tag 1 - %s' %
                                    (self.repo_name, line.rstrip('\n')))
        except GitCommandError as error:
            logger.warn(error)
            raise

        self.status()

    def status(self):
        git_obj = self.repo.git
        log_output = git_obj.status(stdout_as_string=False)

        string_io = io.StringIO(log_output.decode('utf-8'))
        log_output_lines = string_io.readlines()

        if log_output_lines:
            for line in log_output_lines:
                if line.strip():
                    logger.info('%s - status - %s' %
                                (self.repo_name, line.rstrip('\n')))

        string_io.close()

    def __repr__(self):
        return '(%s, %s, %s)' % (self.repo_name, self.git_directory, self.valid)

    def __str__(self):
        return '(%s, %s, %s)' % (self.repo_name, self.git_directory, self.valid)


class RepoWorkingDirectory(object):
    """
    Class to manage working git directory
    """

    def __init__(self, github_info=None):
        if github_info:
            self.github_info = github_info
        else:
            self.github_info = GitHubInfo()

        self.repos = {}
        for name in settings_instance.repos():
            self.repos[name] = RepoHelper(name, self)

        self.safe_push_flag = False

    def get_repo_next_version(self, repo_name):
        if self.repos.get(repo_name):
            return self.repos.get(repo_name).get_next_version_number()
        else:
            raise Exception('get_repo_next_version({0}) - repo not found'.format(repo_name))

    def check_repos(self, create_if_not_exist=False):
        for name in settings_instance.repos():
            self.repos[name].validate(create_if_not_exist=create_if_not_exist)

    def reset_update_repos(self):
        for name in settings_instance.repos():
            self.repos[name].reset_update_repo()

    def prep_for_releases(self):
        """
        Check to see what repos need to be release and file modifications

        if ozp-hud or ozp-center needs a releases
            force ozp-react-commons to make a release

        """
        for name in settings_instance.repos():
            release_flag = self.repos[name].is_head_release_commit()

            if release_flag:
                if name == 'ozp-hud' or name == 'ozp-center':
                    self.repos['ozp-react-commons'].force_release()

        for name in settings_instance.repos():
            release_flag = self.repos[name].prep_release()

    def modifications_for_releases(self):
        """
        Make Release Modifications and commit
        """
        self.safe_push_flag = True

        for name in settings_instance.repos():
            release_flag = self.repos[name].make_release()

            if not self.repos[name].get_push_flag():
                self.safe_push_flag = False

        if not self.safe_push_flag:
            logger.info('********* modifications for releases error ************')
            logger.info(
                'Detected a repo modification failure - Will not push any repos')
            for name in settings_instance.repos():
                push_flag = self.repos[name].get_push_flag()
                logger.info('%s - Safe to push: %s' % (name, push_flag))

    def push_releases(self):
        if self.safe_push_flag:
            for name in settings_instance.repos():
                # push_flag = self.repos[name].get_push_flag()
                logger.info('%s - Push' % (name))
        else:
            logger.info('Detected a repo modification failure - Will not push any repos')

    def __repr__(self):
        return '%s' % (self.repos)

    def __str__(self):
        return '%s' % (self.repos)


def main():
    parser = argparse.ArgumentParser(description='Release')
    parser.add_argument('--github-token', type=str)

    args = parser.parse_args()

    print(args)

    login_or_token = None
    if args.github_token:
        login_or_token = args.github_token

    # if args.github-username and github-password:
    #     print()
    githubinfo = GitHubInfo(login_or_token=login_or_token)

    logger.info("******** Checking Open Pull Requests for all repos *********")
    githubinfo.check_open_pull_requests()

    option1 = input("Do you want to continue with release process? (Enter [Yes] or [no]) ")

    if option1.lower() == 'no':
        return

    repos_obj = RepoWorkingDirectory(githubinfo)

    # Check if repos exist, if not clone repo from github
    logger.info('******** Check Repos **********')
    repos_obj.check_repos(True)

    # Reset and Update Repos
    logger.info('******** Reset Update Repos **********')
    repos_obj.reset_update_repos()

    # Check to see what repos need to be release and file modifications
    logger.info('******** Prep Repos **********')
    repos_obj.prep_for_releases()

    # Make Release Modifications and commit
    logger.info('******** Release Modifications **********')
    repos_obj.modifications_for_releases()

    option1 = input("Do you want to continue with release process, next phase is pushing? (Enter [Yes] or [no]) ")

    if option1.lower() == 'no':
        return

    # Push Repos
    logger.info('******** Push **********')
    repos_obj.push_releases()

if __name__ == '__main__':
    main()
