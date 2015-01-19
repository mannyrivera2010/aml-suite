#!/usr/bin/env bash

# clean, clone, configure, install, and deploy backend
echo '##########    Backend    ##########'
HOMEDIR=/home/vagrant
# TODO: where is this deployed?
WARLOC=/var/lib/tomcat7/webapps

cd ${HOMEDIR}
rm -rf ozp-rest
rm -rf
git clone https://github.com/ozone-development/ozp-rest.git
cd ozp-rest

# re-create the ozp-rest database
mysql -u root -ppassword -Bse "DROP DATABASE ozp;"
mysql -u root -ppassword -Bse "CREATE DATABASE ozp;"
mysql -u ozp -pozp ozp < mysqlCreate.sql

####################
# Tomcat Config
####################
# change location of log files
# TODO: what and where?
# /var/lib/tomcat7/webapps/marketplace/WEB-INF/classes/mp-log4j.xml

# TODO: everything in Config dir? What exactly gets copied?
# ehcache, MarketplaceConfig.groovy, etc go to /usr/share/tomcat7/lib/

# TODO: what/where is server.xml?
# Update server.xml to all https

# TODO: can we accomplish this using the catalina script with options instead of modifying the config file?
# Modify /etc/default/tomcat7 to increase memory

# Build
cd ${HOMEDIR}/ozp-rest
# grails war

# TODO: what directory to do this for?
/vagrant/pattern_replace.sh ${HOMEDIR}/ozp-rest

# deploy war to tomcat server
# TODO: where to copy this to?
sudo /etc/init.d/tomcat7 stop
sudo rm -rf ${WARLOC}/marketplace.war ${WARLOC}/marketplace
sudo cp target/marketplace.war ${WARLOC}
# Restart tomcat
# sudo /etc/init.d/tomcat7 restart


####################
# Grails dev deployment
####################
grails stop-app
grails run-app -https --non-interactive

# load sample data
# TODO: these won't get run since the grails run-app cmd eats the console
newman -k -c postman/createSampleMetaData.json -e postman/env/localDev.json
newman -k -c postman/createSampleListings.json -e postman/env/localDev.json -n 28 -d postman/data/listingData.json