"""
Utility functions
"""
import datetime
import pytz
import re
import os
import time

# Reference - Code not used
# from django.template import Context
# from django.template import Template


def millis():
    """
    Get millis seconds
    """
    return int(round(time.time() * 1000))


def str_to_bool(user_input):
    """
    Convert string to Boolean value
    """
    if isinstance(user_input, bool):
        return user_input
    else:
        if user_input.lower() in ['1', 'true']:
            return True
        else:
            return False


def interactive_migration():
    TEST_MODE = str_to_bool(os.getenv('TEST_MODE', False))

    if TEST_MODE is True:
        return

    print('Please Run - python manage.py runscript notification_mailbox')
    print('If it is the first time say N, run the script, and next time say Y')
    print('For Development Machines: Always say Y')

    response = input('Have you run command: Y/N    ').lower()

    if response == 'y':
        return
    else:
        raise Exception('You need to run command first')


def make_keysafe(key):
    """
    given an input string, make it lower case and remove all non alpha-numeric
    characters so that it will be safe to use as a cache keyname

    TODO: check for max length (250 chars by default for memcached)
    """
    return re.sub(r'[^a-zA-Z0-9_."`-]+', '', key).lower()


def find_between(s, start, end):
    """
    Return a string between two other strings
    """
    return (s.split(start))[1].split(end)[0]


def get_now_utc():
    """
    Return current datetime in UTC

    Format: YYYY-MM-DD HH:MM[:ss[.uuuuuu]][TZ]
    """
    return datetime.datetime.now(pytz.utc)

# Reference - Code not used
# def render_template_string(template_string, context_dict):
#     """
#     Render Django Template
#
#     Args:
#         template_string(str): Template String
#         context_dict(dict): Context Variable Dictionary
#     """
#     template_context = Context(context_dict)
#     template = Template(template_string)
#     return template.render(template_context)
