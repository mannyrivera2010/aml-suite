"""
Access to Github


import githubinfo; r = githubinfo.GithubRequests(); r.get_repo_pull_request('ozp-backend')
"""
import settings
import logging
import log
import requests

log.configure_logging()
logger = logging.getLogger('default')


class GithubRequests(object):

    def get_repo_pull_request(self, repo_name):
        """
        Get Repo Pull Request
        """
        url = 'https://api.github.com/repos/{}/{}/pulls?state=all'.format(settings.DEFAULT_ORGANIZATION, repo_name)
        request_json = requests.get(url).json()
        pull_requests = []
        for json_obj in request_json:
            temp_data = {}

            keys = [
                'html_url',
                'number',
                'state',
                'title',
                'created_at',
                'updated_at',
                'closed_at',
                'merged_at',
                'assignees',
                'requested_reviewers'
            ]

            for key in keys:
                temp_data[key] = json_obj[key]

            pull_requests.append(temp_data)
        return pull_requests


if __name__ == '__main__':
    githubinfo = GithubRequests()
    logger.info("******** Checking Open Pull Requests for all repos *********")
    print(githubinfo.get_repo_pull_request('ozp-backend'))

    # org_repos = githubinfo.get_org_repos()
    #
    # for repo in org_repos:
    #     pull_requests = githubinfo.get_repo_pull_request(repo)
    #     for pull_request in pull_requests:
    #
    #         print(pull_request)
