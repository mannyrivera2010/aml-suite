"""
This script is used on CI boxes. It downloads a given artifact from Jenkins
and deploys it to the local box. The followings command line arguments
should be provided:

job_name: The Jenkins project name to download
build_number: The Jenkins build number to download
"""
import argparse
import logging
import os
import sys
from subprocess import call

import requests
from requests.auth import HTTPBasicAuth

# setup logging
logger = logging.getLogger('jenkins_ansible_deployer')
logger.setLevel('DEBUG')

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# set formattting
formatter = logging.Formatter('%(levelname)s: %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)

def run():
    parser = argparse.ArgumentParser()
    parser.add_argument("job_name", metavar='job_name', type=str,
                        help="Jenkins project name", choices=[
                            "build-center-new-backend",
                            "build-hud-new-backend",
                            "build-webtop-new-backend"],
                        default="build-center-new-backend")
    parser.add_argument("build_number", metavar='build_number', type=int,
                        help="Jenkins build number to deploy")

    args = parser.parse_args()

    # set the ansible playbook to use based on the Jenkins job name
    if args.job_name == "build-center-new-backend":
        ansible_playbook = "ozp_center"
    if args.job_name == "build-hud-new-backend":
        ansible_playbook = "ozp_hud"
    if args.job_name == "build-webtop-new-backend":
        ansible_playbook = "ozp_webtop"

    if not ansible_playbook:
        logger.error("No ansible playbook selected")
        sys.exit(1)

    logger.info("Running ansible playbook %s" % ansible_playbook)
    command = 'ansible-playbook %s.yml -i hosts_local -u jenkins connection=local --extra-vars "jenkins_project=%s jenkins_build_number=%s"' % (
        ansible_playbook, args.job_name, args.build_number)

    logger.info("Running command: %s" % command)
    call(command)

if __name__ == '__main__':
    run()
