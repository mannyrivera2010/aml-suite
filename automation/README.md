## Release Automation Python Script
### Setup
Preq: If REPO_CLONE_MODE=git, the github private/public keys is required

Goto to settings.py and change GIT_USERNAME and GIT_EMAIL

````shell
# Create Python Environment and installs requirements.txt
make pyenv

# Activate Python Environment
source env/bin/activate

python process.py
````
