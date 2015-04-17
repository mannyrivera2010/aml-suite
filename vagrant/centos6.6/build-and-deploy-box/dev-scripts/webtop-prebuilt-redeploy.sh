#!/usr/bin/env bash

# Use case: developer working on ozp-webtop on host box, building on host box,
# needs to redeploy pre-built Webtop updates on VM.

# Assumes code on host lives
# in ~/ozp/ozp-webtop (modify the Vagrantfile if ~/ozp is not where you want
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
sudo rm -rf ${STATIC_DEPLOY_DIR}/webtop/*
# copy pre-built webtop to the deployment directory
sudo cp -r ${RSYNC_DIR}/ozp-webtop/build/* ${STATIC_DEPLOY_DIR}/webtop
# modify OzoneConfig.js
echo "window.OzoneConfig = {
	\"API_URL\": \"https://${HOST_IP}:7799/marketplace\",
    \"CENTER_URL\": \"https://${HOST_IP}:7799/center\",
    \"DEVELOPER_RESOURCES_URL\": \"#\",
    \"FEEDBACK_ADDRESS\": \"mailto:person@address.com\",
    \"HELP_URL\": \"#\",
    \"HUD_URL\": \"https://${HOST_IP}:7799/hud\",
    \"IWC_URL\": \"https://${HOST_IP}:7799/iwc\",
    \"METRICS_URL\": \"/path/to/metrics\",
    \"WEBTOP_URL\": \"https://${HOST_IP}:7799/webtop\"
};" | sudo tee ${STATIC_DEPLOY_DIR}/webtop/OzoneConfig.js
# fix ownership and restart nginx
sudo chown -R nginx ${STATIC_DEPLOY_DIR}
sudo service nginx restart
printf "\n***********\n  Finished webtop re-deploy \n***********\n"
