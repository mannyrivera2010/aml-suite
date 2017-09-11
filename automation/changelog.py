"""
Used to Generate changelog file
"""
import os

from git import Repo
import utils
import pprint

INCLUDE_UNRELEASED = False
UNRELEASED_STRING = 'Unreleased'
SECTION_ORDER = ['Feature', 'Fixes', 'Refactor', 'Merge Pull Requests', 'Changes']

SECTION_KEYWORDS = {
    'Feature': ['feat'],
    'Fixes': ['fix', '(fix)', 'Fix'],
    'Refactor': ['refactor'],
    'Merge Pull Requests': ['Merge pull request', 'Merge branch']
}


if __name__ == '__main__':
    cwd = os.path.join(os.getcwd(), 'git-working', 'ozp-backend')
    repo = Repo(cwd)
    commit_log = utils.repo_commits_log(repo)

    # print(pprint.pprint(commit_log))
    releases = []

    previous_version = UNRELEASED_STRING
    first_commit = True

    current_version = None

    commits_dict = {}
    for section in SECTION_ORDER:
        commits_dict[section] = []

    commit_count = 0
    release_authored_date = None

    for commit in commit_log:
        is_release = commit['is_release']
        version = str(commit['version_object'])
        commit_authored_date = commit['authored_date']
        summary = commit['summary']

        if is_release:
            current_version = version
            if first_commit:
                previous_version = current_version
                release_authored_date = commit_authored_date
        else:
            default_section = 'Changes'

            for section, section_keywords in SECTION_KEYWORDS.items():
                for current_keyword in section_keywords:
                    if summary.startswith(current_keyword):
                        default_section = section
                        break


            commits_dict[default_section].append(summary)
            commit_count = commit_count + 1

        if is_release:
            if current_version != previous_version:
                filter_release = False

                print('Changed {} to {}, {}'.format(previous_version, current_version, commit_count))

                current_release = {}
                current_release['version'] = previous_version
                current_release['commits'] = commits_dict
                current_release['commit_count'] = commit_count
                current_release['authored_date'] = release_authored_date

                if INCLUDE_UNRELEASED == False and current_release['version'] == UNRELEASED_STRING:
                    filter_release = True

                if not filter_release:
                    releases.append(current_release)
                previous_version = version
                release_authored_date = commit_authored_date
                commits_dict = {}
                for section in SECTION_ORDER:
                    commits_dict[section] = []
                commit_count = 0

        first_commit =  False

    print(pprint.pprint(releases))
    template_context = {'releases':releases,'section_order': SECTION_ORDER}
    print(utils.render_template('templates/changelog.jinja2', template_context))
