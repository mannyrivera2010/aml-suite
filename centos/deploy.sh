#!/usr/bin/env bash

# This will re-deploy the ozp applications on a pre-configured box

# This makes several assumptions:
#	1. We aren't changing the security plugin in ozp-rest
#	2. The test data doesn't need to be reloaded

# stop the server and remove existing apps
sudo service tomcat stop
sudo rm -rf /var/lib/tomcat/webapps/marketplace /var/lib/tomcat/webapps/marketplace.war

rm -rf /ozp-static-deployment/center/*
rm -rf /ozp-static-deployment/hud/*
rm -rf /ozp-static-deployment/webtop/*
rm -rf /ozp-static-deployment/iwc/*
rm -rf /ozp-static-deployment/demo_apps/*


# assume all release files are in /ozp-artifacts with common names
sudo cp /ozp-artifacts/marketplace.war /var/lib/tomcat/webapps/
sudo chown tomcat /var/lib/tomcat/webapps/marketplace.war
sudo tar -C /ozp-static-deployment/center -xzvf /ozp-artifacts/center.tar.gz --strip 1
sudo tar -C /ozp-static-deployment/hud -xzvf /ozp-artifacts/hud.tar.gz --strip 1
sudo tar -C /ozp-static-deployment/webtop -xzvf /ozp-artifacts/webtop.tar.gz --strip 1
sudo tar -C /ozp-static-deployment/iwc -xzvf /ozp-artifacts/iwc.tar.gz --strip 1
sudo tar -C /ozp-static-deployment/demo_apps -xzvf /ozp-artifacts/demo_apps.tar.gz --strip 1

# change all OzoneConfig.js files as needed

# copy and modify the nginx conf file to 

sudo chown -R nginx /ozp-static-deployment

sudo service tomcat start

# - - - - - - - - - - - - - - - - - - - - - 
# if we need to re-load test data
# - - - - - - - - - - - - - - - - - - - - - 
sudo service tomcat stop
# clear the elasticsearch data: 
curl -XDELETE 'http://localhost:9200/marketplace'
# delete the database
mysql -u root -ppassword -Bse "DROP DATABASE ozp; CREATE DATABASE ozp;"
# re-create the database
mysql -u ozp -pozp ozp < /ozp-artifacts/mysqlCreate.sql
# restart the server
sudo service tomcat start
# after the server is up and running, reload test data via newman. Note that 
# the urls for the applications in the test data need to be set accordingly, 
# perhaps something like this:
# sed -i 's/http:\/\/ozone-development.github.io\/ozp-demo/https:\/\/130.72.123.33:7799\/demo_apps/g' postman/data/listingData.json
newman -k -c postman/createSampleMetaData.json -e postman/env/ci-develop.json
newman -k -c postman/createSampleListings.json -e postman/env/ci-develop.json -n 32 -d postman/data/listingData.json









