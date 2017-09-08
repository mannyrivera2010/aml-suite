GIT_BASE_DIR = 'git-working'
DAYS = 14

# Default Organization
DEFAULT_ORGANIZATION = 'aml-development'

# Default Repos to manage - Used for releases
# Order Matters
REPOS = [
    'ozp-help',
    'ozp-react-commons',
    'ozp-center',
    'ozp-hud',
    'ozp-webtop',
    # 'ozp-rest',
    # 'ozp-iwc',
    # 'ozp-iwc-owf7-widget-adapter',
    # 'ozp-iwc-angular',
    'ozp-demo',
    'ozp-backend'
]

REPO_CLONE_MODE = 'git'  # git/https

GIT_USERNAME = 'Manny Rivera'
GIT_EMAIL = 'mannyrivera2010@gmail.com'

DETECTORS = [
    'PythonFileDetector',
    'PackageFileDetector',
    'NpmShrinkwrapDetector',
    'ChangeLogDetector'
]
