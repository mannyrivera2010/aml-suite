"""
Agency Views
"""
import logging

from rest_framework import viewsets
from rest_framework import filters

from amlcenter import permissions
import amlcenter.api.agency.model_access as model_access
import amlcenter.api.agency.serializers as serializers


logger = logging.getLogger('aml-center.' + str(__name__))


class AgencyViewSet(viewsets.ModelViewSet):
    """
    ModelViewSet for getting all agency entries for all users

    Access Control
    ===============
    - All users can read
    - AppMallSteward can view

    URIs
    ======
    GET /api/agency
    Summary:
        Get a list of all system-wide Agency entries

    Response:
        200 - Successful operation - [AgencySerializer]

    POST /api/agency/
    Summary:
        Add an Agency
    Request:
        data: AgencySerializer Schema
    Response:
        200 - Successful operation - AgencySerializer

    GET /api/agency/{pk}
    Summary:
        Find an Agency Entry by ID
    Response:
        200 - Successful operation - AgencySerializer

    PUT /api/agency/{pk}
    Summary:
        Update an Agency Entry by ID

    PATCH /api/agency/{pk}
    Summary:
        Update (Partial) an Agency Entry by ID

    DELETE /api/agency/{pk}
    Summary:
        Delete an Agency Entry by ID
    """
    queryset = model_access.get_all_agencies()
    serializer_class = serializers.AgencySerializer
    permission_classes = (permissions.IsAppsMallStewardOrReadOnly,)
    filter_backends = (filters.OrderingFilter,)
    ordering_fields = ('title',)
    ordering = ('title',)
