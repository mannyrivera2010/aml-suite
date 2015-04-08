#!/usr/bin/env bash


HOMEDIR=/home/vagrant
# Not sure what is causing these permission issues, but fix them here
sudo chown -R vagrant ${HOMEDIR}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#							Build backend
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd ${HOMEDIR}
rm -rf ozp-rest
printf "\n********************\n cloning ozp-rest \n********************\n"
git clone https://github.com/ozone-development/ozp-rest.git
printf "\n******************\n finished cloning ozp-rest \n******************\n"
cd ${HOMEDIR}/ozp-rest/
source ${HOMEDIR}/.gvm/bin/gvm-init.sh
gvm use grails 2.3.7
gvm current grails
grails war
printf "\n****************\n  finished compiling war file \n****************\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#							Build frontend
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd ${HOMEDIR}
rm -rf ozp-hud ozp-center ozp-iwc ozp-webtop ozp-demo

printf "\n******************\n  cloning front-end repos \n******************\n"
git clone https://github.com/ozone-development/ozp-hud.git
git clone https://github.com/ozone-development/ozp-center.git
git clone https://github.com/ozone-development/ozp-iwc.git
git clone https://github.com/ozone-development/ozp-iwc-owf7-widget-adapter.git
git clone https://github.com/ozone-development/ozp-webtop.git
git clone https://github.com/ozone-development/ozp-demo.git
printf "\n**************\n  finished cloning front-end repos \n*************\n"

# stop Bower from promting user about usage statistics
# http://stackoverflow.com/questions/22387857/stop-bower-from-asking-for-statistics-when-installing
export CI=true

# - - - - - - - - - - - - - - - - - - -
# 				Webtop
# - - - - - - - - - - - - - - - - - - -
# NOTE: for some strange reason, it seems webtop (sometimes) needs to be built
# first
printf "\n********************\n  Building Webtop \n********************\n"
cd ${HOMEDIR}/ozp-webtop
npm install
bower install
npm run build
npm run compile
printf "\n******************\n  Finished Building Webtop \n******************\n"

# - - - - - - - - - - - - - - - - - - -
# 				IWC
# - - - - - - - - - - - - - - - - - - -
printf "\n********************\n  Building IWC \n********************\n"
cd ${HOMEDIR}/ozp-iwc
# TODO: remove this when PR is merged to master!!!!!!!
git checkout -b add-packaging origin/add-packaging
npm install
bower install
npm run build
printf "\n*******************\n  Finished Building IWC \n*******************\n"

# - - - - - - - - - - - - - - - - - - -
# 				Center
# - - - - - - - - - - - - - - - - - - -
printf "\n********************\n  Building Center \n********************\n"
cd ${HOMEDIR}/ozp-center
npm install
npm run build
printf "\n******************\n  Finished Building Center \n******************\n"

# - - - - - - - - - - - - - - - - - - -
# 				Hud
# - - - - - - - - - - - - - - - - - - -
printf "\n********************\n  Building HUD \n********************\n"
cd ${HOMEDIR}/ozp-hud
npm install
npm run build
printf "\n*******************\n  Finished Building HUD \n*******************\n"

# - - - - - - - - - - - - - - - - - - -
# 				Demo apps
# - - - - - - - - - - - - - - - - - - -
printf "\n********************\n  Building Demo Apps \n********************\n"
cd ${HOMEDIR}/ozp-demo
bower install
npm run prestart
printf "\n****************\n  Finished Building Demo Apps \n****************\n"
