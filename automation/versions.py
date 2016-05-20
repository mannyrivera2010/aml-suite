"""
File for Versions
"""

class Version(object):
    """
    An object that represents a three-part version number.
    """
    def __init__(self, major, minor, micro, error=None, error_msg=None):
        """
        @param major: The major version number.
        @type major: {int}
        @param minor: The minor version number.
        @type minor: {int}
        @param micro: The micro version number.
        @type micro: {int}
        """
        self.major = major
        self.minor = minor
        self.micro = micro
        self.error = error
        self.error_msg = error_msg

    def __str__(self):
        if self.error:
            return '(ERROR - %s, %s, %s - %s - %s)' % (self.major, self.minor, self.micro, self.error, self.error_msg)
        else:
            return '%s.%s.%s' % (self.major, self.minor, self.micro)

    def __repr__(self):
        if self.error:
            return '(ERROR - %s, %s, %s - %s - %s)' % (self.major, self.minor, self.micro, self.error, self.error_msg)
        else:
            return '%s.%s.%s' % (self.major, self.minor, self.micro)

    def increment(self, major=0, minor=0, micro=1):
        if self.error:
            return self
        else:
            return Version(int(self.major + major), int(self.minor + minor), int(self.micro + micro))


def parse_version_string(input_string):
    """
    @param input_string: string with version infomation
    @type input_string: {string}
    """
    versions = input_string.split('.')
    try:
        major = int(versions[0].replace('v',''))
        minor = int(versions[1])
        micro = int(versions[2].replace('-rc',''))
        return Version(major, minor, micro)
    except Exception as err:
        return Version(-2, -2, -2, err, input_string)
