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

REPLACE_NODE_VERSION(){
  NODE_LINE_1='source \/usr\/local\/node_versions\/set_node_version.sh'
  NODE_LINE_2='\/usr\/lib\/node_modules\/nvm use'
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

  REPLACE_NODE_VERSION
  echo "-REPO [$REPO_NAME] CLONED-"
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

## declare an array variable of repos
declare -a repos=(
  # "ozp-backend"
  # "ozp-react-commons"
  # "ozp-center"
  "ozp-hud"
  # "ozp-demo"
  # "ozp-help"
  # "ozp-webtop"
  # "ozp-iwc"
)

SET_PATHS
PREPARE_PATHS

echo '== Cloning Repo in WORKSPACE =='
cd $WORKSPACE_PATH

for repo in "${repos[@]}"
do
  echo '====STARTING==='
  CREATE_HTTP_GIT_CLONE $repo

  echo "HTTP_GIT_CLONE_STRING: $HTTP_GIT_CLONE_STRING"
  echo "REPO_PATH: $REPO_PATH"
  echo "RELEASE_SHELL_SCRIPT: $RELEASE_SHELL_SCRIPT"

  echo "EXECUTE: (cd $REPO_PATH && git fetch --tags --progress $HTTP_GIT_CLONE_STRING +refs/tags/release/*:refs/remotes/origin/tags/release/*)"
  (cd $REPO_PATH && git fetch --tags --progress $HTTP_GIT_CLONE_STRING +refs/tags/release/*:refs/remotes/origin/tags/release/*)

  echo "EXECUTE: (cd $REPO_PATH && sh $RELEASE_SHELL_SCRIPT)"
  # (cd $REPO_PATH && sh $RELEASE_SHELL_SCRIPT)
  #
  # (cd $repo && git fetch --tags --progress $HTTP_GIT_CLONE_STRING +refs/tags/release/*:refs/remotes/origin/tags/release/*)
  # tag_to_checkout=`(cd $repo && git describe --tags)`
  #
  # echo "tag_to_checkout: $tag_to_checkout"
  #
  # (cd $repo && git checkout -f $tag_to_checkout)
  #
  # tag_checkout_temp=$(echo "$tag_to_checkout" | sed -e "s/\//_/g")
  #
  # echo "branch_name_temp: $tag_checkout_temp"
  # (cd $repo && git checkout -b $tag_checkout_temp)
  #
  # export BRANCH_NAME=$tag_checkout_temp
  #

  # (cd $repo && mv *.tar* $DIST_PATH)

  echo '====FINISHED==='
done


# bundle-front-end-master
echo 'Done'
