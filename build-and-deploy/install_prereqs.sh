#!/usr/bin/env bash
# Install pre-reqs for the following:
#   ozp-rest
#   metrics/analytics (piwik)
#   Center, HUD, Webtop, IWC
echo '##########    Install Prereqs for OZP Build and Deployment    ##########'
HOMEDIR=/home/vagrant

################################################################################
# Configure Box
################################################################################

sudo apt-get update

# remove current version of mysql
sudo apt-get purge mysql-client-core-5.5 -y

# install mysql with root password 'password' (database used for ozp-rest backend)
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get -y install mysql-server

# (default-jdk installs java 7 as of Dec 2014 (JDK includes JRE)
sudo apt-get install curl unzip nodejs npm git default-jdk tomcat7 tomcat7-admin mysql-client-core-5.5 nginx  -y

# download elasticsearch
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb
sudo dpkg -i elasticsearch-1.4.2.deb
# start elasticsearch on boot
sudo update-rc.d elasticsearch defaults 95 10
# start the elasticsearch service
sudo /etc/init.d/elasticsearch start

# fix nodejs on ubuntu as per http://stackoverflow.com/questions/26320901/cannot-install-nodejs-usr-bin-env-node-no-such-file-or-directory
sudo ln -s /usr/bin/nodejs /usr/bin/node

# install newman for adding test data and other front-end tools
sudo npm install newman grunt-cli bower gulp -g

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
# NOTE: This prints to STDERR, don't know why
gvm install grails 2.3.7
gvm use grails 2.3.7

# configure mariadb/mysql
mysql -u root -ppassword -Bse "create user 'ozp'@'localhost' identified by 'ozp';"
mysql -u root -ppassword -Bse "create database ozp;"
mysql -u root -ppassword -Bse "grant all privileges on *.* to 'ozp'@'localhost';"

# change elastic search cluster name to ozpdemo04 in /etc/elasticsearch/elasticsearch.yml
# cluster.name: ozpdemo04
sudo sed -i '/#cluster.name: elasticsearch/c\cluster.name: ozpdemo04' /etc/elasticsearch/elasticsearch.yml

# create the temp directory used by elasticsearch and set permissiosn
sudo mkdir -p /usr/share/tomcat7/temp
sudo chown -R tomcat7 /usr/share/tomcat7/temp

# create /usr/share/tomcat7/logs dir and chown -r tomcat7 logs/
sudo mkdir -p /usr/share/tomcat7/logs
sudo chown -R tomcat7 /usr/share/tomcat7/logs

# create directory to hold images
sudo mkdir -p /usr/share/tomcat7/images
sudo chown -R tomcat7 /usr/share/tomcat7/images/

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "Now do the following things manually..."
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "

echo "increase tomcat7 memory from 128MB to 512MB in /etc/default/tomcat7 - look for -Xmx128m"

echo "add user 'tomcat' to /var/lib/tomcat7/conf/tomcat-users.xml (for logging into the tomcat web application manager)"
echo "<user name="tomcat" password="password" roles="admin,manager-gui" />"

# Create certs for tomcat use
# TODO: requires user interaction
echo "create your certs using this cmd: "
echo "sudo keytool -genkey -alias tomcat -keyalg RSA -keystore /usr/share/tomcat7/.keystore"