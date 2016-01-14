#!/usr/bin/env bash

# Sets up a Vagrant box for OZP development that mimics production as closely
# as possible

# Software versions:
# nginx: 1.9.4 (August 2015), built from source
# python: 3.4.3 (February 2015), built from source
# postgresql: 9.4.5 (October 2015)
# Django: 1.8 (April 2015)
# Django Rest Framework: 3.2.3 (September 2015)
# Node: 0.12.7 (July 2015)


# nginx configured as reverse proxy. serves files over HTTPS. Forces client
# certificate authentication (PKI). HTTPS terminates at nginx, proxying HTTP
# requests to gunicorn for the backend.
#
# A separate gunicorn process serves the Authorization Service endpoints over
# HTTPS
#
# A local Certifcate Authority is created and used to sign both server and
# client SSL certificates
#
# Server SSL certs created for nginx and the gunicorn process serving the
# Authorization Service
#
# The Gunicorn process serving the ozp-backend api is configured for file
# logging, pid file use, and daemonization is it is done in production
#
# Postgresql is used for the ozp database. User
# postgres owns postgresql
#
#
# Config files:
#   ozp.conf (nginx config)
#   SSL certificates (CA, user certs, server certs)
#   gunicorn_ozp (init.d)
#   gunicorn_authservice (init.d)
#   nginx (init.d)
#   postgres (init.d)
#   settings.py (ozp-backend)
#   settings.py (ozp-authorization-service)
#   auth_data.json (for ozp-authorization-service)
#   OzoneConfig.js (Center, HUD, Webtop)
#   ozpIwc.conf.js (IWC)
#   OzoneConfig.js (ozp-demo)
#   OzoneConfig.js (ozp-help)
#   metrics.ini.php
#
#
# VM Use Cases:
#   demo only (just want the latest stuff running)
#   front-end dev just use VM for backend (might want to use public facing
#       endpoint if available)
#   front-end dev running code on VM. Need mechanism to sync code from host
#   to VM and to build/redeploy (front-end only) on a per-project basis
#   back-end dev running code on VM. Need mechanism to sync code from host
#   to VM and to build/redeploy (back-end only)

HOME_DIR=/home/vagrant
STATIC_DEPLOY_DIR=/ozp/static-deployment

################################################################################
#                           Installation
################################################################################
# NOTE: If you're using a base box with these dependencies installed, you can
#   skip this step
# source /vagrant/install_dependencies.sh

################################################################################
#                           Configuration and Deployment
################################################################################

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                               postgresql config
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add to ldconfig so we can find the shared library
sudo cp /vagrant/configs/ld.conf /etc/ld.so.conf.d/ozp.conf
sudo /sbin/ldconfig
# add user postgres and set password
sudo adduser postgres
echo "password" | sudo passwd "postgres" --stdin
# Create the postgres data directory and make postgres user as the owner
sudo mkdir /usr/local/pgsql/data
sudo chown postgres:postgres /usr/local/pgsql/data
# Initialize postgreSQL data directory
sudo -H -u postgres bash -c '/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data/'
# Use the postgres postmaster command to start the postgreSQL server in the background
# TODO: replace with init.d script
# /usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data >logfile 2>&1 &
# install the init script
sudo cp /vagrant/configs/init/postgres /etc/init.d/
sudo chmod +x /etc/init.d/postgres
# start postgres
sudo service postgres start
sleep 1
# NOTE: do not install postgresql-libs. Doing so caused the problem described
# here:  http://initd.org/psycopg/docs/faq.html#problems-compiling-and-deploying-psycopg2

# create new database user
# TODO: need a password?
sudo -H -u postgres bash -c 'cd $HOME;/usr/local/pgsql/bin/createuser ozp_user'

# create a new database
sudo -H -u postgres bash -c 'cd $HOME;/usr/local/pgsql/bin/createdb ozp'
# from psql cli:
sudo -H -u postgres bash -c "cd /home/postgres;/usr/local/pgsql/bin/psql -c 'GRANT ALL PRIVILEGES ON DATABASE ozp TO ozp_user;'"
# GRANT ALL PRIVILEGES ON DATABASE ozp TO ozp_user;

