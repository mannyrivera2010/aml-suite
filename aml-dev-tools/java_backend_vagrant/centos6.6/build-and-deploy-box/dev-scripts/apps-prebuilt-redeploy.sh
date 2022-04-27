#!/usr/bin/env bash

# Use case: developer working on demo-apps on host box, building on host box,
# needs to redeploy app updates on VM.

# Assumes code on host lives
# in ~/ozp/ozp-iwc (modify the Vagrantfile if ~/ozp is not where you want
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
API_PATH= "https://$HOST_IP:7799/marketplace/api"
RSYNC_DIR=${HOMEDIR}/ozp


# remove old build deployment
sudo rm -rf ${STATIC_DEPLOY_DIR}/demo_apps/*
# copy pre-built iwc to the deployment directory
sudo cp -r ${RSYNC_DIR}/ozp-demo/app/* ${STATIC_DEPLOY_DIR}/demo_apps

# App configurations
sudo sed -i "0,/\(iwcUrl:\).*/s//\1\"https:\/\/${HOST_IP}:7799\/iwc\"/" ${STATIC_DEPLOY_DIR}/demo_apps/OzoneConfig.js

# fix ownership and restart nginx
sudo chown -R nginx ${STATIC_DEPLOY_DIR}
sudo service nginx restart
printf "\n****************\n  Finished IWC re-deploy \n****************\n"

