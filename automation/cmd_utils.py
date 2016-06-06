import os
import subprocess
from subprocess import call


class CommandResults(object):
    """
    Wrapper Class
    """

    def __init__(self, command, pipe, return_code):
        self.command = command
        self.pipe = pipe
        self.return_code = return_code

    def check(self):
        if self.return_code >= 2:
            raise Exception('Command:[%s] - Code:[%s] - Error:[%s]' % (self.command, self.return_code, self.pipe))

    def __repr__(self):
        return '[%s, %s]' % (self.command, self.return_code)


def call_command(command):
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # print(p.communicate())
    # print(p.returncode)
    return CommandResults(command, p.communicate(), p.returncode)


if __name__ == '__main__':
    print(call_command('ls -al').check())
    print(call_command('./test01.sh').check())
