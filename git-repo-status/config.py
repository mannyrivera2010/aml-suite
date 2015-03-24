"""
Configuration

Assumes every repo has a master and develop branch

Release branches named release-vX.Y.Z

Feature branches named issue-XYZ-helpful-text

Hotfix branches named hotfix-issue-XYZ-helpful-text
"""

# local directory containing all of the git repos
CLONE_DIR = '/Users/Alan/ozp-repos'

# git repos that should be in the above directory
REPOS = ['ozp-webtop', 'center-ui', 'hud-ui', 'ozp-demo', 'ozp-iwc', 'icons',
         'ozp-react-commons']