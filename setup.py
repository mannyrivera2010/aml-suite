import re
from setuptools import setup, find_packages

PKG = "ozp_backend"
VERSIONFILE = "_version.py"
REQUIREMENT_FILE = "requirements.txt"
verstr = "unknown"

verstrline = open(VERSIONFILE, "rt").read()
VSRE = r"^__version__ = ['\"]([^'\"]*)['\"]"
mo = re.search(VSRE, verstrline, re.M)
if mo:
    verstr = mo.group(1)
else:
    raise RuntimeError("Unable to find version string in {0!s}.".format(VERSIONFILE))

# TODO Read requirements from requirements.txt file
install_requires = [requirement.strip() for requirement in open(REQUIREMENT_FILE, "rt").readlines()]

EXCLUDE_FROM_PACKAGES = ['*.tests']

package_data = {'': ['README.md', 'static']}

setup(name=PKG,
      version=verstr,
      packages=packages,
      package_data=find_packages(exclude=EXCLUDE_FROM_PACKAGES),
      include_package_data=True,
      install_requires=install_requires
)
