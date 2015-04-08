#!/usr/bin/env bash

# Use case: developer working on ozp-rest on host box, needs to build and
#  redeploy on VM. Assumes all config files are already in place and no changes
# to them, or do the database, are required

# Assumes code on host lives
# in ~/ozp/ozp-rest (modify the Vagrantfile if ~/ozp is not where you want
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

cd ${RSYNC_DIR}/ozp-rest
source ${HOMEDIR}/.gvm/bin/gvm-init.sh
gvm use grails 2.3.7
gvm current grails
grails war
printf "\n****************\n  finished compiling war file \n****************\n"

# stop the server and remove existing apps
sudo service tomcat stop
sudo rm -rf /var/lib/tomcat/webapps/marketplace /var/lib/tomcat/webapps/marketplace.war

# install new apps
sudo mv target/marketplace.war /var/lib/tomcat/webapps/
sudo chown tomcat /var/lib/tomcat/webapps/marketplace.war
sudo service tomcat start


printf "\n****************\n  Finished ozp-rest rebuild and redeploy \n****************\n"
