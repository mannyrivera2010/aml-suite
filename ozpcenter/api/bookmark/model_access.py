"""
Shared Folder Rules:
    * All Permissions are handle at folder level
    * Listing Bookmarks and Folder Bookmarks inheritance Permissions from the folder it is part of.
    * Folder Bookmark are the only Bookmark Entries that have Bookmark Permissions
    * Root Folders can never been public, users will be able to share any folder
    * Every Record has BookmarkPermission

Shared Folder Actions:
    * Displaying all nested bookmarks for a user
    * Adding a new listing bookmark under a user root folder (level 1)
    * Adding a new listing bookmark under a user existing folder (level 2)
    * Delete Listing Bookmark from user bookmarks
    * Moving bookmark between two different folder bookmark

Shared Folder Permission Actions:
    * Getting a list of owners and viewers of a shared folder bookmark (as an owner)
    * Getting denied access to see owners and viewers of a shared folder bookmark (as a viewer)
    * An Owner adding new listing bookmark to a shared folder bookmark
    * An Viewer adding new listing bookmark to a shared folder bookmark and getting denied

https://aml-development.github.io/ozp-backend/features/shared_folders_2018/
---------

    query = models.BookmarkEntry.objects.filter(
        id=id,
        bookmark_permission__profile=request_profile  # Validate to make sure user can see folder)
    ).first()

    SELECT *
    FROM "ozpcenter_bookmarkentry"
    INNER JOIN "ozpcenter_bookmarkpermission" ON ("ozpcenter_bookmarkentry"."id" = "ozpcenter_bookmarkpermission"."bookmark_id")
    WHERE ("ozpcenter_bookmarkentry"."id" = 21 AND "ozpcenter_bookmarkpermission"."profile_id" = 1)
    ORDER BY "ozpcenter_bookmarkentry"."id" ASC LIMIT 1

request_profile = Profile.objects.first()
import ozpcenter.api.bookmark.model_access as model_access
root_folder = model_access.create_get_user_root_bookmark_folder(request_profile)
[b for b in BookmarkEntry.objects.filter(bookmark_parent__bookmark_permission__profile=request_profile, bookmark_parent=root_folder)]

"""
import copy

import ozpcenter.models as models
from ozpcenter import errors

FOLDER_TYPE = models.BookmarkEntry.FOLDER
LISTING_TYPE = models.BookmarkEntry.LISTING
BOOKMARK_TYPE_CHOICES = [choice[0] for choice in models.BookmarkEntry.TYPE_CHOICES]
FOLDER_QUERY_ORDER_MAPPING = {
    'created_date': 'created_date',
    '-created_date': '-created_date',
    'title': 'title',
    '-title': '-title'
}
LISTING_QUERY_ORDER_MAPPING = copy.deepcopy(FOLDER_QUERY_ORDER_MAPPING)
LISTING_QUERY_ORDER_MAPPING['title'] = 'listing__title'
LISTING_QUERY_ORDER_MAPPING['-title'] = '-listing__title'


def check_owner_permissions_for_bookmark_entry(request_profile, bookmark_entry):
    """
    Check Permission for bookmark entry

    OWNER can view/add/edit/delete BookmarkEntry and BookmarkPermission models
    VIEWERs have no permissions
    """
    profile_bookmark_permission = models.BookmarkPermission.objects.filter(profile=request_profile, bookmark=bookmark_entry).first()

    if not profile_bookmark_permission:
        raise errors.PermissionDenied('request profile does not have permission to view permissions')
    elif profile_bookmark_permission.user_type == models.BookmarkPermission.VIEWER:
        raise errors.PermissionDenied('request profile does not have permission to view permissions becuase of user_type')
    elif profile_bookmark_permission.user_type == models.BookmarkPermission.OWNER:
        pass
        # Owners are allowed to do view/edit/delete
    else:
        raise errors.PermissionDenied('request profile does not have permission')

    return profile_bookmark_permission


