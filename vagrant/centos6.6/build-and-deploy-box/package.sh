#!/usr/bin/env bash

# Creates compressed tarballs for each of the front-end projects and collects
# the marketplace.war and sql db creation script from ozp-rest all into a
# single directory

# Assumes all projects were cloned into HOMEDIR and compiled

HOMEDIR=/home/vagrant
OUTPUTDIR=/ozp-artifacts
printf "\n********************\n  Begin packaging \n********************\n"

sudo mkdir -p ${OUTPUTDIR}
sudo rm -rf ${OUTPUTDIR}/*
sudo chown -R vagrant ${OUTPUTDIR}

cd ${HOMEDIR}
rm -rf rest-package/
mkdir rest-package; cp ozp-rest/target/marketplace.war rest-package/; cp ozp-rest/mysqlCreate.sql rest-package/
tar -czf rest-backend.tar.gz rest-package
rm -rf rest-package
mv rest-backend.tar.gz ${OUTPUTDIR}

tar -czf iwc.tar.gz ozp-iwc/dist
mv iwc.tar.gz ${OUTPUTDIR}

tar -czf iwc-owf7-widget-adapter.tar.gz ozp-iwc-owf7-widget-adapter/dist
mv iwc-owf7-widget-adapter.tar.gz ${OUTPUTDIR}

tar -czf center.tar.gz ozp-center/dist
mv center.tar.gz ${OUTPUTDIR}

tar -czf hud.tar.gz ozp-hud/dist
mv hud.tar.gz ${OUTPUTDIR}

tar -czf webtop.tar.gz ozp-webtop/build
mv webtop.tar.gz ${OUTPUTDIR}

tar -czf demo_apps.tar.gz ozp-demo/app
mv demo_apps.tar.gz ${OUTPUTDIR}

printf "\n********************\n  Completed packaging \n********************\n"
