#!/usr/bin/env bash

# Installs dependencies for OZP development box

# Software versions:
# nginx: 1.9.4 (August 2015), built from source
# python: 3.4.3 (February 2015), built from source
# postgresql: 9.4.5 (October 2015)
# Node: 0.12.7 (July 2015)

# This script is meant to be run from the main bootstrap.sh script

################################################################################
#                           Installation
################################################################################

# install CentOS 7 EPEL repo
sudo yum install epel-release -y

sudo yum install git vim -y

# for nginx (with ssl module)
sudo yum install -y pcre pcre-devel

# for metrics
# TODO: php-fpm?
sudo yum install mysql-server php-devel php-mbstring php-gd php-xml php-pdo php-mysql php-fpm -y

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
cd $HOME_DIR
wget https://raw.githubusercontent.com/ozone-development/dev-tools/master/node-version-manager/set_node_version.sh -O set_node_version.sh
mkdir node_versions

# install node version 0.12.7
cd node_versions
mkdir 0.12.7; cd 0.12.7
wget https://nodejs.org/download/release/v0.12.7/node-v0.12.7-linux-x64.tar.gz
tar -xzvf node-v0.12.7-linux-x64.tar.gz --strip 1
# use node version
cd $HOME_DIR
source ./set_node_versions.sh 0.12.7

# install PostgreSQL 9.4.5 from source
# install dependencies
sudo yum install -y readline-devel libtermcap-devel
cd $HOME_DIR
wget https://ftp.postgresql.org/pub/source/v9.4.5/postgresql-9.4.5.tar.gz
tar xfz postgresql-9.4.5.tar.gz
cd postgresql-9.4.5
./configure
make
sudo make install
# fix permissions
sudo find /usr/local/pgsql -type f -exec chmod 644 {} \;
sudo find /usr/local/pgsql -type d -exec chmod 755 {} \;
sudo find /usr/local/pgsql/bin -type f -exec chmod 755 {} \;

# install nginx 1.9.4 from source
cd $HOME_DIR
wget http://nginx.org/download/nginx-1.9.4.tar.gz
tar xzf nginx-1.9.4.tar.gz
cd nginx-1.9.4
./configure --with-http_ssl_module
make
sudo make install