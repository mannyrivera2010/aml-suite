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
vagrant ssh -c "/vagrant/dev-scripts/backend-rebuild-redeploy.sh"