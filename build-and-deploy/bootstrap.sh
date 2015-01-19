#!/usr/bin/env bash
# Install pre-reqs for the following:
#   ozp-rest
#   metrics/analytics
#   Center, HUD, Webtop
echo '##########     Doing Provisioning     ##########'
HOMEDIR=/home/vagrant

###############################################################################
# Configure Box
###############################################################################

sudo apt-get update

# remove current version of mysql
sudo apt-get purge mysql-client-core-5.5

# install mysql with root password 'password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get -y install mysql-server

# (default-jdk installs java 7 as of Dec 2014 (JDK includes JRE)
sudo apt-get install curl unzip nodejs npm git default-jdk tomcat7 tomcat7-admin mysql-client-core-5.5 nginx  -y

# download elasticsearch
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb
sudo dpkg -i elasticsearch-1.4.2.deb
sudo update-rc.d elasticsearch defaults 95 10

# fix nodejs on ubuntu as per http://stackoverflow.com/questions/26320901/cannot-install-nodejs-usr-bin-env-node-no-such-file-or-directory
sudo ln -s /usr/bin/nodejs /usr/bin/node

# install newman for adding test data
sudo npm install newman -g
# install grunt for building front-end apps
sudo npm install -g grunt-cli
# install bower for building front-end apps
sudo npm install -g bower
# instal gulp for building hud and center
sudo npm install -g gulp

# set JAVA_HOME env var
echo 'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64' >> ${HOMEDIR}/.bashrc
source ${HOMEDIR}/.bashrc

# using grails wrapper so we don't need to manually install grails here
# install Groovy enVironment Manager (GVM)
curl -s get.gvmtool.net | bash
source ${HOMEDIR}/.gvm/bin/gvm-init.sh

# modify .gvm/etc/config to set gvm_auto_answer=true
# (see options here: http://gvmtool.net/)
echo "# make gvm non-interactive, great for CI environments
gvm_auto_answer=true
# prompt user to selfupdate on new shell
gvm_suggestive_selfupdate=true
# perform automatic selfupdates
gvm_auto_selfupdate=false" > ${HOMEDIR}/.gvm/etc/config

# install grails (latest version available. Can also do gvm install grails 2.2.0 for example)
# TODO: why is this printing to STDERR?
gvm install grails 2.3.7
gvm use grails 2.3.7

# configure mariadb/mysql
mysql -u root -ppassword -Bse "create user 'ozp'@'localhost' identified by 'ozp';"
mysql -u root -ppassword -Bse "create database ozp;"
mysql -u root -ppassword -Bse "grant all on ozp.* to 'ozp'@'localhost';"

###############################################################################
# Build applications
###############################################################################

# clone ozp repos
cd ${HOMEDIR}
git clone https://github.com/ozone-development/hud-ui.git
git clone https://github.com/ozone-development/center-ui.git
git clone https://github.com/ozone-development/ozp-iwc.git
git clone https://github.com/ozone-development/ozp-rest.git
git clone https://github.com/ozone-development/ozp-webtop.git

#########################
# Configure ozp-rest
#########################

cd ozp-rest/
# create the ozp-rest database
mysql -u ozp -pozp ozp < mysqlCreate.sql

# change elastic search cluster name to ozpdemo04
sudo sed -i '/#cluster.name: elasticsearch/c\cluster.name: ozpdemo04' /etc/elasticsearch/elasticsearch.yml

# change location of log files
# TODO: what and where?
# /var/lib/tomcat7/webapps/marketplace/WEB-INF/classes/mp-log4j.xml

# TODO: everything in Config dir? What exactly gets copied?
# ehcache, MarketplaceConfig.groovy, etc go to /usr/share/tomcat7/lib/

# TODO: what are we doing here?
keytool -genkey -alias tomcat -keyalg RSA -keystore /usr/share/tomcat7/.keystore

# TODO: what/where is server.xml?
# Update server.xml to all https

# TODO: can we accomplish this using the catalina script with options instead of modifying the config file?
# Modify /etc/default/tomcat7 to increase memory

# Search and Replace Script
# -------------------------
# TODO: where to do this search and replace from?
cd ${HOMEDIR}
while read pattern replacement; do
  find . -type f | xargs -i perl -pi -e "s[$pattern][$replacement]g" "{}";
done < /vagrant/vagrant-configs/build-and-deploy/patterns_to_replace.txt

cd ${HOMEDIR}/ozp-rest
grails war


##########################
# Build other apps
##########################
mkdir -p ${HOMEDIR}/static-deployment
mkdir -p ${HOMEDIR}/static-deployment/iwc
mkdir -p ${HOMEDIR}/static-deployment/webtop
mkdir -p ${HOMEDIR}/static-deployment/center
mkdir -p ${HOMEDIR}/static-deployment/hud

### IWC
cd ${HOMEDIR}/ozp-iwc
npm install
grunt --force
cp -rf dist/* ${HOMEDIR}/static-deployment/iwc

### WebTop
cd ${HOMEDIR}/ozp-webtop
npm install && bower install
grunt build
grunt compile
cp -rf bin/* ${HOMEDIR}/static-deployment/webtop

### HUD
cd ${HOMEDIR}/hud-ui
npm install
npm run build
cp -rf dist/* ${HOMEDIR}/static-deployment/hud

### Center
npm install
npm run build
cp -rf dist/* ${HOMEDIR}/static-deployment/center

###############################################################################
# Deploy applications
###############################################################################
# deploy war to tomcat server
# TODO: where to copy this to?
sudo cp target/marketplace.war /var/lib/tomcat7/webapps/
# Restart tomcat
sudo /etc/init.d/tomcat7 restart

# load sample data
cd ~/ozp-rest
newman -k -c postman/createSampleMetaData.json -e env/localDev.json
newman -k -c postman/createSampleListings.json -e env/localDev.json -n 28 -d postman/data/listingData.json

###########################################################
# Deploy static resources (IWC bus, Center, HUD, Webtop)
###########################################################
cp /vagrant/vagrant-configs/build-and-deploy/static_nginx.conf /etc/nginx/conf.d/
sudo nginx -s reload
