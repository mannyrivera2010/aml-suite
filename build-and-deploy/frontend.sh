#!/usr/bin/env bash

# clean, clone, configure, install, and deploy frontend

echo '##########    Frontend    ##########'
HOMEDIR=/home/vagrant

# Not sure what is causing these permission issues, but fix them here
sudo chown -R vagrant ${HOMEDIR}

cd ${HOMEDIR}

rm -rf static-deployment
rm -rf hud-ui center-ui ozp-iwc ozp-webtop

git clone https://github.com/ozone-development/ozp-hud.git
git clone https://github.com/ozone-development/ozp-center.git
git clone https://github.com/ozone-development/ozp-iwc.git
git clone https://github.com/ozone-development/ozp-webtop.git
git clone https://github.com/ozone-development/ozp-demo.git

mkdir -p ${HOMEDIR}/static-deployment/iwc
mkdir -p ${HOMEDIR}/static-deployment/webtop
mkdir -p ${HOMEDIR}/static-deployment/center
mkdir -p ${HOMEDIR}/static-deployment/hud
mkdir -p ${HOMEDIR}/static-deployment/demo_apps

# TODO: bower asks if it can send usage statistics - blocks the terminal

### IWC
cd ${HOMEDIR}/ozp-iwc
npm install && bower install
grunt --force
cp -rf dist/* ${HOMEDIR}/static-deployment/iwc
# set the backend API for IWC
sed -i '/ozpIwc.apiRootUrl="api";/c\ozpIwc.apiRootUrl="https://localhost:7799/marketplace/api";' ${HOMEDIR}/static-deployment/iwc/iframe_peer.html
# repeat for the debugger
sed -i '/ozpIwc.apiRootUrl="\/api";/c\ozpIwc.apiRootUrl="https://localhost:7799/marketplace/api";' ${HOMEDIR}/static-deployment/iwc/debugger.html

### WebTop
cd ${HOMEDIR}/ozp-webtop
npm install && bower install
grunt build
grunt compile
# cp -rf bin/* ${HOMEDIR}/static-deployment/webtop
cp -rf build/* ${HOMEDIR}/static-deployment/webtop
cp /vagrant/configs/webtop/OzoneConfig.js ${HOMEDIR}/static-deployment/webtop

### HUD
cd ${HOMEDIR}/ozp-hud
npm install
npm run build
cp -rf dist/* ${HOMEDIR}/static-deployment/hud
cp /vagrant/configs/hud/OzoneConfig.js ${HOMEDIR}/static-deployment/hud

### Center
cd ${HOMEDIR}/ozp-center
npm install
npm run build
cp -rf dist/* ${HOMEDIR}/static-deployment/center
cp /vagrant/configs/center/OzoneConfig.js ${HOMEDIR}/static-deployment/center

### Demo apps
cd ${HOMEDIR}/ozp-demo
npm install && bower install
cp -rf app/* ${HOMEDIR}/static-deployment/demo_apps
cp /vagrant/configs/demo_apps/OzoneConfig.js ${HOMEDIR}/static-deployment/demo_apps

sudo cp /vagrant/configs/nginx/static_nginx.conf /etc/nginx/conf.d/
sudo nginx -s reload

echo "now start the http-server to serve static files. Ideally this would be done with nginx, but making nginx \
a web server and a reverse proxy did not work out"
echo "http-server static-deployment/ -p 9093"