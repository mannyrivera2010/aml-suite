"""
Debugging Celery
"""
import sys
import os

sys.path.insert(0, os.path.realpath(os.path.join(os.path.dirname(__file__), '../../')))

from ozpcenter import tasks
from ozpcenter.models import Profile


def run():
    """
    Reindex Data
    """
    profile_list = Profile.objects.values_list('id').all()

    create_email_task = tasks.create_email.chunks(profile_list, 10)
    print(create_email_task)
    print('-' * 10)
    group_results = create_email_task.delay('3')
    print(group_results)

    print('-' * 10)
    print(group_results.get())
