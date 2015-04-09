#!/usr/bin/env bash

# Use case: developer working on ozp-iwc-owf7-widget-adapter on host box, building on host box,
# needs to redeploy pre-built adapter updates on VM.

# Assumes code on host lives
# in ~/ozp/ozp-iwc-owf7-widget-adapter (modify the Vagrantfile if ~/ozp is not where you want
# your host code to live, then modify this script accordingly)

# modify the dev-sync-and-run.sh script to run this script for easier use from
# the host

# make sure these variables are the same as those used during the initial
# vagrant up, or this will not work
HOMEDIR=/home/vagrant
PACKAGE_DIR=/ozp-artifacts
STATIC_DEPLOY_DIR=/ozp-static-deployment
# CHANGE ME to your host's IP address
HOST_IP="localhost"

RSYNC_DIR=${HOMEDIR}/ozp


# remove old build deployment
sudo rm -rf ${STATIC_DEPLOY_DIR}/iwc-owf7-widget-adapter/*

# copy pre-built adapter to the deployment directory
sudo cp -r ${RSYNC_DIR}/ozp-iwc-owf7-widget-adapter/dist/* ${STATIC_DEPLOY_DIR}/iwc/

# fix ownership and restart nginx
sudo chown -R nginx ${STATIC_DEPLOY_DIR}
sudo service nginx restart
printf "\n****************\n  Finished adapter re-deploy \n****************\n"
