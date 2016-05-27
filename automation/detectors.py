import os
import re

import cmd_utils


class Detector(object):

    def __init__(self, repo_helper):
        self.repo_helper = repo_helper

    def get_repo_directory_name(self):
        return self.repo_helper.get_directory_name()

    def get_repo_name(self):
        return self.repo_helper.repo_name

    def get_current_version_number(self):
        return self.repo_helper.get_current_version_number()

    def get_next_version_number(self):
        return self.repo_helper.get_next_version_number()

    def repo_directory_next_version(self, repo_name):
        return self.repo_helper.repo_directory_next_version(repo_name)

    def detect(self):
        raise NotImplementedError()

    def execute(self):
        raise NotImplementedError()


class PythonFileDetector(Detector):
    """
    Detector used to see if _version.py file exist in repo
    """

    def detect(self):
        """
        This is used to detect if the repo has a _version.py file
        If it does run 'glup changelog'
        """
        if os.path.isfile(os.path.join(self.get_repo_directory_name(), '_version.py')):
            return os.path.join(self.get_repo_directory_name(), '_version.py')
        return None

    def execute(self):
        input_file_dir = self.detect()
        if input_file_dir:
            lines = []
            with open(input_file_dir, 'r') as f:
                lines = f.readlines()

            output_lines = []

            version_flag = True

            for line in lines:
                if version_flag:
                    if line.find('version') >= 1:
                        version_flag = False
                        line = line = re.sub(r'"(\d+\.{0,1})+"', '"%s"' % str(self.get_next_version_number()), line)
                        output_lines.append(line)
                    else:
                        output_lines.append(line)
                else:
                    output_lines.append(line)

            with open(input_file_dir, 'w') as f:
                for current_line in output_lines:
                    f.write(current_line)


class PackageFileDetector(Detector):

    def detect(self):
        """
        This is used to detect if the repo has a package.json file
        If it does run 'glup changelog'
        """
        if os.path.isfile(os.path.join(self.get_repo_directory_name(), 'package.json')):
            return os.path.join(self.get_repo_directory_name(), 'package.json')
        return None

    def execute(self):
        input_file_dir = self.detect()
        if input_file_dir:
            lines = []
            with open(input_file_dir, 'r') as f:
                lines = f.readlines()

            output_lines = []

            version_flag = True

            for line in lines:
                if version_flag:
                    if line.find('version') >= 1:
                        version_flag = False
                        line = line = re.sub(r'"(\d+\.{0,1})+"', '"%s"' % str(self.get_next_version_number()), line)
                        output_lines.append(line)
                    else:
                        output_lines.append(line)
                else:
                    output_lines.append(line)

            with open(input_file_dir, 'w') as f:
                for current_line in output_lines:
                    f.write(current_line)
            return True
        return False


class NpmShrinkwrapDetector(Detector):

    def detect(self):
        """
        This is used to detect if the repo has a package.json file
        If it does run 'glup changelog'
        """
        if os.path.isfile(os.path.join(self.get_repo_directory_name(), 'npm-shrinkwrap.json')):
            return os.path.join(self.get_repo_directory_name(), 'npm-shrinkwrap.json')
        return None

    def execute(self):
        input_file_dir = self.detect()

        if input_file_dir:
            ozp_react_commons_next_version = self.repo_directory_next_version('ozp-react-commons')
            #print(ozp_react_commons_next_version)
            lines = []
            with open(input_file_dir, 'r') as f:
                lines = f.readlines()

            output_lines = []

            version_flag_count = 0

            for line in lines:
                if version_flag_count == 0:
                    if line.find('"ozp-react-commons"') >= 1:
                        version_flag_count = version_flag_count + 1
                    output_lines.append(line)
                elif version_flag_count == 1:
                    if line.find('version') >= 1:
                        version_flag_count = version_flag_count + 1
                        line = line = re.sub(r'"(\d+\.{0,1})+"', '"%s"' % str(ozp_react_commons_next_version), line)
                        output_lines.append(line)
                    else:
                        output_lines.append(line)
                else:
                    output_lines.append(line)

            with open(input_file_dir, 'w') as f:
                for current_line in output_lines:
                    f.write(current_line)

            return True
        return False


class ChangeLogDetector(Detector):

    def detect(self):
        """
        This is used to detect if the repo has a changelog.md file
        If it does run 'glup changelog'
        """
        if os.path.isfile(os.path.join(self.get_repo_directory_name(), 'CHANGELOG.md')):
            return os.path.join(self.get_repo_directory_name(), 'CHANGELOG.md')
        return None

    def execute(self):
        """
        Generate the changelog.

        For center and hud: gulp changelog
        For webtop: grunt changelog
        None of the other repos have changelogs
        """
        # os.remove(self.detect_changelog())
        #
        if self.get_repo_name() in ['ozp-center', 'ozp-hud']:
            # print('(cd %s && npm install gulp)' % self.get_repo_directory_name())
            # print('(cd %s && rm node_modules/ -rf)' % self.get_repo_directory_name())
            # print('(cd %s && npm install)' % self.get_repo_directory_name())
            command = '(cd %s && gulp changelog)' % self.get_repo_directory_name()
            # print(command)
            command_results = cmd_utils.call_command(command)

            if command_results.return_code != 0:
                raise Exception(command_results.pipe)
            return True

        elif self.get_repo_name() == 'ozp-webtop':
            command = '(cd %s && grunt changelog)' % self.get_repo_directory_name()
            # print(command)

            command_results = cmd_utils.call_command(command)
            if command_results.return_code != 0:
                raise Exception(command_results.pipe)
            return True
        return False
