#!/usr/bin/env bash


HOMEDIR=/home/vagrant
# Not sure what is causing these permission issues, but fix them here
sudo chown -R vagrant ${HOMEDIR}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#							Build backend	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}
rm -rf ozp-rest
git clone https://github.com/ozone-development/ozp-rest.git
echo "git clone of ozp-rest complete"
cd ozp-rest
grails war
echo "build of ozp-rest complete"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#							Build frontend	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}
rm -rf ozp-hud ozp-center ozp-iwc ozp-webtop ozp-demo

git clone https://github.com/ozone-development/ozp-hud.git
git clone https://github.com/ozone-development/ozp-center.git
git clone https://github.com/ozone-development/ozp-iwc.git
git clone https://github.com/ozone-development/ozp-webtop.git
git clone https://github.com/ozone-development/ozp-demo.git

# - - - - - - - - - - - - - - - - - - - 
# 				IWC
# - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}/ozp-iwc
npm install && bower install
grunt --force

# - - - - - - - - - - - - - - - - - - - 
# 				Webtop
# - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}/ozp-webtop
npm install && bower install
grunt build
grunt compile

# - - - - - - - - - - - - - - - - - - - 
# 				Center
# - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}/ozp-center
npm install
npm run build

# - - - - - - - - - - - - - - - - - - - 
# 				Hud
# - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}/ozp-hud
npm install
npm run build

# - - - - - - - - - - - - - - - - - - - 
# 				Demo apps
# - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}/ozp-demo
npm install && bower install
