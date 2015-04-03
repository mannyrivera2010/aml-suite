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

# stop Bower from promting user about usage statistics
# http://stackoverflow.com/questions/22387857/stop-bower-from-asking-for-statistics-when-installing
export CI=true

# - - - - - - - - - - - - - - - - - - - 
# 				IWC
# - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}/ozp-iwc
# TODO: remove this when PR is merged to master!!!!!!!
git checkout -b add-packaging origin/add-packaging
npm install
npm run bower
npm run build

# - - - - - - - - - - - - - - - - - - - 
# 				Webtop
# - - - - - - - - - - - - - - - - - - - 
cd ${HOMEDIR}/ozp-webtop
npm install 
npm run bower
npm run build
npm run compile

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
npm run postinstall
npm run prestart
