## Release Automation Python Script


### Setup
```shell
mkdir ~/git
cd ~/git
git clone git@github.com:aml-development/dev-tools.git
cd dev-tools/automation

# Create Python Environment and installs requirements.txt
make pyenv

# Activate Python Environment
source env/bin/activate

````

Preq: Goto to ~/git/dev-tools/settings.py
 - If REPO_CLONE_MODE=git, the github private/public keys is required
 - Goto settings.py Change GIT_USERNAME and GIT_EMAIL
 
````
# Creates Release # (Tag)
python process.py
````

Under `2017-11-08 15:48:13,356 - INFO  - ******** Start Shell Push Commands **********`
you will have commands to copy and paste

after pasting, it shall push `release` commits

DONE

### Jenkins Creates Build (tar files) - optional 
