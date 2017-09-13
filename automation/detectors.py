import os
import re

from changelog import create_changelog


class Detector(object):

    def __init__(self, repo_helper):
        self.repo_helper = repo_helper

    def get_repo_directory_name(self):
        return self.repo_helper.repo_working_directory_obj.data_store['repo'][self.repo_helper.repo_name]['working_directory']

    def get_repo_name(self):
        return self.repo_helper.repo_name

    def get_current_version_number(self):
        return self.repo_helper.repo_working_directory_obj.data_store['repo'][self.repo_helper.repo_name]['current_version']

    def get_next_version_number(self):
        return self.repo_helper.repo_working_directory_obj.data_store['repo'][self.repo_helper.repo_name]['next_version']

    def repo_directory_next_version(self, repo_name):
        return self.repo_helper.repo_working_directory_obj.data_store['repo'][repo_name]['next_version']

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
            # print(ozp_react_commons_next_version)
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
        Execute Changelog for repo
        For center, hud, webtop
        None of the other repos have changelogs
        """
        if self.get_repo_name() in ['ozp-center', 'ozp-hud', 'ozp-webtop', 'ozp-backend']:
            create_changelog(self.get_repo_directory_name())
            return True
        return False
