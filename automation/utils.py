"""
Utils File
"""
import jinja2
import binascii
import logging
import os
import time

from versions import parse_version_string
import log
import settings


log.configure_logging()
logger = logging.getLogger('default')


def render_template(tpl_path, context):
    path, filename = os.path.split(tpl_path)

    template_loader = jinja2.Environment(
        loader=jinja2.FileSystemLoader(path or './')
    )
    template = template_loader.get_template(filename)
    return template.render(context)


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

        summary = commit_obj.summary

        commit_obj_tags = repo_tag_mapping.get(commit_sha, [])

        version1 = None
        version2 = None

        version_object = None
        release_flag = False

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
        current_data['authored_date'] = time.strftime("%Y-%m-%d", time.gmtime(commit_obj.authored_date))
        current_data['authored_date_time'] = time.strftime("%Y-%m-%d  %H:%M:%S", time.gmtime(commit_obj.authored_date))
        current_data['author'] = commit_obj.author
        current_data['summary'] = commit_obj.summary
        current_data['is_head'] = is_head
        current_data['tags'] = commit_obj_tags
        current_data['version_object'] = version_object
        current_data['is_release'] = release_flag

        output.append(current_data)

    return output