def create_bookmark_entry(request_profile=None, entry_type=None, folder_title=None, listing=None, is_root=None):
    is_folder_type = (entry_type == FOLDER_TYPE)
    is_listing_type = (entry_type == LISTING_TYPE)
    is_root = is_root if is_root is True else False
    try:
        assert request_profile is not None, 'To create bookmark entry, profile is required'
        assert entry_type in BOOKMARK_TYPE_CHOICES, 'Entry Type needs to be one of the following: {}'.format(BOOKMARK_TYPE_CHOICES)

        if is_folder_type:
            if is_root is False and folder_title is None:
                raise AssertionError('Bookmark {} Entry require folder_title and is_root kwargs'.format(FOLDER_TYPE))
        elif is_listing_type and listing is None:
            raise AssertionError('Bookmark {} Entry require listing object'.format(LISTING_TYPE))
    except AssertionError as err:
        raise errors.PermissionDenied(err)

    # Add Bookmark Entry
    bookmark_entry = models.BookmarkEntry()
    bookmark_entry.type = entry_type
    bookmark_entry.is_root = False

    if is_folder_type:
        if is_root:
            bookmark_entry.is_root = True
            bookmark_entry.title = 'ROOT'
        else:
            bookmark_entry.title = folder_title
    elif is_listing_type:
        bookmark_entry.listing = listing

    bookmark_entry.creator_profile = request_profile
    bookmark_entry.save()

    return bookmark_entry


def get_bookmark_entry_by_id(request_profile, id):
    """
    Get bookmark entry by id and filter based on permissions
    Only owner or viewer of folder should be able to see it
    """
    # Validate to make sure user can see folder - bookmark_permission__profile
    query = models.BookmarkEntry.objects.filter(
        id=id,
        bookmark_parent__bookmark_permission__profile=request_profile
    ).first()

    if query is None:
        raise errors.PermissionDenied('Can not view bookmarks')

    return query


def get_user_permissions_for_bookmark_entry(request_profile, bookmark_entry):
    """
    Get permissions for bookmark_entry

    Access Control
        Only Owners should be able to view all the permissions of a bookmark_entry
        Only Owners should be able to edit permissions of a bookmark_entry

    Access Control handle by get_bookmark_entry_by_id
    """
    check_owner_permissions_for_bookmark_entry(request_profile, bookmark_entry)

    query = models.BookmarkPermission.objects.filter(bookmark=bookmark_entry)
    return query


def add_profile_permission_for_bookmark_entry(request_profile, bookmark_entry_folder_to_share, target_profile, target_bookmark, target_user_type=None, share=False):
    """
    Add Profile Permission to Bookmark Entry

    Args:
        request_profile:
            Profile performing the action (view, add, edit, delete)
        bookmark_entry_folder_to_share:
            The folder `request_profile` is trying to share/add permission
        target_profile:
            The profile the `bookmark_entry_folder_to_share` should go to
        target_bookmark:

        target_user_type:

    Steps:
        check to see if `request_profile` has owner permission on the folder `bookmark_entry_folder_to_share` trying to be shared

    Defaults the target_user_type to BookmarkPermission.VIEWER
    """
    check_owner_permissions_for_bookmark_entry(request_profile, bookmark_entry_folder_to_share)
    target_user_type = target_user_type if target_user_type else models.BookmarkPermission.VIEWER

    # Add Bookmark entry to bookmark_entry_folder_to_share folder, add behaves like a set
    target_bookmark.bookmark_parent.add(bookmark_entry_folder_to_share)

    if target_bookmark.type == FOLDER_TYPE:
        bookmark_permission_folder = models.BookmarkPermission()

        if share:
            # If sharing `bookmark_entry_folder_to_share` to a different user
            # it should add permission to `bookmark_entry_folder_to_share` so that `target_profile`
            # has access to it
            bookmark_permission_folder.bookmark = bookmark_entry_folder_to_share
        else:
            bookmark_permission_folder.bookmark = target_bookmark

        bookmark_permission_folder.profile = target_profile
        bookmark_permission_folder.user_type = target_user_type
        bookmark_permission_folder.save()
    elif target_bookmark.type == 'LISTING':
        # LISTINGs inherit folder permissions
        pass


def share_bookmark_entry(request_profile, bookmark_entry_folder_to_share, target_profile, target_profile_bookmark_entry, target_user_type=None):
    """
    Add Profile Permission to Bookmark Entry

    Args:
        request_profile:
            Profile performing the action (view, add, edit, delete)
        bookmark_entry_folder_to_share:
            The folder `request_profile` is trying to share/add permission
        target_profile:
            The profile the `bookmark_entry_folder_to_share` should go to
        target_bookmark:

        target_user_type:

    Steps:
        check to see if `request_profile` has owner permission on the folder `bookmark_entry_folder_to_share` trying to be shared

    Defaults the target_user_type to BookmarkPermission.VIEWER
    """
    check_owner_permissions_for_bookmark_entry(request_profile, bookmark_entry_folder_to_share)
    target_user_type = target_user_type if target_user_type else models.BookmarkPermission.VIEWER

    # Add Bookmark entry to bookmark_entry_folder_to_share folder, add behaves like a set
    # target_profile_bookmark_entry.bookmark_parent.add(bookmark_entry_folder_to_share)

    bookmark_entry_folder_to_share.bookmark_parent.add(target_profile_bookmark_entry)

    if bookmark_entry_folder_to_share.type == FOLDER_TYPE:
        bookmark_permission_folder = models.BookmarkPermission()
        bookmark_permission_folder.bookmark = bookmark_entry_folder_to_share
        bookmark_permission_folder.profile = target_profile
        bookmark_permission_folder.user_type = target_user_type
        bookmark_permission_folder.save()
    elif target_bookmark.type == LISTING_TYPE:
        # LISTINGs inherit folder permissions
        pass


