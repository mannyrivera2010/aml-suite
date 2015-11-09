#!/usr/bin/env bash

# release-preview for center, hud, webtop, ozp-demo, ozp-rest, and (maybe) iwc
# assumes you have all repos cloned at REPO_DIR

REPO_DIR=~/ozp-repos

cd ${REPO_DIR}

## declare an array variable
declare -a repos=("ozp-center" "ozp-hud" "ozp-webtop" "ozp-rest" "ozp-react-commons" "ozp-iwc" "ozp-help" "ozp-iwc-owf7-widget-adapter" "ozp-demo")

## now loop through the above array
for i in "${repos[@]}"
do
    printf "#################################################################\n"
	printf "$i\n"
	printf "#################################################################\n"
	cd ${REPO_DIR}/$i
	# update everything
	git fetch --all --tags
	git checkout master
	git reset --hard origin/master
	printf "*****************************************************************\n"
	printf "Commits on master since last tag:\n"
	printf "*****************************************************************\n"
	git --no-pager log `git rev-list --tags --max-count=1`..origin/master

   # or do whatever with individual element of the array
done

# You can access them using echo "${arr[0]}", "${arr[1]}" also
