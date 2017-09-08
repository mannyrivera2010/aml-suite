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
import binascii
import io
import logging
import os
import sys
import time
import traceback
import json

from git import Repo
from git.exc import GitCommandError
from git.remote import RemoteProgress
import jinja2

from githubinfo import GithubRequests
from versions import parse_version_string
import detectors
import log
import settings


log.configure_logging()
logger = logging.getLogger('default')


def render_template(tpl_path, context):
    path, filename = os.path.split(tpl_path)
    return jinja2.Environment(
        loader=jinja2.FileSystemLoader(path or './')
    ).get_template(filename).render(context)


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
        # end
        return handler


def generate_github_repo_url(repo_name):
    """
    Generate Github Repo URL used for cloning
    """
    format_data = {'REPO_NAME': repo_name}
    format_data['DEFAULT_ORGANIZATION'] = settings.DEFAULT_ORGANIZATION

    if settings.REPO_CLONE_MODE == 'git':
        REPO_CLONE_URL = 'git@github.com:{DEFAULT_ORGANIZATION}/{REPO_NAME}.git'
    else:
        REPO_CLONE_URL = 'https://github.com/{DEFAULT_ORGANIZATION}/{REPO_NAME}.git'

    return REPO_CLONE_URL.format_map(format_data)


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
        is_head = (commit_sha in heads_hexsha)

        authored_date = time.strftime("%Y-%m-%d  %H:%M:%S", time.gmtime(commit_obj.authored_date))
        summary = commit_obj.summary

        commit_obj_tags = repo_tag_mapping.get(commit_sha, [])

        version1 = None
        version2 = None

        version_object = None
        release_flag = None

        release_detected = 'release-' in summary or 'chore(release):' in summary
        if release_detected:
            if 'release-' in summary:
                version1 = summary[summary.find('release-') + 8::]
            elif 'chore(release):' in summary:  # IWC
                version1 = summary[summary.find('chore(release):') + 15::]

            if '(tag: v' in summary:
                version2 = summary[summary.find('(tag: v') + 5: summary.find(',')]

            if not version1 and not version2 and release_detected:
                logger.debug('Could not find version : %s' % summary)
            elif not version1 and version2 and release_detected:
                version1 = version2
                logger.debug('Replaced Commit Version with Tag Version : %s' % summary)

            if version1:
                version_obj = parse_version_string(version1, is_head)

                if version_obj.error:
                    logger.debug('%s - %s' % (version_obj.error, summary))
                else:
                    version_object = version_obj
                    release_flag = True

        current_data = {}
        current_data['commit_sha'] = commit_sha
        current_data['authored_date'] = authored_date
        current_data['author'] = commit_obj.author
        current_data['summary'] = commit_obj.summary
        current_data['is_head'] = is_head
        current_data['tags'] = commit_obj_tags
        current_data['version_object'] = version_object
        current_data['release_flag'] = release_flag

        output.append(current_data)

    return output


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
        self.git_directory = None
        self.valid = False
        self.release_flag = False
        self.force_flag = False
        self.detector_list = None
        self.commit_log = []
        self.releases = []
        self.push_flag = True
        self.repo_working_directory_obj = repo_working_directory_obj

    def get_push_flag(self):
        return self.push_flag

    def force_release(self):
        self.repo_working_directory_obj.data_store['repo'][self.repo_name]['force_flag'] = True
        self.force_flag = True

    def get_directory_name(self):
        return self.repo_working_directory_obj.data_store['repo'][self.repo_name]['working_directory']

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

    def release(self):
        """
        If the head commit is not a release commit make a release
        """
        return not self.is_head_release_commit()

    def get_current_version_number(self):
        return self.releases[0]

    def get_next_version_number(self):
        return self.releases[0].increment()

    def check_release(self):
        return self.release_flag

    def _log_git_output(self, desc, git_output):
        string_io = io.StringIO(git_output.decode('utf-8'))
        log_output_lines = string_io.readlines()

        if log_output_lines:
            for line in log_output_lines:
                line = line.strip().rstrip('\n')
                if line:
                    logger.info('{} - {} - {}'.format(self.repo_name, desc, line))
        string_io.close()

    def initize_repo(self, create_if_not_exist=False):
        """
        Return if git directory is valid
        """
        repo_working_directory = self.repo_working_directory_obj.data_store['repo'][self.repo_name]['working_directory']
        repo_directory_state = self.repo_working_directory_obj.data_store['repo'][self.repo_name]['directory_state']
        repo_github_url = self.repo_working_directory_obj.data_store['repo'][self.repo_name]['github_repo_url']

        if repo_directory_state == 'NOT_EXIST':
            logger.info('%s - %s' % (self.repo_name, 'Cloning Repo'))
            Repo.clone_from(repo_github_url, repo_working_directory, ProgressListener(self.repo_name))
            self.repo_working_directory_obj.data_store['repo'][self.repo_name]['directory_state'] = DirectoryState.CLONED

        self.repo = Repo(repo_working_directory)
        self.git = self.repo.git
        self.git_directory = repo_working_directory
        self._commit_log()
        self.valid = True

        self.repo_working_directory_obj.data_store['repo'][self.repo_name]['current_version'] = str(self.releases[0])
        self.repo_working_directory_obj.data_store['repo'][self.repo_name]['next_version'] = str(self.releases[0].increment())
        self.repo_working_directory_obj.data_store['repo'][self.repo_name]['is_head_release_commit'] = self.releases[0].is_head

        logger.info('%s - %s' % (self.repo_name, 'Repo directory is valid'))

        return True

    def reset_update_repo(self):
        """
        Reset Repo
        """
        if not self.valid:
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
        if not self.is_head_release_commit() or self.force_flag:
            logger.info('%s - Detected need to Release(%s) to (%s) - Forced: %s' % (self.repo_name,
                                                                                    self.get_current_version_number(),
                                                                                    self.get_next_version_number(),
                                                                                    self.release_flag))
            for detector_obj in self.detector_list:
                if detector_obj.detect():
                    logger.info('%s - %s - Detected File(%s)' %
                                (self.repo_name, type(detector_obj).__name__, detector_obj.detect()))
            self.release_flag = True
            self.repo_working_directory_obj.data_store['repo'][self.repo_name]['release_flag'] = True

        else:
            logger.info('{} - Does not need to release({})'.format(self.repo_name, self.get_current_version_number()))

        return self.release_flag

    def release_modifications_commit(self):
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

                    self.repo_working_directory_obj.data_store['repo'][self.repo_name]['errors'].append(str(error))
                    exc_info = sys.exc_info()
                    traceback.print_exception(*exc_info)

            if safe_commit:
                self.push_flag = True
                self.commit()
            else:
                self.push_flag = False
                logger.info('%s - Not Committing due to failure' % self.repo_name)

        else:
            logger.info('%s - No Need for Modifications' % (self.repo_name))

    def log_commits(self):
        for entry in self.commit_log[0:15]:
            logger.info('{} - {} - {} - {}'.format(self.repo_name,
                                                   entry['authored_date'],
                                                   entry['author'],
                                                   entry['summary']))

    def _commit_log(self):
        self.commit_log = repo_commits_log(self.repo)

        self.releases = []

        for commit in self.commit_log:
            if commit['release_flag'] is True:
                self.releases.append(commit['version_object'])

    def commit(self):
        lastest_version_number = self.get_next_version_number()
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
        return '(%s, %s, %s)' % (self.repo_name, self.git_directory, self.valid)

    def __str__(self):
        return '(%s, %s, %s)' % (self.repo_name, self.git_directory, self.valid)


