"""
Work Roles Model Access
"""
import logging

from amlcenter import models


logger = logging.getLogger('aml-center.' + str(__name__))


def get_all_work_roles():
    """
    Get all work roles

    Return:
        [WorkRole]: List of WorkRole Objects
    """
    return models.WorkRole.objects.all()


def get_work_role_by_id(id, reraise=True):
    """
    Get work role by id

    Return:
        WorkRole: WorkRole Object
    """
    try:
        return models.WorkRole.objects.get(pk=id)
    except models.WorkRole.DoesNotExist as err:
        if reraise:
            raise err
        return None


def get_work_role_by_name(name, reraise=True):
    """
    Get work role by name

    Return:
        WorkRole: WorkRole Object
    """
    try:
        return models.WorkRole.objects.get(name=name)
    except models.WorkRole.DoesNotExist as err:
        if reraise:
            raise err
        return None
