#!/usr/bin/env bash

# clean, clone, configure, install, and deploy backend
echo '##########    Backend    ##########'
HOMEDIR=/home/vagrant

cd ${HOMEDIR}
rm -rf ozp-rest
git clone https://github.com/ozone-development/ozp-rest.git
echo 'git clone of ozp-rest complete'
cd ozp-rest

# re-create the ozp-rest database
mysql -u root -ppassword -Bse "DROP DATABASE ozp; CREATE DATABASE ozp;"
mysql -u ozp -pozp ozp < mysqlCreate.sql
echo 'created ozp database'

########################################
# If Tomcat deployment:
########################################

# copy MarketplaceConfig.groovy to tomcat
sudo cp /vagrant//configs/ozp-rest/MarketplaceConfig.groovy /usr/share/tomcat7/lib

# copy OzoneConfig.properties to tomcat
sudo cp ${HOMEDIR}/ozp-rest/grails-app/conf/OzoneConfig.properties /usr/share/tomcat7/lib

# copy the security plugin files to tomcat
sudo cp -r ${HOMEDIR}/ozp-rest/grails-app/conf/ozone-security-beans /usr/share/tomcat7/lib
sudo cp ${HOMEDIR}/ozp-rest/grails-app/conf/SecurityContext.xml /usr/share/tomcat7/lib
sudo cp ${HOMEDIR}/ozp-rest/grails-app/conf/users.properties /usr/share/tomcat7/lib

# update /var/lib/tomcat7/conf/server.xml, specifically the Connector for
# port 8443 (this assumes the password to the keystore file is 'password'):

# <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
#    maxThreads="150" scheme="https" secure="true" clientAuth="false"
#    sslProtocol="TLS" keystoreFile="/usr/share/tomcat7/server.keystore"
#    keystorePass="password" />


# Build
# NOTE: This currently requires resources (like the security plugin) that exist
#       exclusively on Next Century servers
cd ${HOMEDIR}/ozp-rest
grails war

# deploy war to tomcat server
sudo cp target/marketplace.war /var/lib/tomcat7/webapps/
# Restart tomcat
sudo /etc/init.d/tomcat7 restart


########################################
# If Grails dev deployment
########################################
# grails run-app -https


# load sample data
# TODO: these apps must be served locally and the test data changed appropriately!
# sed -i 's/http:\/\/ozone-development.github.io\/ozp-demo/https:\/\/130.72.123.33:7799\/demo_apps/g' postman/data/listingData.json
echo "After the server is up and running, run these commands to load test data:"
echo "newman -k -c postman/createSampleMetaData.json -e postman/env/localDev.json"
echo "newman -k -c postman/createSampleListings.json -e postman/env/localDev.json -n 32 -d postman/data/listingData.json"
echo "newman -k -c postman/createSampleNotifications.json -e postman/env/localDev.json"