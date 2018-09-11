"""
Transfer

https://docs.python.org/3/library/copy.html

"""
import sys
import os
import copy

sys.path.insert(0, os.path.realpath(os.path.join(os.path.dirname(__file__), '../../')))

from django.conf import settings
from amlcenter import models

from amlcenter.bookmark_helper import BookmarkFolder
from amlcenter.api.bookmark.model_access import copy_tree_recursive, get_bookmark_tree
import amlcenter.api.bookmark.serializers as serializers


def _parse_legacy_bookmark_query(application_library_entry_query, current_bookmarks_paths=None):
    """
    parse library endpoint bookmarks

    Args:
        application_library_entry_query: ApplicationLibraryEntry Query
        previous_path_data: ['/',
                            '/heros/',
                            '/heros/Iron Man'...]
    Returns:
        {'bookmark_folder': None,
         'bookmark_listing': None,
         'folders': [],
         'listings': [{'bookmark_listing': (killer_whale-['bigbrother'])},
                      {'bookmark_listing': (lion_finder-['bigbrother'])},
                      {'bookmark_listing': (monkey_finder-['bigbrother'])},
                      {'bookmark_listing': (parrotlet-['jones'])},
                      {'bookmark_listing': (white_horse-['bigbrother'])},
                      {'bookmark_listing': (wolf_finder-['bigbrother'])}]}
    """
    current_bookmarks_paths = current_bookmarks_paths if current_bookmarks_paths else []
    output = {
        'bookmark_folder_name': None,
        'bookmark_listing': None,
        'path': '/',
        'folders': [],
        'listings': []
    }
    output_template = copy.deepcopy(output)

    folder_mapping = {}

    for application_library_entry in application_library_entry_query:
        folder_name = application_library_entry.folder
        listing = application_library_entry.listing

        if folder_name:
            folder_listing_path = '/{}/{}'.format(folder_name, listing.title)
            folder_path = '/{}/'.format(folder_name)

            if folder_path in current_bookmarks_paths:
                print('skip folder bookmark: {}'.format(folder_path))
                continue

            if folder_listing_path in current_bookmarks_paths:
                print('skip listing bookmark: {}'.format(folder_listing_path))
                continue

            if folder_name in folder_mapping:
                folder_mapping[folder_name]['listings'].append({
                    'bookmark_listing': listing,
                    'path': folder_listing_path})
            else:
                folder_mapping[folder_name] = copy.deepcopy(output_template)
                folder_mapping[folder_name]['bookmark_folder_name'] = folder_name
                folder_mapping[folder_name]['path'] = folder_path

                folder_mapping[folder_name]['listings'].append({
                    'bookmark_listing': listing,
                    'path': folder_listing_path})
                output['folders'].append(folder_mapping[folder_name])
        else:
            folder_listing_path = '/{}'.format(listing.title)

            if folder_listing_path in current_bookmarks_paths:
                print('skip listing bookmark: {}'.format(folder_listing_path))
                continue

            output['listings'].append({
                'bookmark_listing': listing,
                'path': folder_listing_path})

    return output


class MockRequest(object):
    def __init__(self, current_profile):
        self.user = current_profile.user
        self.build_absolute_uri = lambda url: url
        self.GET = []


def run():
    """
    Convert ApplicationLibraryEntry (2.0) to BookmarkEntry (3.0)
    """
    DELETE_BOOKMARKS = False

    for current_profile in models.Profile.objects.iterator():
        print('--Processing Username: {}'.format(current_profile.user.username))
        mocked_request = MockRequest(current_profile)

        if DELETE_BOOKMARKS:
            print('Deleting BookmarkEntry records for user, WARNING: it might also delete shared folders')
            print(models.BookmarkEntry.objects.filter(creator_profile=current_profile).delete())

        current_profile_library_query = models.ApplicationLibraryEntry.objects.filter(owner=current_profile)

        # Getting Current Bookmarks
        current_bookmarks = get_bookmark_tree(current_profile, request=mocked_request, serializer_class=serializers.BookmarkSerializer)
        current_bookmarks_paths = BookmarkFolder.parse_endpoint(current_bookmarks).filesystem_structure_list()

        # Creating Copy Tree
        copy_tree = _parse_legacy_bookmark_query(current_profile_library_query, current_bookmarks_paths)
        # import pprint; pprint.pprint(copy_tree)
        copy_tree_objects = copy_tree_recursive(current_profile, copy_tree, None)
        # import pprint; pprint.pprint(copy_tree_objects)

        print('--Bookmarks for Username: {}'.format(current_profile.user.username))
        data = get_bookmark_tree(current_profile, request=mocked_request, serializer_class=serializers.BookmarkSerializer)
        data = BookmarkFolder.parse_endpoint(data).filesystem_structure_list()

        import pprint
        pprint.pprint(data)
        print('-' * 15)