# note - when pip installing psycopg2, make sure pg_config is on PATH
# export PATH=/usr/local/pgsql/bin/:$PATH

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                             Create /ozp
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# open up permissions on /ozp
sudo mkdir -p /ozp
sudo find /ozp -type f -exec chmod 666 {} \;
sudo find /ozp -type d -exec chmod 777 {} \;

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                             SSL Certificates
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL certs are all pre-made. Instructions provided here to reproduce if required
#
# First, create a Root Certificate Authority that will be used to sign all other
# certificates. The Root CA's certificate will be self-signed:
#
# create the Root CA private key (no password, since this is just for testing):
#   openssl genrsa -out rootCA.key 2048
#
# generate a self-signed certificate using this private key
#   openssl req -x509 -new -nodes -key rootCA.key -days 3650 -out rootCA.pem
#
# NOTE: The above rootCA.pem must be installed into your host browser!
#
# Create a server certificate for nginx
#
#   create the key: openssl genrsa -out server.key 2048
#   create a Certificate Signing Request (CSR) for the key:
#       openssl req -new -key server.key -out server.csr
#   sign the certificate using the Root CA:
#       openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 3650
#
# These certs are in PEM format and ready to be used by nginx (it will need
# rootCA.pem, server.key, and server.crt)
#
# Now we need to create additional SSL certs for the demo users of the site
# using the exact same process that was used to create the server certs (
#   these will also need to be installed in your host machine/browser):
#
# wsmith, julia, bigbrother, obrien, jones, charrington, tparsons, etc
#
# Note that you will probably need to export the user certs in PKCS12 format
# to import them into your browser. I've had problems creating password-less
# certs, so all of the p12 certs have password: password
#
# openssl pkcs12 -export -out certificate.p12 -inkey privateKey.key -in certificate.crt -certfile rootCA.pem

# copy the certs to the right places
mkdir -p /ozp/ca_certs
mkdir -p /ozp/ca_certs/private
cp /vagrant/configs/ssl_certs/rootCA.pem /ozp/ca_certs/
cp /vagrant/configs/ssl_certs/rootCA.key /ozp/ca_certs/private

mkdir -p /ozp/server_certs
mkdir -p /ozp/server_certs/private
cp /vagrant/configs/ssl_certs/server.crt /ozp/server_certs
cp /vagrant/configs/ssl_certs/server.key /ozp/server_certs/private

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                               nginx config
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add user nginx and set password
sudo adduser nginx
echo "password" | sudo passwd "nginx" --stdin
# replace default nginx.conf
sudo cp /vagrant/configs/nginx.conf /usr/local/nginx/conf/
# copy our conf file
sudo cp /vagrant/configs/ozp_nginx.conf /usr/local/nginx/conf/ozp.conf
# install the init script
sudo cp /vagrant/configs/init/nginx /etc/init.d/
sudo chmod +x /etc/init.d/nginx

sudo mkdir -p $STATIC_DEPLOY_DIR
# fix permissions
#sudo chmod 755 $STATIC_DEPLOY_DIR
# sudo find /ozp/static-deployment -type f -exec chmod 644 {} \;
# sudo find /ozp/static-deployment -type d -exec chmod 755 {} \;
# start nginx
sudo service nginx start

# make deployment dir
sudo mkdir -p $STATIC_DEPLOY_DIR/django_static
# sudo chown -R nginx:nginx /ozp/static-deployment
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                           create new python user
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add user ozp and set password (this user will run gunicorn processes)
sudo adduser ozp
echo "password" | sudo passwd "ozp" --stdin

mkdir -p /ozp/python_envs

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                   ozp-authorization service config and deploy
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd /ozp
# get the code
# TODO: get a release instead of the source
git clone https://github.com/ozone-development/demo-auth-service.git
cd demo-auth-service
# use settings.py file
cp /vagrant/configs/settings_demoauth.py demoauth/settings.py
# use configured auth data
cp /vagrant/configs/auth_data.json main/
# install the init script
sudo cp /vagrant/configs/init/gunicorn_demoauth /etc/init.d/
sudo chmod +x /etc/init.d/gunicorn_demoauth
# deploy demoauth service
sudo service gunicorn_demoauth redeploy

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                   ozp-backend config and deploy
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mkdir -p /ozp/backend
cd /ozp/backend
cp /ozp/artifacts/new-backend.tar.gz .
tar -xzf new-backend.tar.gz --strip 1
# use settings.py file
cp /vagrant/configs/settings.py ozp/settings.py
# install the init script
sudo cp /vagrant/configs/init/gunicorn_ozp /etc/init.d/
sudo chmod +x /etc/init.d/gunicorn_ozp
# fix permissions
sudo chown -R ozp:ozp /ozp/backend
# start gunicorn
sudo service gunicorn_ozp nuke

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                   ozp front-end resources config and deploy
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudo chown -R vagrant:vagrant $STATIC_DEPLOY_DIR

