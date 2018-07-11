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

        API:
            Order bookmark by title - `GET /api/bookmark/?order=title`
            Reverse Order bookmark by title - `GET /api/bookmark/?order=-title`
            Secondary Sort - `/api/bookmark/?order=-created_date&order=-title`
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

        API:
            Create a Listing Bookmark under user's root folder.
            ```
            POST /api/bookmark/

            {
                "type":"LISTING",
                "listing":{"id":1}
            }
            ```

            Create a Listing Bookmark under different folder for user
            ```
            POST /api/bookmark/

            {
                "type":"LISTING",
                "listing":{"id":1},
                "bookmark_parent":[{"id":40}]
            }
            ```

            Create a 'Empty' Folder bookmark under root folder for user:
            ```
            POST /api/bookmark/
            {
                "title": "Folder 1",
                "type": "FOLDER"
            }
            ```

            Create a 'Merged' Folder bookmark under root folder for user with 2 children:
            ```
            POST /api/bookmark/
            {
                "title": "Folder 2",
                "type": "FOLDER",
                "children":[
                        {"id":16},
                        {"id":17}
                ]
            }
            ```

            Error:
                A folder with that name already exist (TODO)

        """
        serializer = serializers.BookmarkSerializer(data=request.data, context={'request': request})

        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.RequestException('{0!s}'.format(serializer.errors))

        serializer.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def update(self, request, pk=None):
        """
        Updating bookmarks

        API:
            Move a folder/listing bookmark to a different folder
            ```
            PUT /api/bookmark/{bookmark_id}/
            {
                "bookmark_parent":[{"id":40}]
            }
            ```

            Move a folder/listing bookmark to a user's root folder
            ```
            PUT /api/bookmark/{bookmark_id}/
            {
                "bookmark_parent":[]
            }
            ```

            Rename a folder bookmark folder
            ```
            PUT /api/bookmark/{folder_bookmark_id}/
            {
                "title": "new title"
            }
            ```

            Error:
                A folder with that name already exist (TODO)
        """
        current_request_profile = request.user.profile
        bookmark_entry = model_access.get_bookmark_entry_by_id(current_request_profile, pk)

        serializer = serializers.BookmarkSerializer(bookmark_entry, data=request.data,
            context={'request': request}, partial=True)

        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.RequestException('{0!s}'.format(serializer.errors))

        serializer.save()

        return Response(serializer.data, status=status.HTTP_200_OK)

    def destroy(self, request, pk=None):
        """
        Delete/Remove Bookmark Entry from request_profile

        API:
            Delete Folder/Listing Bookmark

            DELETE /api/bookmark/{id}
        """
        current_request_profile = request.user.profile
        bookmark_entry = model_access.get_bookmark_entry_by_id(current_request_profile, pk)

        model_access.delete_bookmark_entry_for_profile(current_request_profile, bookmark_entry)

        return Response(status=status.HTTP_204_NO_CONTENT)


class BookmarkPermissionViewSet(viewsets.ViewSet):
    """
    Access Control
    ===============
    - All users can view

    URIs
    ======
    GET /api/bookmark/{id}/permission/

    """
    permission_classes = (permissions.IsUser,)

    def list(self, request, bookmark_pk=None):
        """
        Get a list of permissions for a bookmark for request profile

        API:
            Get a list of who has access to {folder_bookmark_id} BookmarkEntry
            ```
            GET /api/bookmark/{folder_bookmark_id}/permission/
            ```
        """
        current_request_profile = request.user.profile
        bookmark_entry = model_access.get_bookmark_entry_by_id(current_request_profile, bookmark_pk)
        permissions = model_access.get_user_permissions_for_bookmark_entry(current_request_profile, bookmark_entry)

        serializer = serializers.BookmarkPermissionSerializer(permissions, context={'request': request}, many=True)

        return Response(serializer.data)

    def retrieve(self, request, bookmark_pk=None, pk=None):
        """
        Get BookmarkPermission by id for request profile
        """
        request_profile = request.user.profile
        bookmark_entry = model_access.get_bookmark_entry_by_id(request_profile, bookmark_pk)
        bookmark_permission = model_access.get_bookmark_permission_by_id(request_profile, bookmark_entry, pk)

        serializer = serializers.BookmarkPermissionSerializer(bookmark_permission,
            context={'request': request}, many=False)

        return Response(serializer.data)

    def create(self, request, bookmark_pk=None):
        """
        Add Permission to BookmarkEntry

        API:
            Add OWNER {username} to {bookmark_id} BookmarkEntry
            ```
            POST /api/bookmark/{bookmark_id}/permission/
            {
                "user_type":"OWNER",
                "profile":{
                    "user":{
                        "username":{username}
                    }
                }
            }
            ```

            Add VIEWER {username} to {bookmark_id} BookmarkEntry
            ```
            POST /api/bookmark/{bookmark_id}/permission/
            {
                "user_type":"VIEWER",
                "profile":{
                    "user":{
                        "username":{username}
                    }
                }
            }
            ```

        API Errors:
            When the Profile is not found via username
            ```
            {
                "detail": "Valid User is Required",
                "error": true,
                "error_code": "validation_error"
            }
            ```
        """
        current_request_profile = request.user.profile
        bookmark_entry = model_access.get_bookmark_entry_by_id(current_request_profile, bookmark_pk)

        serializer = serializers.BookmarkPermissionSerializer(data=request.data,
            context={'request': request, 'bookmark_entry': bookmark_entry}, partial=True)

        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.RequestException('{0!s}'.format(serializer.errors))

        serializer.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def update(self, request, bookmark_pk=None, pk=None):
        """
        Updating Bookmark Permission
            * Use to convert OWNER User Permission to VIEWER User Permission
            * Use to convert VIEWER User Permission to OWNER User Permission

        Rules:
            * The request profile that is a VIEWER can't self promote to OWNER
            * The request profile that is a OWNER can't self demote to VIEWER

        API:
            Change permission for profile to VIEWER
            ```
            PUT /api/bookmark/{bookmark_id}/permission/{permission_id}
            {
                "user_type":"VIEWER"
            }
            ```

            Change permission for profile to OWNER
            ```
            PUT /api/bookmark/{bookmark_id}/permission/{permission_id}
            {
                "user_type":"OWNER"
            }
            ```

        API Error:
            Can only update permissions for other users
        """
        request_profile = request.user.profile

        bookmark_entry = model_access.get_bookmark_entry_by_id(request_profile, bookmark_pk)
        bookmark_permission = model_access.get_bookmark_permission_by_id(request_profile, bookmark_entry, pk)

        serializer = serializers.BookmarkPermissionSerializer(bookmark_permission, data=request.data,
            context={'request': request, 'bookmark_entry': bookmark_entry}, partial=True)

        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.RequestException('{0!s}'.format(serializer.errors))

        serializer.save()

        return Response(serializer.data, status=status.HTTP_200_OK)

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
        request_profile = request.user.profile

        bookmark_entry = model_access.get_bookmark_entry_by_id(request_profile, bookmark_pk)
        bookmark_permission_entry = model_access.get_bookmark_permission_by_id(request_profile, bookmark_entry, pk)

        # TODO: refactor to remove_profile_permission_for_bookmark_entry
        bookmark_permission_entry_profile = bookmark_permission_entry.profile

        if request_profile == bookmark_permission_entry_profile:
            raise errors.PermissionDenied('can only delete permissions for other users')

        # get bookmark entries to folder relationships for request_profile
        bookmark_entry_folder_relationships = bookmark_entry.bookmark_parent.filter(
            bookmark_permission__profile=bookmark_permission_entry_profile)

        bookmark_entry.bookmark_parent.remove(*bookmark_entry_folder_relationships)

        bookmark_permission_entry.delete()

        return Response(status=status.HTTP_204_NO_CONTENT)
