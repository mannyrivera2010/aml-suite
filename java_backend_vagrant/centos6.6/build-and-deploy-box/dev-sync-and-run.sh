#!/usr/bin/env bash

# this script does two things:
# 1. run vagrant rsync to move code from host -> VM
# 2. execute a script on the VM

# the idea is that a developer working on their host box could run this single
# script (from their host) to redeploy their updates to the VM

# NOTE: you must run this script from this directory

# move code over to VM (see Vagrantfile for rsync directory on host)
vagrant rsync

# change the script invoked here based on your own needs
vagrant ssh -c "/vagrant/dev-scripts/webtop-prebuilt-redeploy.sh"
#Front end
# Apps copied first
# vagrant ssh -c "/vagrant/dev-scripts/apps-prebuilt-redeploy.sh"
# Then IWC is added both to static and bower dependencies
# vagrant ssh -c "/vagrant/dev-scripts/iwc-prebuilt-redeploy.sh"
# Legacy adapter is added wherever IWC is added
# vagrant ssh -c "/vagrant/dev-scripts/legacy-adapter-prebuilt-redeploy.sh"