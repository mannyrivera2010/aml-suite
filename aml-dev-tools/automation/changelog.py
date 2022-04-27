"""
Used to Generate changelog file

TODO: Figure out how not include commits that are in the release but not really in the release
due to git authored_date
"""
import os
import re
from collections import OrderedDict
import time

from git import Repo
import utils


SECTIONS = [
    {'section': 'Feature',
     'type_keywords': ['feat']},
    {'section': 'Fixes',
        'type_keywords': ['fix', '(fix)']},
    {'section': 'Refactor',
        'type_keywords': ['refactor']},
    {'section': 'Merge Pull Requests',
        'type_keywords': ['merge pull request', 'merge branch']},
    {'section': 'Documentation',
        'type_keywords': ['docs', 'doc']},
    {'section': 'Style',
        'type_keywords': ['style']},
    {'section': 'Performance',
        'type_keywords': ['perf', 'performance']},
    {'section': 'Test',
        'type_keywords': ['test', 'unittest']},
    {'section': 'Chore',
        'type_keywords': ['chore']},
    {'section': 'Changes',
        'type_keywords': []}
]


def create_changelog(repo_path, override_release=None):
    unreleased_string = 'Unreleased'
    include_unreleased = False

    if override_release:
        include_unreleased = True
        unreleased_string = override_release

    repo = Repo(repo_path)
    repo_directory = repo.working_tree_dir
    changelog_path = os.path.join(repo_directory, 'CHANGELOG.md')
    repo_name = os.path.split(repo_directory)[1]
    commit_log = utils.repo_commits_log(repo)

    releases = []

    previous_version = unreleased_string
    first_commit = True
    current_version = None

    commits_dict = {}
    for section_dict in SECTIONS:
        commits_dict[section_dict['section']] = OrderedDict()

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
            default_scope = '*'
            org_string = summary

            for section_dict in SECTIONS:
                break_flag = False
                current_section = section_dict['section']
                section_keywords = section_dict['type_keywords']
                for current_keyword in section_keywords:
                    if org_string.lower().startswith(current_keyword):
                        default_section = current_section
                        break_flag = True
                        break
                if break_flag:
                    break

            current_commit_dict = OrderedDict()
            current_commit_dict['summary'] = summary
            current_commit_dict['commit_sha'] = commit['commit_sha']
            current_commit_dict['commit_url'] = utils.generate_github_repo_commit_url(repo_name, commit['commit_sha'])

            regex_result = re.match(r"([a-zA-Z0-9_ ]+)\(([a-zA-Z0-9_ -\./]+)\)[:]?([a-zA-Z0-9_,;:'\" \.\(\)#-]+)", current_commit_dict['summary'])
            if regex_result:
                default_scope = regex_result.group(2).lower()
                current_commit_dict['summary'] = regex_result.group(3)

            if default_scope not in commits_dict[default_section]:
                commits_dict[default_section][default_scope] = OrderedDict({'commits': []})

            commits_dict[default_section][default_scope]['commits'].append(current_commit_dict)
            commit_count = commit_count + 1

        if is_release:
            if current_version != previous_version:
                filter_release = False
                # print('Changed {} to {}, {}'.format(previous_version, current_version, commit_count))
                current_release = OrderedDict()
                current_release['version'] = previous_version
                current_release['commits'] = commits_dict
                current_release['commit_count'] = commit_count
                current_release['authored_date'] = release_authored_date

                if include_unreleased is False and current_release['version'] == unreleased_string:
                    filter_release = True

                if not filter_release:
                    releases.append(current_release)
                previous_version = version
                release_authored_date = commit_authored_date
                commits_dict = OrderedDict()
                for section_dict in SECTIONS:
                    commits_dict[section_dict['section']] = OrderedDict()
                commit_count = 0

        first_commit = False

    if override_release:
        first_version = releases[0]['version']
        if unreleased_string != first_version:
            current_release = OrderedDict()
            current_release['version'] = unreleased_string
            current_release['commits'] = {}
            current_release['commit_count'] = 0
            current_release['authored_date'] = time.strftime("%Y-%m-%d", time.gmtime())
            releases.insert(0, current_release)
            # releases = [current_release] + releases

    template_context = {'releases': releases, 'sections': SECTIONS}

    # print([release['version'] for release in template_context['releases']])

    rendered_template = utils.render_template('changelog.jinja2', template_context)

    with open(changelog_path, 'w') as f:
        for current_line in rendered_template:
            f.write(current_line)


if __name__ == '__main__':
    create_changelog('git-working/ozp-center')
