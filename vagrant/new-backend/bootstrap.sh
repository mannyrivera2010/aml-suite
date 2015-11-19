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

HOME=/home/vagrant

################################################################################
#                           Installation
################################################################################

# install CentOS 7 EPEL repo
sudo yum install epel-release -y

sudo yum install git vim -y

# install nginx
sudo yum install nginx -y
# install development tools
sudo yum groupinstall "Development tools" -y
# install other dependencies that might be useful
sudo yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel -y

# install python 3.4.3 (build from source)
wget https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz
tar -xzf Python-3.4.3.tgz
cd Python-3.4.3
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make
sudo make altinstall

# install custom node version manager
cd $HOME
wget https://raw.githubusercontent.com/ozone-development/dev-tools/master/node-version-manager/set_node_version.sh -O set_node_version.sh
mkdir node_versions

# install node version 0.12.7
cd node_versions
mkdir 0.12.7; cd 0.12.7
wget https://nodejs.org/download/release/v0.12.7/node-v0.12.7-linux-x64.tar.gz
tar -xzvf node-v0.12.7-linux-x64.tar.gz --strip 1
# use node version
cd $HOME
source ./set_node_versions.sh 0.12.7

# install PostgreSQL 9.4.5 from source
# install dependencies
sudo yum install -y readline-devel libtermcap-devel
cd $HOME
wget https://ftp.postgresql.org/pub/source/v9.4.5/postgresql-9.4.5.tar.gz
tar xfz postgresql-9.4.5.tar.gz
cd postgresql-9.4.5
./configure
make
sudo make install


################################################################################
#                           Configuration
################################################################################
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
/usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data >logfile 2>&1 &
# NOTE: do not install postgresql-libs. Doing so caused the problem described
# here:  http://initd.org/psycopg/docs/faq.html#problems-compiling-and-deploying-psycopg2
# Instead:
export LD_LIBRARY_PATH=/usr/local/pgsql/lib:$LD_LIBRARY_PATH

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
#                             SSL Certificates
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
