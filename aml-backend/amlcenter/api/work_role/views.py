"""
Contact Types Views
"""
import logging

from rest_framework import viewsets

from amlcenter import permissions
import amlcenter.api.work_role.model_access as model_access
import amlcenter.api.work_role.serializers as serializers


logger = logging.getLogger('aml-center.' + str(__name__))


class WorkRoleViewSet(viewsets.ModelViewSet):
    """
    ModelViewSet for getting all WorkRole entries for all users

    Access Control
    ===============
    - All users can read
    - AppMallSteward can write

    URIs
    ======
    GET /api/work_role
    Summary:
        Get a list of all WorkRole

    Response:
        200 - Successful operation - [WorkRoleSerializer]

    POST /api/work_role/
    Summary:
        Add an WorkRole
    Request:
        data: WorkRoleSerializer Schema
    Response:
        200 - Successful operation - WorkRoleSerializer

    GET /api/work_role/{pk}
    Summary:
        Find a WorkRole by id
    Response:
        200 - Successful operation - WorkRoleSerializer

    PUT /api/work_role/{pk}
    Summary:
        Update a WorkRole by id

    PATCH /api/work_role/{pk}
    Summary:
        Not Supported, use PUT instead

    DELETE /api/work_role/{pk}
    Summary:
        Delete a WorkRole by id
    """
    queryset = model_access.get_all_work_roles()
    serializer_class = serializers.WorkRoleSerializer
    permission_classes = (permissions.IsAppsMallStewardOrReadOnly,)

    def partial_update(self, request, pk=None):
        """
        This method is not supported
        """
        raise errors.NotImplemented('HTTP Verb(PATCH) Not Supported')
