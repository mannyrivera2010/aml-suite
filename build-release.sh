#!/usr/bin/env bash
# Purpose of this script is to build release tar file for each repos

SET_PATHS(){
  # DEV_TOOL_PATH
  DEV_TOOL_PATH=`pwd`
  # WORKSPACE is the folder used to clone and build the repos
  WORKSPACE_PATH=$DEV_TOOL_PATH/workspace
  # distribution path
  DIST_PATH=$DEV_TOOL_PATH/distribution

  echo "DEV_TOOL_PATH: $DEV_TOOL_PATH"
  echo "WORKSPACE_PATH: $WORKSPACE_PATH"
  echo "DIST_PATH: $DIST_PATH"
}

INSTALL_NODE_VERSION(){
  \. ~/.nvm/nvm.sh
  nvm install 0.12.7
  nvm install 5.3.0
}

REPLACE_NODE_VERSION(){
  # TODO: in NODE_LINE_2, include, nvm install
  NODE_LINE_1='source \/usr\/local\/node_versions\/set_node_version.sh'
  NODE_LINE_2='\. ~\/\.nvm\/nvm\.sh; nvm use'
  sed -i -- "s/$NODE_LINE_1/$NODE_LINE_2/g" $REPO_PATH/jenkins/*
}

CREATE_HTTP_GIT_CLONE(){
  REPO_NAME=$@
  HTTP_GIT_CLONE_STRING="https://github.com/aml-development/$REPO_NAME.git"
  echo "Clone $REPO_NAME"
  git clone $HTTP_GIT_CLONE_STRING
  REPO_PATH=$(cd $repo && echo `pwd`)

  release_shell_file=$REPO_PATH/jenkins/release.sh
  build_shell_file=$REPO_PATH/jenkins/build.sh

  if [ -f $release_shell_file ]; then
    RELEASE_SHELL_SCRIPT=$release_shell_file
  else
    RELEASE_SHELL_SCRIPT=$build_shell_file
  fi
  echo "-REPO [$REPO_NAME] CLONED-"

  echo "HTTP_GIT_CLONE_STRING: $HTTP_GIT_CLONE_STRING"
  echo "REPO_PATH: $REPO_PATH"
  echo "RELEASE_SHELL_SCRIPT: $RELEASE_SHELL_SCRIPT"
}

FETCH_GIT_TAGS(){
  echo "EXECUTE: (cd $REPO_PATH && git fetch --tags --progress $HTTP_GIT_CLONE_STRING +refs/tags/release/*:refs/remotes/origin/tags/release/*)"
  # (cd $REPO_PATH && git fetch --tags --progress $HTTP_GIT_CLONE_STRING +refs/heads/*:refs/remotes/origin/*)
  (cd $REPO_PATH && git fetch --tags $HTTP_GIT_CLONE_STRING +refs/heads/*:refs/remotes/origin/*)
  (cd $REPO_PATH && git fetch --tags $HTTP_GIT_CLONE_STRING +refs/tags/release/*:refs/remotes/origin/tags/release/*)
}

PREPARE_PATHS(){
  echo '---------------'
  echo '== Preparing WORKSPACE =='
  echo 'Removing $WORKSPACE_PATH'
  rm -rf $WORKSPACE_PATH
  echo 'Creating WORKSPACE'
  mkdir $WORKSPACE_PATH

  echo 'Removing $DIST_PATH'
  rm -rf $DIST_PATH
  echo 'Creating WORKSPACE'
  mkdir $DIST_PATH
  echo '---------------'
}

GIT_CHECKOUT_TAG(){
  TAG_REFNAME=$(cd $REPO_PATH && git for-each-ref refs/tags/release --sort=-taggerdate --format='%(refname)' --count=1)
  TAG_REFNAME_SED=`echo $TAG_REFNAME | sed -e 's/refs\///g'`
  echo "TAG_REFNAME: $TAG_REFNAME"
  echo "TAG_REFNAME_SED: $TAG_REFNAME_SED"

  # Package_release.sh debug variables
  BRANCH_NAME=`echo ${TAG_REFNAME_SED}| sed 's,/,_,g'`
  BRANCH_VERSION=`echo ${BRANCH_NAME}| sed 's/tags_release_\([0-9]*\.[0-9]*\.[0-9]*\)/\1/'`

  echo "BRANCH_NAME: $BRANCH_NAME"
  echo "BRANCH_VERSION: $BRANCH_VERSION"

  # checkout and create new flag
  # git branch <branch_name> <TAG>
  (cd $REPO_PATH && git checkout -b $BRANCH_NAME $TAG_REFNAME_SED)

  echo "LOG MESSAGE:$(cd $REPO_PATH && git log -1 --pretty=%B)"

  HEAD_ABBREV_REF=$(cd $REPO_PATH && git rev-parse --abbrev-ref HEAD)
  echo "HEAD_ABBREV_REF: $HEAD_ABBREV_REF"

  echo "EXECUTE: (cd $REPO_PATH && sh $RELEASE_SHELL_SCRIPT)"
}

BUILD_RELEASE_TAR(){
  REPLACE_NODE_VERSION
  (cd $REPO_PATH && sh $RELEASE_SHELL_SCRIPT)
  (cd $repo && mv *.tar* $DIST_PATH)
}

## declare an array variable of repos
declare -a repos=(
  "ozp-backend"
  "ozp-react-commons"
  "ozp-center"
  "ozp-hud"
  "ozp-demo"
  "ozp-help"
  "ozp-webtop"
  "ozp-iwc"
)

# declare variable to set paths
SET_PATHS
# Create WORKSPACE and distribution folders
PREPARE_PATHS

# Install Node (0.12.7, 5.3.0)
INSTALL_NODE_VERSION

echo '== Cloning Repo in WORKSPACE =='
cd $WORKSPACE_PATH

for repo in "${repos[@]}"
do
  echo "====STARTING $repo==="
  CREATE_HTTP_GIT_CLONE $repo
  FETCH_GIT_TAGS
  GIT_CHECKOUT_TAG

  BUILD_RELEASE_TAR
  echo '====FINISHED==='
done

DATE=`date '+%Y_%m_%d_%H_%M_%S'`
tar cvf distribution/dist_bundle_$DATE.tar distribution/*.tar.gz

echo '== distribution tar files =='
ll -h distribution/

# bundle-front-end-master
echo 'Done'