class RepoWorkingDirectory(object):
    """
    Class to manage working git directory
    """
    def __init__(self, github_info=None):
        self.data_store = {}
        self.data_store['meta'] = {}
        self.data_store['meta']['repos'] = settings.REPOS
        self.data_store['meta']['release_directory'] = settings.GIT_BASE_DIR

        self.data_store['repo'] = {}
        for repo_name in self.data_store['meta']['repos']:
            self.data_store['repo'][repo_name] = {}
            self.data_store['repo'][repo_name]['working_directory'] = os.path.join(self.data_store['meta']['release_directory'], repo_name)
            self.data_store['repo'][repo_name]['github_repo_url'] = generate_github_repo_url(repo_name)
            self.data_store['repo'][repo_name]['directory_state'] = get_directory_state(self.data_store['repo'][repo_name]['working_directory'])
            self.data_store['repo'][repo_name]['next_version'] = None
            self.data_store['repo'][repo_name]['current_version'] = None
            self.data_store['repo'][repo_name]['release_flag'] = False
            self.data_store['repo'][repo_name]['force_flag'] = False
            self.data_store['repo'][repo_name]['errors'] = []

        self.data_store['meta']['safe_push_flag'] = False

        if github_info:
            self.github_info = github_info
        else:
            self.github_info = GithubRequests()

        self.repos = {}
        for name in self.data_store['meta']['repos']:
            self.repos[name] = RepoHelper(name, self)

    def initize_repos(self):
        for name in self.data_store['meta']['repos']:
            self.repos[name].initize_repo()

    def reset_update_repos(self):
        for name in self.data_store['meta']['repos']:
            self.repos[name].reset_update_repo()
            self.repos[name].log_commits()

    def prep_for_releases(self):
        """
        Check to see what repos need to be release and file modifications

        if ozp-hud or ozp-center needs a releases
            force ozp-react-commons to make a release
        """
        for name in self.data_store['meta']['repos']:
            release_flag = self.repos[name].release()
            force_flag = self.repos[name].force_flag

            if release_flag:
                if name == 'ozp-react-commons':
                    self.repos['ozp-hud'].force_release()
                    self.repos['ozp-center'].force_release()

            logger.info('{} - release_flag: {} - force_flag: {}'.format(name, release_flag, force_flag))

        for name in self.data_store['meta']['repos']:
            release_flag = self.repos[name].prep_release()

    def repos_release_modifications_commit(self):
        """
        Make Release Modifications and commit
        """
        self.data_store['meta']['safe_push_flag'] = True

        for name in self.data_store['meta']['repos']:
            self.repos[name].release_modifications_commit()

            if not self.repos[name].get_push_flag():
                self.data_store['meta']['safe_push_flag'] = False

    def repos_release_push(self):
        if self.data_store['meta']['safe_push_flag']:
            for name in self.data_store['meta']['repos']:
                push_flag = self.repos[name].check_release()
                if push_flag:
                    # logger.info('%s - Push : ' % (name))
                    print('(cd git-working/{}/ && git push --follow-tags)'.format(name))
        else:
            logger.info('Detected a repo modification failure - Will not push any repos')

    def show_state(self):
        return self.data_store

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

    login_or_token = None
    if args.github_token:
        login_or_token = args.github_token

    # if args.github-username and github-password:
    #     print()
    githubinfo = GithubRequests()

    if args.check_open_pull_request:
        logger.info("******** Checking Open Pull Requests for all repos *********")
        githubinfo.check_open_pull_requests()

    if args.skip_repo_release:
        repos_obj = RepoWorkingDirectory(githubinfo)

        # Check if repos exist, if not clone repo from github
        logger.info('******** Check Repos **********')
        repos_obj.initize_repos()

        # Reset and Update Repos
        logger.info('******** Reset Update Repos **********')
        repos_obj.reset_update_repos()

        # Check to see what repos need to be release and file modifications
        logger.info('******** Prep Repos **********')
        repos_obj.prep_for_releases()

        # Make Release Modifications and commit
        logger.info('******** Release Modifications **********')
        repos_obj.repos_release_modifications_commit()

        # Push Repos
        logger.info('******** Start Shell Push Commands **********')
        repos_obj.repos_release_push()
        logger.info('******** End Shell Push Commands **********')

        print('*-*-')
        print(json.dumps(repos_obj.show_state(), indent=2))
        print('*-*-')


if __name__ == '__main__':
    main()
