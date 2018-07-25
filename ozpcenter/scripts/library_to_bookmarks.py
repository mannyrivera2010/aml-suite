"""
Transfer

https://docs.python.org/3/library/copy.html

"""
import sys
import os
import copy

sys.path.insert(0, os.path.realpath(os.path.join(os.path.dirname(__file__), '../../')))

from django.conf import settings
from ozpcenter import models

from ozpcenter.bookmark_helper import BookmarkFolder
from ozpcenter.api.bookmark.model_access import copy_tree_recursive, get_bookmark_tree
import ozpcenter.api.bookmark.serializers as serializers


def _parse_legacy_bookmark_query(application_library_entry_query):
    """
    parse library endpoint bookmarks

    Args:
        application_library_entry_query: ApplicationLibraryEntry Query
    Returns:
        {'bookmark_folder': 'Hello',
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
        'listings': []
    }
    output_template = copy.deepcopy(output)

    folder_mapping = {}

    for application_library_entry in application_library_entry_query:
        folder_name = application_library_entry.folder
        listing = application_library_entry.listing

        if folder_name:
            if folder_name in folder_mapping:
                folder_mapping[folder_name]['listings'].append({'bookmark_listing': listing})

            else:
                folder_mapping[folder_name] = copy.deepcopy(output_template)
                folder_mapping[folder_name]['bookmark_folder_name'] = folder_name
                folder_mapping[folder_name]['listings'].append({'bookmark_listing': listing})
                output['folders'].append(folder_mapping[folder_name])
        else:
            output['listings'].append({'bookmark_listing': listing})

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
    # DELETE_BOOKMARKS = False
    # if DELETE_BOOKMARKS:
    #     print('Deleting BookmarkEntry records')
    #     print(models.BookmarkEntry.objects.all().delete())
    for current_profile in models.Profile.objects.iterator():
        print('Processing Username: {}'.format(current_profile.user.username))
        current_profile_library_query = models.ApplicationLibraryEntry.objects.filter(owner=current_profile)

        copy_tree = _parse_legacy_bookmark_query(current_profile_library_query)
        # import pprint; pprint.pprint(copy_tree)
        copy_tree_objects = copy_tree_recursive(current_profile, copy_tree, None)
        # import pprint; pprint.pprint(copy_tree_objects)

        mocked_request = MockRequest(current_profile)

        data = get_bookmark_tree(current_profile, request=mocked_request, serializer_class=serializers.BookmarkSerializer)
        data = BookmarkFolder.parse_endpoint(data).shorten_data()

        import pprint
        pprint.pprint(data)
        print('-' * 15)
