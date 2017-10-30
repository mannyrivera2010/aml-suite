## Release Automation Python Script
### Setup
Preq: Goto to settings.py
 - If REPO_CLONE_MODE=git, the github private/public keys is required
 - Goto settings.py Change GIT_USERNAME and GIT_EMAIL

````shell
# Create Python Environment and installs requirements.txt
make pyenv

# Activate Python Environment
source env/bin/activate

# Creates Release # (Tag)
python process.py
````

### Jenkins Creates Build (tar files) - optional 
