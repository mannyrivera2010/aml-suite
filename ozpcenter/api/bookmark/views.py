"""
Bookmark

https://aml-development.github.io/ozp-backend/features/shared_folders_2018/
"""
import logging

from rest_framework.decorators import api_view
from rest_framework.decorators import permission_classes
from rest_framework import viewsets
from rest_framework.response import Response

from ozpcenter.utils import str_to_bool
from ozpcenter import permissions
import ozpcenter.api.bookmark.model_access as model_access
import ozpcenter.api.bookmark.serializers as serializers

logger = logging.getLogger('ozp-center.' + str(__name__))


class BookmarkViewSet(viewsets.ViewSet):
    """
    Access Control
    ===============
    - All users can view

    URIs
    ======
    GET /api/bookmark

    """
    permission_classes = (permissions.IsUser,)

    def list(self, request):
        """
        Get bookmark
        """
        current_request_profile = request.user.profile
        data = model_access.get_bookmark_tree(current_request_profile, request=request)
        return Response(data)

    def retrieve(self, request, pk=None):
        return Response({'status': 'ok'})
