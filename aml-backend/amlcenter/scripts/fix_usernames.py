"""
Fix usernames

"""
import os
import sys

sys.path.insert(0, os.path.realpath(os.path.join(os.path.dirname(__file__), '../../')))

from amlcenter import models
from amlcenter.auth import pkiauth


def run():
    """
    Create username for profile
    """

    for current_profile in models.Profile.objects.all():
        print('------------')
        current_profile_dn = current_profile.dn
        current_profile_username = current_profile.user.username
        print('Current DN: {}'.format(current_profile_dn))

        new_username = pkiauth._get_sid_from_dn(current_profile_dn)
        current_profile.user.username = new_username
        current_profile.user.save()

        print('Previous Username({}), New username({})'.format(current_profile_username, new_username))
