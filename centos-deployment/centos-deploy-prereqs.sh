#!/usr/bin/env bash

# - - - - - - - - - - - - - - -
# Installation
# - - - - - - - - - - - - - - -

# remove old mysql
sudo yum remove mysql mysql-*

# Remi dependency on CEntOS 6
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Install MySQL 5.5 server
sudo yum --enablerepo=remi,remi-test install mysql mysql-server

# Install JRE
sudo yum install java-1.7.0-openjdk -y

# Install JDK
sudo yum install java-1.7.0-openjdk-devel -y

# Install Tomcat 7
sudo yum install tomcat -y

# Install elasticsearch
sudo rpm --import https://packages.elasticsearch.org/GPG-KEY-elasticsearch

# Add /etc/yum.repos.d/elasticsearch.repo containing (uncommented):

# [elasticsearch-1.4]
# name=Elasticsearch repository for 1.4.x packages
# baseurl=http://packages.elasticsearch.org/elasticsearch/1.4/centos
# gpgcheck=1
# gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
# enabled=1

# Install elasticsearch
sudo yum install elasticsearch

# Install Node
# First enable access to EPEL repo
sudo yum install epel-release

# Install nodejs and npm
sudo yum install nodejs npm

# Install newman (for adding test data)
sudo npm install -g newman

# Install nginx
sudo yum install nginx

# Install git
sudo yum install git


# - - - - - - - - - - - - - - -
# configure elastic search
# - - - - - - - - - - - - - - -
# change elastic search cluster name to ozpdemo04 in /etc/elasticsearch/elasticsearch.yml
# cluster.name: ozpdemo04
sudo sed -i '/#cluster.name: elasticsearch/c\cluster.name: ozpdemo04' /etc/elasticsearch/elasticsearch.yml

# create the temp directory used by elasticsearch and set permissiosn
sudo mkdir -p /usr/share/tomcat7/temp
sudo chown -R tomcat7 /usr/share/tomcat7/temp

# Start automatically on boot
sudo chkconfig --add elasticsearch

# Start elasticsearch service
sudo /etc/init.d/elasticsearch start



# - - - - - - - - - - - - - - -
# configure MySQL 
# - - - - - - - - - - - - - - -
# set the root password ('password')
# remove Test database
# remove anonymous users
# disable root login remotely
/usr/bin/mysql_secure_installation

# start mysql on boot
sudo chkconfig --level 345 mysqld on

# create user ozp 
mysql -u root -ppassword -Bse "create user 'ozp'@'localhost' identified by 'ozp';"
# create ozp database
mysql -u root -ppassword -Bse "create database ozp;"
# grant ozp privs
mysql -u root -ppassword -Bse "grant all privileges on *.* to 'ozp'@'localhost';"


# - - - - - - - - - - - - - - -
# configure Tomcat 
# - - - - - - - - - - - - - - -
# create directory to hold images
sudo mkdir -p /usr/share/tomcat7/images
sudo chown -R tomcat /usr/share/tomcat7/images/

# increase tomcat7 memory from 128MB to 512MB in /etc/tomcat/tomcat.conf - look for JAVA_OPTS
# in the same file, append this to the same place (JAVA_OPTS): -XX:MaxPermSize=256m

# add user 'tomcat' to /etc/tomcat/tomcat-users.xml (for logging into the tomcat web application manager)
# <user name="tomcat" password="password" roles="admin,manager-gui" />

# TODO: start tomcat on boot



# - - - - - - - - - - - - - - -
# configure nginx 
# - - - - - - - - - - - - - - -
# set up SSL for nginx reverse proxy
sudo mkdir /etc/nginx/ssl

# start nginx
sudo /etc/init.d/nginx start


# - - - - - - - - - - - - - - -
# configure ssl certs for tomcat and nginx
# - - - - - - - - - - - - - - -
# first, generate a private key
echo "openssl genrsa -des3 -out server.key 1024"
# generate a CSR (use ozpdev for CN)
echo "openssl req -new -key server.key -out server.csr"
# remove passphrase from the key
echo "cp server.key server.key.org"
echo "openssl rsa -in server.key.org -out server.key"
# generate a self-signed certificate
echo "openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt"
# now we need to generate a Java keystore for use with Tomcat using these certs
# convert the x509 cert and key to a pkcs12 file
echo "openssl pkcs12 -export -in server.crt -inkey server.key -out server.p12 -name ozpdev -CAfile ca.crt -caname root"
# convert the pkcs12 file into a Java keystore
echo "keytool -importkeystore -deststorepass password -destkeypass password -destkeystore server.keystore -srckeystore server.p12 -srcstoretype PKCS12 -srcstorepass password -alias ozpdev"
# copy keystore file to java place: 
echo "sudo cp server.keystore /usr/share/tomcat"
# copy other keys to nginx place
echo "sudo cp server.crt /etc/nginx/ssl"
echo "sudo cp server.key /etc/nginx/ssl"
