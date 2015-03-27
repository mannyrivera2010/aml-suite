"""
Provides status information on the repos in ozone-development

NOTE: All this is available via the GitHub API!!!!

CURRENT DATA 
- - - - - - - - 
Report errors in workflow, such as:
   - commits on master that are not in develop (or a release branch)
   - commits on a release branch not in develop

Report the latest tagged release version and date of each project (on master), 
as well as the latest tagged pre-release (on develop)

Links to download tarballs of latest releases and pre-releases for each project

Report number of commits on develop not on master (and provide link to diff?)

Report all feature branches

Running total of user contributions to each repo (# of issues closed per repo or # of PRs merged per repo)

Outstanding PRs for all repos

List all issues in progress (and who is assigned to them)

TIMEBOXED DATA (from x -y)
- - - - - - - - - - - - - - - 
Report basic contributor statistics (number of commits this period)

List all PRs merged in during this period and/or list all issues closed during this sprint

Other things maybe
- - - - - - - - - - 
Delete all pre-releases
Trigger Jenkins build
Link to other resources (huboard, deployment boxes, CI boxes, documentation, GH repos)


A generic site to do this, assumptions being:
1. Uses GitHub
2. Has several repositories in a single organization
3. Using single centralized "repository" model (not forks)
4. Uses GitFlow (historic branches for the latest and for releases)
5. Uses GitHub Releases functionality

"""
import os.path

import git
from git import Repo

import config

# data
# branches should exclude master and develop
# latest version is the latest tag from master
repo_data = {
    'repo-name': {
        'local_path': '/path/to/repo',
        'repo_obj': '<GitPythonRepoObj>',
        'errors': [
            {'name': 'nameVal', 'description': 'descriptionVal'}
        ],
        'commits_for_next_release': [
            {'hash': 'hashVal', 'commit_msg': 'msgVal'}
        ],
        'latest_version': {
            'version': 'versionVal',
            'releaseDate': 'releaseDataVal'
        },
        'branches': [
            {'name': 'branchName', 'lastUpdated': 'lastUpdatedVal'}
        ]
    }
}


def main():
    initialize_data()
    clone_missing_repos()
    update_repos()
    report_errors()
    report_commits_for_next_relese()
    report_latest_version()
    report_branches()
    print_output()


def initialize_data():
    for i in config.REPOS:
        repo_data[i] = {
            'repo_obj': '',
            'errors': [],
            'commits_for_next_release': [],
            'latest_version': {},
            'branches': []
        }


def clone_missing_repos():
    for i in config.REPOS:
        repo_path = os.path.join(config.CLONE_DIR, i)
        if not os.path.exists(repo_path):
            # TODO: clone missing repos
            print 'ERROR: Repo not found: %s' % i
        else:
            repo = Repo(repo_path)
            repo_data[i]['repo_obj'] =repo


def update_repos():
    for i in config.REPOS:
        git_cmd = repo_data[i]['repo_obj'].git
        print 'current branch on %s: %s' % (i, git_cmd.branch())
        print 'git fetch --all: %s' % (git_cmd.fetch(all=True))


def report_errors():
    for i in config.REPOS:
        git_cmd = repo_data[i]['repo_obj'].git
        missing_master_commits = git_cmd.log()


def report_commits_for_next_relese():
    pass


def report_latest_version():
    pass


def report_branches():
    pass


def print_output():
    pass


if __name__ == "__main__":
    main()