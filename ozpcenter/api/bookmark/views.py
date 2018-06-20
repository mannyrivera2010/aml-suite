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

from ozpcenter import permissions
from ozpcenter.utils import str_to_bool
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
        Get All Bookmarks for request profile
        """
        current_request_profile = request.user.profile

        ordering_fields = [str(record) for record in request.query_params.getlist('order', [])]

        data = serializers.get_bookmark_tree(current_request_profile, request=request, ordering_fields=ordering_fields)
        return Response(data)

    def retrieve(self, request, pk=None):
        """
        Get Bookmarks by id for request profile
        """
        current_request_profile = request.user.profile

        ordering_fields = [str(record) for record in request.query_params.getlist('order', [])]

        entry = model_access.get_bookmark_entry_by_id(current_request_profile, pk)
        data = serializers.get_bookmark_tree(current_request_profile, request=request,
            folder_bookmark_entry=entry, is_parent=True, ordering_fields=ordering_fields)
        return Response(data)

    def create(self, request):
        """
        Bookmark a Listing for the current user.

        POST JSON data if creating a folder bookmark under a different folder:
        {
            "type":"FOLDER",
            "title":"new",
            "bookmark_parent":[{"id":75}]
        }

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

    def destroy(self, request, pk=None):
        """
        Validate make sure user has access

        if shared folder:
            if request_profile is viewer:
                raise PermissionDenied
            elif request_profile is owner and there is only one owner:
                Give owner "Are you sure you want to remove folder, it will affect all users"
            elif request_profile is owner and there is more than 1 owner:
                Remove Bookmark from user's bookmark list.
        else:
            Remove Bookmark from user's bookmark list.

        """
        return Response({"pk": pk})


class BookmarkPermissionViewSet(viewsets.ViewSet):
    """
    Access Control
    ===============
    - All users can view

    URIs
    ======
    GET /api/bookmark

    """
    permission_classes = (permissions.IsUser,)

    def list(self, request, bookmark_pk=None):
        """
        Get a list of permissions for a bookmark for request profile
        """
        current_request_profile = request.user.profile
        bookmark_entry = model_access.get_bookmark_entry_by_id(current_request_profile, bookmark_pk)
        permissions = model_access.get_user_permissions_for_bookmark_entry(current_request_profile, bookmark_entry)

        serializer = serializers.BookmarkPermissionSerializer(permissions, context={'request': request}, many=True)

        return Response(serializer.data)

    def create(self, request, bookmark_pk=None):
        """
        Bookmark a Listing for the current user.

        POST JSON data if creating a folder bookmark:
        {
            "profile": {"id": 4}}
            "user_type": "OWNER/VIEWER",
        }
        """
        current_request_profile = request.user.profile
        bookmark_entry = model_access.get_bookmark_entry_by_id(current_request_profile, bookmark_pk)

        serializer = serializers.BookmarkPermissionSerializer(data=request.data, context={'request': request, 'bookmark_entry': bookmark_entry}, partial=True)

        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.RequestException('{0!s}'.format(serializer.errors))

        serializer.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def destroy(self, request, bookmark_pk=None, pk=None):
        """
        Validate make sure user has access

        if shared folder:
            if request_profile is viewer:
                raise PermissionDenied
            elif request_profile is owner and there is only one owner:
                Give owner "Are you sure you want to remove folder, it will affect all users"
            elif request_profile is owner and there is more than 1 owner:
                Remove Bookmark from user's bookmark list.
        else:
            Remove Bookmark from user's bookmark list.

        """
        return Response({"bookmark_pk": bookmark_pk, "pk": pk})