# center
mkdir -p $STATIC_DEPLOY_DIR/center
rm -rf $STATIC_DEPLOY_DIR/center/*
cd $STATIC_DEPLOY_DIR/center
cp /ozp/artifacts/center.tar.gz .
tar xzf center.tar.gz --strip 1
cp /vagrant/configs/OzoneConfigCenterHud.js OzoneConfig.js

# HUD
mkdir -p $STATIC_DEPLOY_DIR/hud
rm -rf $STATIC_DEPLOY_DIR/hud/*
cd $STATIC_DEPLOY_DIR/hud
cp /ozp/artifacts/hud.tar.gz .
tar xzf hud.tar.gz --strip 1
cp /vagrant/configs/OzoneConfigCenterHud.js OzoneConfig.js

# Webtop
mkdir -p $STATIC_DEPLOY_DIR/webtop
rm -rf $STATIC_DEPLOY_DIR/webtop/*
cd $STATIC_DEPLOY_DIR/webtop
cp /ozp/artifacts/webtop.tar.gz .
tar xzf webtop.tar.gz --strip 1
cp /vagrant/configs/OzoneConfigCenterHud.js OzoneConfig.js

# Help
mkdir -p $STATIC_DEPLOY_DIR/help
rm -rf $STATIC_DEPLOY_DIR/help/*
cd $STATIC_DEPLOY_DIR/help
cp /ozp/artifacts/help.tar.gz .
tar xzf help.tar.gz --strip 1
cp /vagrant/configs/OzoneConfigCenterHud.js OzoneConfig.js

# IWC
mkdir -p $STATIC_DEPLOY_DIR/iwc
rm -rf $STATIC_DEPLOY_DIR/iwc/*
cd $STATIC_DEPLOY_DIR/iwc
cp /ozp/artifacts/iwc.tar.gz .
tar xzf iwc.tar.gz --strip 1
cp /vagrant/configs/ozpIwc.conf.js js/ozpIwc.conf.js

# Demo Apps
mkdir -p $STATIC_DEPLOY_DIR/demo_apps
rm -rf $STATIC_DEPLOY_DIR/demo_apps/*
cd $STATIC_DEPLOY_DIR/demo_apps
cp /ozp/artifacts/demo_apps.tar.gz .
tar xzf demo_apps.tar.gz --strip 1
cp /vagrant/configs/OzoneConfigDemoApps.js OzoneConfig.js

# Metrics
rm -rf $STATIC_DEPLOY_DIR/metrics
mkdir -p $STATIC_DEPLOY_DIR/metrics
mkdir -p $STATIC_DEPLOY_DIR/metrics/plugins/ClientCertificates
mkdir -p $STATIC_DEPLOY_DIR/metrics/plugins/LoginPKI
mkdir -p $STATIC_DEPLOY_DIR/metrics/plugins/AppsMallTheme
mkdir -p $STATIC_DEPLOY_DIR/metrics/plugins/UserCreatedWebsite
cd $STATIC_DEPLOY_DIR/metrics
cp /ozp/artifacts/metrics.tar.gz .
tar xzf metrics.tar.gz
# TODO: causing issues?
# cp /vagrant/configs/metrics.ini.php config/config.ini.php

cd $STATIC_DEPLOY_DIR/metrics/LoginPKI
cp /ozp/artifacts/metrics-pkilogin.tar.gz .
tar xzf metrics-pkilogin.tar.gz

sudo chown -R nginx:nginx $STATIC_DEPLOY_DIR
sudo service nginx restart

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                   metrics config and deploy
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# TODO: remove this once it makes it into the base box
# sudo yum install mysql-server php-fpm php-mysql php-mbstring -y
sudo yum install mysql-server php-devel php-mbstring php-gd php-xml php-pdo php-mysql php-fpm -y
sudo /etc/init.d/mysqld restart
# configure mysql
mysqladmin -u root password password

# configure for piwik
mysql --user=root --password=password --execute "CREATE DATABASE piwik;"
mysql --user=root --password=password --execute "CREATE USER 'piwik'@'localhost' IDENTIFIED BY 'password';"
mysql --user=root --password=password --execute "GRANT ALL ON piwik.* TO 'piwik'@'localhost';"

sudo touch /var/log/piwik.log
sudo chown nginx:nginx /var/log/piwik.log

sudo mkdir $STATIC_DEPLOY_DIR/metrics/tmp
sudo chmod -R 777 $STATIC_DEPLOY_DIR/metrics/tmp

sudo chmod -R a+w /ozp/static-deployment/metrics/config/

# start php-fpm
sudo service php-fpm start

# make sure processes are started on boot
sudo chkconfig nginx on
sudo chkconfig php-fpm on
