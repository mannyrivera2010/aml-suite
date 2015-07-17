#!/usr/bin/env bash

# Show the latest commits on master branches in the past x days
# Assumes you already have the repos cloned in the $REPO_DIR directory

DAYS=1
REPO_DIR=~/ozp-repos

cd ${REPO_DIR}
## declare an array variable
declare -a repos=("ozp-center" "ozp-hud" "ozp-webtop" "ozp-rest" "ozp-react-commons" "ozp-iwc" "ozp-iwc-owf7-widget-adapter" "ozp-demo" "ozp-backend")

printf "*****************************************************************\n"
printf "Commits on master branches in past $DAYS days:\n"
printf "*****************************************************************\n"

## now loop through the above array
for i in "${repos[@]}"
do
    printf "\n#################################################################\n"
    printf "$i\n"
    printf "#################################################################\n"
    cd ${REPO_DIR}/$i
    # update everything
    git fetch --all --tags > /dev/null 2>&1
    git checkout master > /dev/null 2>&1
    git reset --hard origin/master > /dev/null 2>&1
    git --no-pager log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short --since="$DAYS days ago"
done