#!/usr/bin/env bash

echo '##########    Pattern replacement    ##########'
HOMEDIR=/home/vagrant
REPLACE_DIR=$1

echo "replacing patterns in dir $1"

# Search and Replace Script
# -------------------------
while read pattern replacement; do
  find ${REPLACE_DIR} -type f | xargs -i perl -pi -e "s[$pattern][$replacement]g" "{}";
done < /vagrant/patterns_to_replace.txt