def remove_profile_permission_for_bookmark_entry(request_profile, target_profile, target_bookmark):
    """
    Remove profile from bookmark
    """
    check_owner_permissions_for_bookmark_entry(request_profile, target_bookmark)

    profile_bookmark_permission = models.BookmarkPermission.objects.filter(profile=target_profile, bookmark=target_bookmark).first()

    # if only owner:
    # target_bookmark.delete()
    # # TODO: Does this delete all re


def create_get_user_root_bookmark_folder(request_profile):
    """
    Create or Get user's root folder
    profile = Profile.objects.first()
    """
    # Get Bookmark Entry where it is root folder and joins bookmark_permission using Bookmark Entry's id and user_type is OWNER
    bookmark_entry_query = models.BookmarkEntry.objects.filter(
        bookmark_permission__profile=request_profile,
        bookmark_permission__user_type='OWNER',  # TODO: should index by user_type?
        is_root=True)

    bookmark_entry_query_count = bookmark_entry_query.count()

    if bookmark_entry_query_count:
        if bookmark_entry_query_count >= 2:
            print('A USER SHOULD NOT HAVE MORE THAN ONE ROOT FOLDER')

        return bookmark_entry_query.first()
    else:
        bookmark_entry = create_bookmark_entry(request_profile, FOLDER_TYPE, folder_title='', is_root=True)

        bookmark_permission = models.BookmarkPermission()
        bookmark_permission.bookmark = bookmark_entry
        bookmark_permission.profile = request_profile
        bookmark_permission.user_type = models.BookmarkPermission.OWNER
        bookmark_permission.save()

        return bookmark_entry


def create_folder_bookmark_for_profile(request_profile, folder_name, bookmark_entry_folder=None):
    """
    Create Folder Bookmark for profile

    Args:
        profile (models.Profile): Profile
        folder_name (String): Folder name
        bookmark_entry_folder: (models.BookmarkEntry): Entry folder
    """
    bookmark_entry_folder = bookmark_entry_folder if bookmark_entry_folder else create_get_user_root_bookmark_folder(request_profile)

    if bookmark_entry_folder.type != FOLDER_TYPE:
        raise errors.PermissionDenied('bookmark_entry needs to be a folder type')

    # Only owners of bookmark_entry_folder should be able to add to folder
    check_owner_permissions_for_bookmark_entry(request_profile, bookmark_entry_folder)

    bookmark_folder_entry = create_bookmark_entry(request_profile, FOLDER_TYPE, folder_title=folder_name, is_root=False)

    # Add Permission so that user can see folder and make them owner
    add_profile_permission_for_bookmark_entry(
        request_profile,
        bookmark_entry_folder,
        request_profile,
        bookmark_folder_entry,
        target_user_type=models.BookmarkPermission.OWNER
    )

    return bookmark_folder_entry


def create_listing_bookmark_for_profile(request_profile, listing, bookmark_entry_folder=None):
    """
    Create Listing Bookmark for profile
    """
    bookmark_entry_folder = bookmark_entry_folder if bookmark_entry_folder else create_get_user_root_bookmark_folder(request_profile)

    if bookmark_entry_folder.type != FOLDER_TYPE:
        raise errors.PermissionDenied('bookmark_entry needs to be a folder type')

    # Only owners of bookmark_entry_folder should be able to add to folder
    check_owner_permissions_for_bookmark_entry(request_profile, bookmark_entry_folder)

    bookmark_entry = create_bookmark_entry(request_profile, LISTING_TYPE, listing=listing)

    # Add Permission so that user can see folder and make them owner
    add_profile_permission_for_bookmark_entry(
        request_profile,
        bookmark_entry_folder,
        request_profile,
        bookmark_entry,
        target_user_type=models.BookmarkPermission.OWNER
    )

    return bookmark_entry
