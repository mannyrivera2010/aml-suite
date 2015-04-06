#!/usr/bin/env bash

# release-preview for center, hud, webtop, ozp-demo, ozp-rest, and (maybe) iwc
# assumes you have all repos cloned at REPO_DIR, along with master and 
# develop branches

REPO_DIR=~/ozp-repos

cd ${REPO_DIR}

## declare an array variable
declare -a repos=("ozp-center" "ozp-hud" "ozp-webtop" "ozp-rest")

## now loop through the above array
for i in "${repos[@]}"
do
    printf "#################################################################\n"
	printf "$i\n"
	printf "#################################################################\n"
	cd ${REPO_DIR}/$i
	# update everything
	git fetch --all
	git checkout master
	git reset --hard origin/master
	git checkout develop
	git reset --hard origin/develop
	printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
	printf "Commits on master not on develop:\n"
	printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
	git --no-pager log origin/develop..origin/master
	printf "*****************************************************************\n"
	printf "Commits on develop not yet on master:\n"
	printf "*****************************************************************\n"
	git --no-pager log origin/master..origin/develop

   # or do whatever with individual element of the array
done

# You can access them using echo "${arr[0]}", "${arr[1]}" also

# iwc doesn't use gitflow - just master and tags
printf "#################################################################\n"
printf "ozp-iwc\n"
printf "#################################################################\n"
cd ${REPO_DIR}/ozp-iwc
# update everything
git fetch --all --tags
git checkout master
git reset --hard origin/master
printf "*****************************************************************\n"
printf "Commits on master since last tag:\n"
printf "*****************************************************************\n"
git --no-pager log `git rev-list --tags --max-count=1`..origin/master
