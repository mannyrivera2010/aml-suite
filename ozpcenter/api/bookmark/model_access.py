from ozpcenter import models
import ozpcenter.api.bookmark.serializers as serializers


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


"""
http://127.0.0.1:8001/api/bookmark/
"""


def get_bookmark_tree(profile, request):
    local_query = models.BookmarkEntry.objects.filter(
        bookmark_parent=create_get_user_root_bookmark_folder(profile),
        bookmark_permission__profile=profile  # Validate to make sure user can see folder
    )
    local_data = serializers.BookmarkSerializer(local_query, many=True, context={'request': request}).data
    return get_nested_bookmarks_tree(profile, local_data, request=request)


def get_nested_bookmarks_tree(profile, data, serialized=False, request=None):
    output = []
    for current_record in data:
        if current_record.get('type') == 'FOLDER':

            local_query = models.BookmarkEntry.objects.filter(
                bookmark_parent=current_record['id'],
                bookmark_permission__profile=profile  # Validate to make sure user can see folder
            )
            print(local_query.query)
            local_data = serializers.BookmarkSerializer(local_query, many=True, context={'request': request}).data

            current_record['children'] = get_nested_bookmarks_tree(profile, local_data, request=request)

        output.append(current_record)
    return output
