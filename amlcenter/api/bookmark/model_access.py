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

https://aml-development.github.io/aml-backend/features/shared_folders_2018/
---------

    query = models.BookmarkEntry.objects.filter(
        id=id,
        bookmark_permission__profile=request_profile  # Validate to make sure user can see folder)
    ).first()

    SELECT *
    FROM "amlcenter_bookmarkentry"
    INNER JOIN "amlcenter_bookmarkpermission" ON ("amlcenter_bookmarkentry"."id" = "amlcenter_bookmarkpermission"."bookmark_id")
    WHERE ("amlcenter_bookmarkentry"."id" = 21 AND "amlcenter_bookmarkpermission"."profile_id" = 1)
    ORDER BY "amlcenter_bookmarkentry"."id" ASC LIMIT 1

request_profile = Profile.objects.first()
import amlcenter.api.bookmark.model_access as model_access
root_folder = model_access.create_get_user_root_bookmark_folder(request_profile)
[b for b in BookmarkEntry.objects.filter(bookmark_parent__bookmark_permission__profile=request_profile, bookmark_parent=root_folder)]

"""
import copy

import amlcenter.models as models
from amlcenter.pubsub import dispatcher
from amlcenter import errors

from amlcenter.pipe import pipes
from amlcenter.pipe import pipeline
from amlcenter.recommend import recommend_utils


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


def check_permission_for_bookmark_entry(request_profile, bookmark_entry, allow_owner=True, allow_viewer=False):
    """
    Check Permission for bookmark entry

    OWNER can view/add/edit/delete BookmarkEntry and BookmarkPermission models
    VIEWERs have no permissions
    """
    bookmark_entry_type = bookmark_entry.type

    profile_bookmark_permission = None

    if bookmark_entry_type == FOLDER_TYPE:
        profile_bookmark_permission = models.BookmarkPermission.objects.filter(
            profile=request_profile,
            bookmark=bookmark_entry)
    elif bookmark_entry_type == LISTING_TYPE:
        profile_bookmark_permission = models.BookmarkPermission.objects.filter(
            profile=request_profile,
            bookmark__bookmarkentry=bookmark_entry)

    # Convert query to BookmarkPermission object
    if profile_bookmark_permission:
        profile_bookmark_permission = profile_bookmark_permission.first()

    if not profile_bookmark_permission:
        raise errors.PermissionDenied('request profile does not have permission to view permissions')
    elif profile_bookmark_permission.user_type == models.BookmarkPermission.VIEWER:
        if allow_viewer is False:
            raise errors.PermissionDenied('request profile does not have permission to view permissions because of user_type')
    elif profile_bookmark_permission.user_type == models.BookmarkPermission.OWNER:
        if allow_owner is False:
            raise errors.PermissionDenied('request profile does not have permission to view permissions because of user_type')
    else:
        raise errors.PermissionDenied('request profile does not have permission')

    return profile_bookmark_permission


def _validate_create_bookmark_entry(request_profile=None, entry_type=None, folder_title=None, listing=None, is_root=None):
    """
    Validate values for creating bookmark entries
    """
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


def create_bookmark_entry(request_profile=None, entry_type=None, folder_title=None, listing=None, is_root=None):
    """
    Create BookmarkEntry

    Args:
        request_profile
        entry_type
        folder_title
        listing
        is_root
    """
    is_folder_type = (entry_type == FOLDER_TYPE)
    is_listing_type = (entry_type == LISTING_TYPE)
    is_root = is_root if is_root is True else False
    _validate_create_bookmark_entry(request_profile, entry_type, folder_title, listing, is_root)

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
    check_permission_for_bookmark_entry(request_profile, bookmark_entry)

    if bookmark_entry.type != FOLDER_TYPE:
        raise errors.PermissionDenied('Can only check permissions for folder bookmarks')

    query = models.BookmarkPermission.objects.filter(bookmark=bookmark_entry)
    return query


def get_bookmark_permission_by_id(request_profile, bookmark_entry, id):
    """
    Get bookmark entry by id and filter based on permissions
    Only owner or viewer of folder should be able to see it
    """
    query = get_user_permissions_for_bookmark_entry(request_profile, bookmark_entry)
    return query.get(id=id)


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
    check_permission_for_bookmark_entry(request_profile, bookmark_entry_folder_to_share)
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


def share_bookmark_entry(request_profile, bookmark_entry_folder_to_share, target_profile, target_profile_bookmark_entry=None, target_user_type=None):
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
    check_permission_for_bookmark_entry(request_profile, bookmark_entry_folder_to_share)
    target_user_type = target_user_type if target_user_type else models.BookmarkPermission.VIEWER

    if bookmark_entry_folder_to_share.type != FOLDER_TYPE:
        raise errors.PermissionDenied('bookmark_entry needs to be a folder type')

    # Check if target profile already has permissions for BookmarkEntry
    existing_target_profile_permission = models.BookmarkPermission.objects.filter(
        bookmark=bookmark_entry_folder_to_share,
        profile=target_profile
    ).first()

    if existing_target_profile_permission:
        raise errors.PermissionDenied('target user already has access to folder')

    # Add Bookmark entry to bookmark_entry_folder_to_share folder, add behaves like a set
    # target_profile_bookmark_entry.bookmark_parent.add(bookmark_entry_folder_to_share)
    if not target_profile_bookmark_entry:
        target_profile_bookmark_entry = create_get_user_root_bookmark_folder(target_profile)

    bookmark_entry_folder_to_share.bookmark_parent.add(target_profile_bookmark_entry)

    if bookmark_entry_folder_to_share.type == FOLDER_TYPE:
        bookmark_permission_folder = models.BookmarkPermission()
        bookmark_permission_folder.bookmark = bookmark_entry_folder_to_share
        bookmark_permission_folder.profile = target_profile
        bookmark_permission_folder.user_type = target_user_type
        bookmark_permission_folder.save()
        return bookmark_permission_folder
    elif target_bookmark.type == LISTING_TYPE:
        # LISTINGs inherit folder permissions
        pass


def update_profile_permission_for_bookmark_entry(request_profile, bookmark_permission_entry, user_type):
    """
    Update Profile Permission for Bookmark Entry

    Assumes all the permission checks happen before this is called for bookmark_permission_entry
    """
    bookmark_permission_entry_profile = bookmark_permission_entry.profile

    if request_profile == bookmark_permission_entry_profile:
        raise errors.PermissionDenied('can only update permissions for other users')

    bookmark_permission_entry.user_type = user_type
    bookmark_permission_entry.save()
    return bookmark_permission_entry


def remove_profile_permission_for_bookmark_entry(request_profile, target_profile, target_bookmark):
    """
    Remove profile from bookmark
    """
    check_permission_for_bookmark_entry(request_profile, target_bookmark)

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
        bookmark_entry = create_bookmark_entry(request_profile, FOLDER_TYPE, folder_title='ROOT', is_root=True)

        bookmark_permission = models.BookmarkPermission()
        bookmark_permission.bookmark = bookmark_entry
        bookmark_permission.profile = request_profile
        bookmark_permission.user_type = models.BookmarkPermission.OWNER
        bookmark_permission.save()

        return bookmark_entry


def create_folder_bookmark_for_profile(request_profile, folder_name, bookmark_entry_folder=None, bookmark_children=None, listing_object=None):
    """
    Create Folder Bookmark for profile

    Args:
        profile (models.Profile): Profile
        folder_name (String): Folder name
        bookmark_entry_folder: (models.BookmarkEntry): Entry folder
        bookmark_children: (List of Integers)
    """
    bookmark_entry_folder = bookmark_entry_folder if bookmark_entry_folder else create_get_user_root_bookmark_folder(request_profile)
    bookmark_children = bookmark_children if bookmark_children else []

    if bookmark_entry_folder.type != FOLDER_TYPE:
        raise errors.PermissionDenied('bookmark_entry needs to be a folder type')

    # Only owners of bookmark_entry_folder should be able to add to folder
    check_permission_for_bookmark_entry(request_profile, bookmark_entry_folder)

    bookmark_folder_entry = create_bookmark_entry(request_profile, FOLDER_TYPE, folder_title=folder_name, is_root=False)

    # Add Permission so that user can see folder and make them owner
    add_profile_permission_for_bookmark_entry(
        request_profile,
        bookmark_entry_folder,
        request_profile,
        bookmark_folder_entry,
        target_user_type=models.BookmarkPermission.OWNER
    )

    # TODO: What is this doing?
    for bookmark_child in bookmark_children:
        update_bookmark_entry_for_profile(
            request_profile,
            get_bookmark_entry_by_id(request_profile, bookmark_child),
            bookmark_folder_entry,
            None)

    if listing_object:
        create_listing_bookmark_for_profile(request_profile, listing_object, bookmark_folder_entry)

    return bookmark_folder_entry


def create_listing_bookmark_for_profile(request_profile, listing, bookmark_entry_folder=None):
    """
    Create Listing Bookmark for profile
    """
    bookmark_entry_folder = bookmark_entry_folder if bookmark_entry_folder else create_get_user_root_bookmark_folder(request_profile)

    if bookmark_entry_folder.type != FOLDER_TYPE:
        raise errors.PermissionDenied('bookmark_entry needs to be a folder type')

    # Only owners of bookmark_entry_folder should be able to add to folder
    check_permission_for_bookmark_entry(request_profile, bookmark_entry_folder)

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


def update_bookmark_entry_for_profile(request_profile, bookmark_entry_instance, bookmark_parent_object, title):
    """
    Update Bookmark Entries

    Method Responsibilities:
        * Rename folder bookmark titles
        * Moving folder/listing bookmarks under different folders

    Args:
        request_profile
        bookmark_entry_instance
        bookmark_parent_object:
            `BookmarkEntry` bookmark instance where request_profile want to put bookmark_entry_instance in that folder
        title
    """
    if bookmark_parent_object is None and title is None:
        raise errors.PermissionDenied('Need at least the bookmark_parent or title field')
    # Check to see if request profile has access to bookmark_entry_instance
    # (bookmark_entry_instance can be folder or listing bookmark)
    check_permission_for_bookmark_entry(request_profile, bookmark_entry_instance)

    folder_title_changed = False
    bookmark_entry_moved = False

    if bookmark_parent_object:
        if bookmark_parent_object.type != FOLDER_TYPE:
            raise errors.PermissionDenied('bookmark_parent_object needs to be a folder type')
        # make sure user has owner access on bookmark_parent_object
        check_permission_for_bookmark_entry(request_profile, bookmark_parent_object)

        # get bookmark entries to folder relationships for request_profile
        bookmark_entry_folder_relationships = bookmark_entry_instance.bookmark_parent.filter(
            bookmark_permission__profile=request_profile)
        bookmark_entry_instance.bookmark_parent.remove(*bookmark_entry_folder_relationships)

        bookmark_entry_instance.bookmark_parent.add(bookmark_parent_object)
        bookmark_entry_moved = True

    if bookmark_entry_instance.type == FOLDER_TYPE:
        if title:
            bookmark_entry_instance.title = title
            folder_title_changed = True

    bookmark_entry_instance.save()

    if bookmark_entry_moved or folder_title_changed:
        dispatcher.publish('update_bookmark_entry',
            bookmark_entry_instance=bookmark_entry_instance,
            bookmark_parent_object=bookmark_parent_object,
            folder_title_changed=folder_title_changed,
            bookmark_entry_moved=bookmark_entry_moved)

    return bookmark_entry_instance


def build_copy_tree_recursive(request_profile, bookmark_entry_instance):
    """
    Build Tree with Folder Title and Listings to make copies of recursively

    Args:
        request_profile
        bookmark_entry_instance
    Returns:
        {'bookmark_folder': 'Animals',
         'bookmark_listing': None,
         'folders': [],
         'listings': [{'bookmark_listing': (killer_whale-['bigbrother'])},
                      {'bookmark_listing': (lion_finder-['bigbrother'])},
                      {'bookmark_listing': (monkey_finder-['bigbrother'])},
                      {'bookmark_listing': (parrotlet-['jones'])},
                      {'bookmark_listing': (white_horse-['bigbrother'])},
                      {'bookmark_listing': (wolf_finder-['bigbrother'])}]}
    """
    output = {
        'bookmark_folder_name': None,
        'bookmark_listing': None,
        'folders': [],
        'listings': [],
    }
    if bookmark_entry_instance.type == FOLDER_TYPE:
        folder_name = bookmark_entry_instance.title
        if not bookmark_entry_instance.is_root:
            folder_name = '{}(COPY)'.format(folder_name)
            output['bookmark_folder_name'] = folder_name

        folder_query = models.BookmarkEntry.manager.filter(
            type=FOLDER_TYPE,
            bookmark_parent__bookmark_permission__profile=request_profile,
            bookmark_parent=bookmark_entry_instance
        )

        listing_query = models.BookmarkEntry.manager.filter(
            type=LISTING_TYPE,
            bookmark_parent__bookmark_permission__profile=request_profile,
            bookmark_parent=bookmark_entry_instance
        )

        for current_bookmark_folder in folder_query:
            output['folders'].append(build_copy_tree_recursive(request_profile, current_bookmark_folder))

        for current_bookmark_listing in listing_query:
            current_bookmark_listing = {
                'bookmark_listing': current_bookmark_listing.listing,
            }
            output['listings'].append(current_bookmark_listing)
    elif bookmark_entry_instance.type == LISTING_TYPE:
        output['bookmark_listing'] = bookmark_entry_instance.listing
    return output


def copy_tree_recursive(request_profile, copy_tree_dict, bookmark_folder_instance):
    """
    Create Copy recursively
    Args:
        request_profile:
        copy_tree_dict: takes in dictionary structure created by build_copy_tree_recursive method
        bookmark_folder_instance

    Returns:
        {'bookmark_folder_instance': BookmarkEntry(79, bookmark_parent:['ROOT'],title:Animals,type:FOLDER,is_root:False,listing:None),
         'bookmark_listing_instance': None,
         'folder_instances': [],
         'listing_instances': [
            BookmarkEntry(80, bookmark_parent:['Animals'],title:,type:LISTING,is_root:False,listing:(killer_whale-['bigbrother'])),
            BookmarkEntry(81, bookmark_parent:['Animals'],title:,type:LISTING,is_root:False,listing:(lion_finder-['bigbrother'])),
            BookmarkEntry(82, bookmark_parent:['Animals'],title:,type:LISTING,is_root:False,listing:(monkey_finder-['bigbrother'])),
            BookmarkEntry(83, bookmark_parent:['Animals'],title:,type:LISTING,is_root:False,listing:(parrotlet-['jones'])),
            BookmarkEntry(84, bookmark_parent:['Animals'],title:,type:LISTING,is_root:False,listing:(white_horse-['bigbrother'])),
            BookmarkEntry(85, bookmark_parent:['Animals'],title:,type:LISTING,is_root:False,listing:(wolf_finder-['bigbrother']))]}
    """
    bookmark_folder_instance = bookmark_folder_instance if bookmark_folder_instance else create_get_user_root_bookmark_folder(request_profile)

    output = {
        'bookmark_folder_instance': None,
        'bookmark_listing_instance': None,
        'folder_instances': [],
        'listing_instances': [],
    }

    bookmark_listing = copy_tree_dict['bookmark_listing']

    if bookmark_listing:
        output['bookmark_listing_instance'] = create_listing_bookmark_for_profile(
            request_profile,
            bookmark_listing,
            bookmark_entry_folder=bookmark_folder_instance
        )

    bookmark_folder_copied_instance = bookmark_folder_instance
    bookmark_folder_name = copy_tree_dict['bookmark_folder_name']
    if bookmark_folder_name:
        bookmark_folder_copied_instance = create_folder_bookmark_for_profile(
            request_profile,
            bookmark_folder_name,
            bookmark_entry_folder=bookmark_folder_instance
        )
        output['bookmark_folder_instance'] = bookmark_folder_copied_instance

    folders = copy_tree_dict['folders']
    for current_copy_tree_dict in folders:
        internal_copy_tree = copy_tree_recursive(request_profile, current_copy_tree_dict, bookmark_folder_copied_instance)
        output['folder_instances'].append(internal_copy_tree)

    listings = copy_tree_dict['listings']
    for current_listing_record in listings:
        current_bookmark_listing = current_listing_record['bookmark_listing']

        output['listing_instances'].append(create_listing_bookmark_for_profile(
            request_profile,
            current_bookmark_listing,
            bookmark_entry_folder=bookmark_folder_copied_instance
        ))
    return output


def duplicate_bookmark_entry_for_profile(request_profile, bookmark_entry_to_copy, dest_bookmark_folder=None):
    """
    Duplicate Bookmark Entry for profile
    """
    check_permission_for_bookmark_entry(request_profile, bookmark_entry_to_copy, allow_viewer=True)
    copy_tree_dict = build_copy_tree_recursive(request_profile, bookmark_entry_to_copy)

    dest_bookmark_folder = dest_bookmark_folder if dest_bookmark_folder else create_get_user_root_bookmark_folder(request_profile)
    copy_tree = copy_tree_recursive(request_profile, copy_tree_dict, dest_bookmark_folder)

    bookmark_folder_instance = copy_tree.get('bookmark_folder_instance')
    bookmark_listing_instance = copy_tree.get('bookmark_listing_instance')

    if bookmark_folder_instance:
        return bookmark_folder_instance
    elif bookmark_listing_instance:
        return bookmark_listing_instance
    else:
        return dest_bookmark_folder


def build_folder_queries_recursive_flatten(request_profile, bookmark_entry_instance, is_start=True, expand=False):
    """
    Build Queries to get all folder and listing queries under a bookmark_entry folder bookmark recursively

    shell usage:
        from amlcenter.api.bookmark.model_access import build_folder_queries_recursive_flatten
        b = BookmarkEntry.objects.first()
        p = BookmarkEntry.objects.first().bookmark_permission.first().profile
        build_folder_queries_recursive_flatten(p, b)

    Args:
        request_profile
        bookmark_entry_instance
        is_start

    Returns:
        [
            listing_query(Root),
            listing_query(Folder2),
            BookmarkEntry(Folder2),
            listing_query(Folder1),
            BookmarkEntry(Folder1),
            BookmarkEntry(Root)
        ]
    """
    output = []

    folder_query = models.BookmarkEntry.manager.filter(type=FOLDER_TYPE)
    listing_query = models.BookmarkEntry.manager.filter(type=LISTING_TYPE)

    if is_start:
        folder_query = folder_query.filter(bookmark_parent__bookmark_permission__profile=request_profile)  # Validate to make sure user can see folder
        listing_query = listing_query.filter(bookmark_parent__bookmark_permission__profile=request_profile)  # Validate to make sure user can see folder,

    folder_query = folder_query.filter(bookmark_parent=bookmark_entry_instance)
    listing_query = listing_query.filter(bookmark_parent=bookmark_entry_instance)

    if expand is True:
        for current_listing in listing_query:
            output.append(current_listing)
    else:
        output.append(listing_query)

    for folder_entry in folder_query:
        output.extend(build_folder_queries_recursive_flatten(request_profile, folder_entry, is_start=False))

    output.append(bookmark_entry_instance)

    return output


def delete_bookmark_entry_for_profile(request_profile, bookmark_entry_instance):
    """
    Delete Bookmark Entry for profile
    Validate make sure user has access

    Deleting a BookmarkEntry that is a folder will have this behavior
        BookmarkEntry.manager.get(id=5).delete()

        DELETE FROM "bookmark_parents" WHERE "bookmark_parents"."from_bookmarkentry_id" IN (5)
        DELETE FROM "bookmark_parents" WHERE "bookmark_parents"."to_bookmarkentry_id" IN (5)
        DELETE FROM "amlcenter_bookmarkpermission" WHERE "amlcenter_bookmarkpermission"."bookmark_id" IN (5)
        DELETE FROM "amlcenter_bookmarkentry" WHERE "amlcenter_bookmarkentry"."id" IN (5)

        (5,
         {'amlcenter.BookmarkEntry': 1,
          'amlcenter.BookmarkEntry_bookmark_parent': 3,
          'amlcenter.BookmarkPermission': 1})
    """
    check_permission_for_bookmark_entry(request_profile, bookmark_entry_instance)

    if bookmark_entry_instance.type == FOLDER_TYPE:
        # root_folder = create_get_user_root_bookmark_folder(request_profile)
        folder_queries = build_folder_queries_recursive_flatten(request_profile, bookmark_entry_instance, is_start=True)

        dispatcher.publish('remove_bookmark_folder', bookmark_entry=bookmark_entry_instance, folder_queries=folder_queries)

        for current_query in folder_queries:
            current_query.delete()

    elif bookmark_entry_instance.type == LISTING_TYPE:
        # If bookmark_entry_instance type is LISTING_TYPE then just delete
        bookmark_entry_instance.delete()


def _create_folder_listing_queries_and_serialized(request_profile, folder_bookmark_entry, is_parent=None, ordering_fields=None, serializer_class=None, request=None):
    """
    Create queries to get folder and listing data

    Args:
        request_profile:
            used to filter profile bookmarks
        request:
            used for serializer to create urls
        folder_bookmark_entry:
        is_parent:
        ordering_fields:
    """
    is_parent = is_parent if is_parent else False
    ordering_fields = ordering_fields if ordering_fields else ['created_date']

    folder_query = models.BookmarkEntry.objects.filter(
        type=FOLDER_TYPE,
        bookmark_parent__bookmark_permission__profile=request_profile  # Validate to make sure user can see folder
    )

    # for_profile should do `private listing` check for listing
    listing_query = models.BookmarkEntry.objects.for_profile_minus_security_marking(request_profile).filter(
        type=LISTING_TYPE,
        bookmark_parent__bookmark_permission__profile=request_profile  # Validate to make sure user can see folder,
    )

    folder_order_fields = []
    listing_order_fields = []

    for ordering_field in ordering_fields:
        if ordering_field in FOLDER_QUERY_ORDER_MAPPING:
            folder_order_fields.append(FOLDER_QUERY_ORDER_MAPPING[ordering_field])

        if ordering_field in LISTING_QUERY_ORDER_MAPPING:
            listing_order_fields.append(LISTING_QUERY_ORDER_MAPPING[ordering_field])

    folder_query = folder_query.order_by(*folder_order_fields)
    listing_query = listing_query.order_by(*listing_order_fields)

    if is_parent:
        folder_query = folder_query.filter(id=folder_bookmark_entry.id)
        listing_query = listing_query.filter(id=folder_bookmark_entry.id)
    else:
        folder_query = folder_query.filter(bookmark_parent=folder_bookmark_entry)
        listing_query = listing_query.filter(bookmark_parent=folder_bookmark_entry)

    folder_data = serializer_class(folder_query, many=True, context={'request': request}).data
    listing_data = serializer_class(listing_query, many=True, context={'request': request}).data

    # Filter out all listings that request_profile does not have access to
    listing_data_after_filter = pipeline.Pipeline(recommend_utils.ListIterator(listing_data),
                                    [pipes.BookmarkListingDictPostSecurityMarkingCheckPipe(request_profile.user.username)]).to_list()

    return {"folder_data": folder_data,
            "listing_data_after_filter": listing_data_after_filter}


def get_bookmark_tree(request_profile, folder_bookmark_entry=None, is_parent=None, serializer_class=None, request=None, ordering_fields=None, is_shared=None):
    """
    Helper Function to get all nested bookmark

    Args:
        request_profile
        request
        folder_bookmark_entry
        is_parent
    """
    folder_bookmark_entry = folder_bookmark_entry if folder_bookmark_entry else create_get_user_root_bookmark_folder(request_profile)
    is_parent = is_parent if is_parent is not None else False

    bookmarks_dict = _create_folder_listing_queries_and_serialized(
        request_profile,
        folder_bookmark_entry,
        is_parent,
        serializer_class=serializer_class,
        request=request,
        ordering_fields=ordering_fields,
    )

    nested_folder_tree = _get_nested_bookmarks_tree(
        request_profile,
        bookmarks_dict['folder_data'],
        serializer_class=serializer_class,
        request=request,
        ordering_fields=ordering_fields,
        is_shared=is_shared
    )

    return {
        "folders": nested_folder_tree,
        # "folders": bookmarks_dict['folder_data'],
        "listings": bookmarks_dict['listing_data_after_filter'] if (is_shared is False or is_shared is None) else []
    }


def _get_nested_bookmarks_tree(request_profile, data, serializer_class=None, request=None, ordering_fields=None, is_shared=None):
    """
    Recursive function to get all the nested folder and listings

    Args:
        data: a list of serialized data in python objects using serializer_class
    """
    output = []
    for current_record in data:
        append_record = False

        if current_record.get('type') == 'FOLDER':
            current_record_is_shared = current_record.get('is_shared')

            if is_shared is current_record_is_shared and is_shared is True:
                append_record = True
            elif is_shared is current_record_is_shared and is_shared is False:
                append_record = True
            elif is_shared is None:
                append_record = True

            if append_record is True:
                bookmarks_dict = _create_folder_listing_queries_and_serialized(
                    request_profile,
                    current_record['id'],
                    serializer_class=serializer_class,
                    request=request,
                    ordering_fields=ordering_fields,
                )

                nested_folder_tree = _get_nested_bookmarks_tree(
                    request_profile,
                    bookmarks_dict['folder_data'],
                    serializer_class=serializer_class,
                    request=request,
                    ordering_fields=ordering_fields,
                    is_shared=is_shared
                )

                current_record['children'] = {
                    "folders": nested_folder_tree,
                    "listings": bookmarks_dict['listing_data_after_filter']
                }
        else:
            append_record = True

        if append_record is True:
            output.append(current_record)
    return output
