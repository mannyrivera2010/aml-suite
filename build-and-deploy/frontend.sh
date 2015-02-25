#!/usr/bin/env bash

# clean, clone, configure, install, and deploy frontend

echo '##########    Frontend    ##########'
HOMEDIR=/home/vagrant

# Not sure what is causing these permission issues, but fix them here
sudo chown -R vagrant ${HOMEDIR}

cd ${HOMEDIR}

rm -rf static-deployment
rm -rf hud-ui center-ui ozp-iwc ozp-webtop

git clone https://github.com/ozone-development/hud-ui.git
git clone https://github.com/ozone-development/center-ui.git
git clone https://github.com/ozone-development/ozp-iwc.git
git clone https://github.com/ozone-development/ozp-webtop.git

mkdir -p ${HOMEDIR}/static-deployment/iwc
mkdir -p ${HOMEDIR}/static-deployment/webtop
mkdir -p ${HOMEDIR}/static-deployment/center
mkdir -p ${HOMEDIR}/static-deployment/hud

# TODO: bower asks if it can send usage statistics - blocks the terminal

### IWC
cd ${HOMEDIR}/ozp-iwc
npm install && bower install
grunt --force
cp -rf dist/* ${HOMEDIR}/static-deployment/iwc
# set the backend API for IWC
sed -i '/ozpIwc.apiRootUrl="api";/c\ozpIwc.apiRootUrl="https://localhost:5443/marketplace/api";' ${HOMEDIR}/static-deployment/iwc/iframe_peer.html
# repeat for the debugger
sed -i '/ozpIwc.apiRootUrl="\/api";/c\ozpIwc.apiRootUrl="https://localhost:5443/marketplace/api";' ${HOMEDIR}/static-deployment/iwc/debugger.html

### WebTop
cd ${HOMEDIR}/ozp-webtop
npm install && bower install
grunt build
grunt compile
# cp -rf bin/* ${HOMEDIR}/static-deployment/webtop
# TODO: when OzoneConfig.js exists, change default IWC bus to http://localhost:8003
cp -rf build/* ${HOMEDIR}/static-deployment/webtop

### HUD
cd ${HOMEDIR}/hud-ui
npm install
npm run build
# TODO: metrics, HUD URLs
sed -i "/API_URL/c\'API_URL': 'https://localhost:5443/marketplace'," dist/OzoneConfig.js
cp -rf dist/* ${HOMEDIR}/static-deployment/hud

### Center
cd ${HOMEDIR}/center-ui
npm install
npm run build
sed -i "/API_URL/c\'API_URL': 'https://localhost:5443/marketplace'," dist/OzoneConfig.js
# TODO: metrics, HUD URLs
cp -rf dist/* ${HOMEDIR}/static-deployment/center

sudo cp /vagrant/static_nginx.conf /etc/nginx/conf.d/
sudo nginx -s reload