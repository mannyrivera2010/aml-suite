import github
from github import Github
import constants
import logging
import log


log.configure_logging()
logger = logging.getLogger('default')


class GitHubInfo(object):

    def __init__(self, login_or_token=None):
        self.github_client = Github(login_or_token)
        self.cached_results = {}

    def _get_all_repos_pull_request(self):
        org_repos = self.get_org_repos()

        for repo in org_repos:
            if not self.cached_results.get('org_repos_%s_pull_requests' % repo):
                output_prs = []

                for pr in repo.get_pulls():
                    output_prs.append(pr)

                self.cached_results['org_repos_%s_pull_requests' % repo] = output_prs

    def get_repo_pull_request(self, repo):
        """
        https://api.github.com/repos/ozone-development/ozp-center/pulls
        """
        self._get_all_repos_pull_request()
        return self.cached_results.get('org_repos_%s_pull_requests' % repo)

    def check_open_pull_requests(self):
        org_repos = self.get_org_repos()
        for repo in org_repos:
            pull_requests = self.get_repo_pull_request(repo)
            logger.info("%s - Number of Open Pull Requests: %s" % (repo.name, len(pull_requests)))

            for pull_request in pull_requests:
                logger.info("%s - (%s-%s) [%s] %s" % (repo.name,
                                              pull_request.id,
                                              pull_request.state,
                                              pull_request.user._identity,
                                              pull_request.title))

    def get_org_repos(self):
        """
        Check to see if ozp repo exist, if not exist clone it from github repo clone url

        Ignores Github Rate Limiting and logs a warning

        Return:
            { '{repo name}':{repo obj} ....}
        """
        try:
            if not self.cached_results.get('org_repos'):
                self.cached_results['org_repos'] = self.github_client.get_organization('ozone-development').get_repos()

            cached_repos = self.cached_results['org_repos']

            filter_repos = []

            for repo in cached_repos:
                if repo.name in constants.REPOS:
                    filter_repos.append(repo)

            return filter_repos
        except github.GithubException as err:
            logger.warn('Github issue: %s ' % err)
        except socket.timeout as err:
            logger.warn('Github timeout issue : %s ' % err)
        return []

if __name__ == '__main__':
    githubinfo = GitHubInfo()
    logger.info("******** Checking Open Pull Requests for all repos *********")
    githubinfo.check_open_pull_requests()

    # org_repos = githubinfo.get_org_repos()
    #
    # for repo in org_repos:
    #     pull_requests = githubinfo.get_repo_pull_request(repo)
    #     for pull_request in pull_requests:
    #
    #         print(pull_request)
