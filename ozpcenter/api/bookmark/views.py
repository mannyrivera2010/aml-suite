"""
Bookmark

https://aml-development.github.io/ozp-backend/features/shared_folders_2018/
"""
import logging

from rest_framework.decorators import api_view
from rest_framework.decorators import permission_classes
from rest_framework import viewsets
from rest_framework.response import Response

from ozpcenter import errors
from rest_framework import status

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
        data = serializers.get_bookmark_tree(current_request_profile, request=request)
        return Response(data)

    def retrieve(self, request, pk=None):
        current_request_profile = request.user.profile

        entry = model_access.get_bookmark_entry_by_id(current_request_profile, pk)
        data = serializers.get_bookmark_tree(current_request_profile, request=request, folder_bookmark_entry=entry, is_parent=True)
        return Response(data)

    def create(self, request):
        """
        Bookmark a Listing for the current user.

        {"type":"FOLDER", "title":"new", "bookmark_parent":[{"id":75}]}


        POST JSON data if creating a listing bookmark:
        {
            "listing":
                {
                    "id": 1
                },
            "type": "LISTING",
        }

        POST JSON data if creating a folder bookmark:
        {
            "title": "Folder 1"
            "type": "FOLDER",
        }
        """
        serializer = serializers.BookmarkSerializer(data=request.data, context={'request': request})

        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.RequestException('{0!s}'.format(serializer.errors))

        serializer.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)
