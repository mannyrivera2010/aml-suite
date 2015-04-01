#!/usr/bin/env bash

# This will set a box up for building ozp-rest and the front-end resources
sudo yum update
sudo yum install java-1.7.0-openjdk java-1.7.0-openjdk-devel git nodejs npm

# install gvm (as jenkins user)
curl -s get.gvmtool.net | bash
source ${HOMEDIR}/.gvm/bin/gvm-init.sh
# modify .gvm/etc/config to set gvm_auto_answer=true
gvm install grails 2.3.7
gvm use grails 2.3.7
gvm default grails 2.3.7

# if the above environment is not used for building (e.g. Jenkins), make sure these env vars are set:
# export GRAILS_HOME="/home/jenkins/.gvm/grails/2.3.7"
# export PATH=$GRAILS_HOME/bin:$PATH
# export JAVA_HOME="/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.75.x86_64"

