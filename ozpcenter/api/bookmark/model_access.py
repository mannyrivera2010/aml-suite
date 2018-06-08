import ozpcenter.models as models


def create_get_user_root_bookmark_folder(profile):
    """
    Create or Get user's root folder
    profile = Profile.objects.first()
    """
    bookmark_entry_query = models.BookmarkEntry.objects.filter(
        bookmark_permission__profile=profile,
        bookmark_permission__user_type='OWNER',
        is_root=True)

    if bookmark_entry_query:
        if len(bookmark_entry_query) >= 2:
            print('A USER SHOULD NOT HAVE MORE THAN ONE ROOT FOLDER')

        return bookmark_entry_query[0]
    else:
        bookmark_entry = models.BookmarkEntry()
        bookmark_entry.type = bookmark_entry.FOLDER
        bookmark_entry.is_root = True
        bookmark_entry.title = 'ROOT'
        bookmark_entry.creator_profile = profile
        bookmark_entry.save()

        bookmark_permission = models.BookmarkPermission()
        bookmark_permission.bookmark = bookmark_entry
        bookmark_permission.profile = profile
        bookmark_permission.user_type = models.BookmarkPermission.OWNER
        bookmark_permission.save()

        return bookmark_entry


def get_nested_bookmarks_flatten(profile):
    """
    Can only handle 1 level of nested folders
    """
    output = []
    queue = list(models.BookmarkEntry.objects.filter(bookmark_parent=create_get_user_root_bookmark_folder(profile)))

    while queue:
        current_item = queue.pop(0)

        if current_item.type == 'LISTING':
            output.append(current_item)
        else:
            queue.extend(list(models.BookmarkEntry.objects.filter(bookmark_parent=current_item)))

    return output


def create_folder_bookmark_for_profile(profile, folder_name, bookmark_entry_root_folder=None):
    """
    Create Folder Bookmark for profile
    """
    bookmark_entry_root_folder = bookmark_entry_root_folder if bookmark_entry_root_folder else create_get_user_root_bookmark_folder(profile)

    # TODO: bookmark_entry_root_folder.type != models.BookmarkEntry.FOLDER throw error
    bookmark_folder_entry = models.BookmarkEntry()
    bookmark_folder_entry.type = models.BookmarkEntry.FOLDER
    bookmark_folder_entry.is_root = False
    bookmark_folder_entry.title = folder_name
    bookmark_folder_entry.creator_profile = profile
    bookmark_folder_entry.save()

    # Add Bookmark entry to bookmark_entry_root_folder folder, add behaves like a set
    bookmark_folder_entry.bookmark_parent.add(bookmark_entry_root_folder)

    bookmark_permission_folder = models.BookmarkPermission()
    bookmark_permission_folder.bookmark = bookmark_folder_entry
    bookmark_permission_folder.profile = profile
    bookmark_permission_folder.user_type = models.BookmarkPermission.OWNER
    bookmark_permission_folder.save()

    return bookmark_folder_entry


def create_listing_bookmark_for_profile(profile, listing, folder_bookmark_entry=None):
    """
    Create Listing Bookmark for profile
    """
    folder_bookmark_entry = folder_bookmark_entry if folder_bookmark_entry else create_get_user_root_bookmark_folder(profile)

    # TODO: bookmark_entry_root_folder.type != models.BookmarkEntry.FOLDER throw error

    # Add Bookmark Entry
    bookmark_entry = models.BookmarkEntry()
    bookmark_entry.type = models.BookmarkEntry.LISTING
    bookmark_entry.is_root = False
    bookmark_entry.listing = listing
    bookmark_entry.creator_profile = profile
    # bookmark_entry.title = 'LISTING'
    bookmark_entry.save()

    # Add Bookmark entry to current user root folder, add behaves like a set
    bookmark_entry.bookmark_parent.add(folder_bookmark_entry)

    # Add Permission so that user can see folder and make them owner
    bookmark_permission = models.BookmarkPermission()
    bookmark_permission.bookmark = bookmark_entry
    bookmark_permission.profile = profile
    bookmark_permission.user_type = models.BookmarkPermission.OWNER
    bookmark_permission.save()

    return bookmark_entry


def get_bookmark_entry_by_id(profile, id):
    """
    Get bookmark entry by id and filter based on permissions
    Only owner or viewer of folder should be able to see it
    """
    return models.BookmarkEntry.objects.get(
        id=id,
        bookmark_permission__profile=profile  # Validate to make sure user can see folder)
    )
