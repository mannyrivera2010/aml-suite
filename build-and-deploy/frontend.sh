#!/usr/bin/env bash

# clean, clone, configure, install, and deploy frontend

echo '##########    Frontend    ##########'
HOMEDIR=/home/vagrant

cd ${HOMEDIR}
rm -rf hud-ui center-ui ozp-iwc ozp-webtop

git clone https://github.com/ozone-development/hud-ui.git
git clone https://github.com/ozone-development/center-ui.git
git clone https://github.com/ozone-development/ozp-iwc.git
git clone https://github.com/ozone-development/ozp-webtop.git

mkdir -p ${HOMEDIR}/static-deployment/iwc
mkdir -p ${HOMEDIR}/static-deployment/webtop
mkdir -p ${HOMEDIR}/static-deployment/center
mkdir -p ${HOMEDIR}/static-deployment/hud

### IWC
cd ${HOMEDIR}/ozp-iwc
npm install
grunt --force
cp -rf dist/* ${HOMEDIR}/static-deployment/iwc
# set the backend API for IWC
sudo sed -i '/ozpIwc.apiRootUrl="api";/c\ozpIwc.apiRootUrl="https://localhost:5443/marketplace/api";' ${HOMEDIR}/static-deployment/iwc/iframe_peer.html
# repeat for the debugger
sudo sed -i '/ozpIwc.apiRootUrl="api";/c\ozpIwc.apiRootUrl="https://localhost:5443/marketplace/api";' ${HOMEDIR}/static-deployment/iwc/debugger.html

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

# TODO: where to do this?
cd /vagrant
./pattern_replace.sh

sudo cp /vagrant/static_nginx.conf /etc/nginx/conf.d/
sudo nginx -s reload