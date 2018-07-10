"""
Tests for library endpoints (listings in a user's library)

TODO: Figure out better way to test
"""
import datetime
import pytz

from django.test import override_settings
from rest_framework import status
from tests.ozp.cases import APITestCase

from tests.ozp.bookmark_helper import BookmarkFolder, BookmarkListing

from ozpcenter import model_access as generic_model_access
from ozpcenter.scripts import sample_data_generator as data_gen
from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_types
from ozpcenter.utils import shorthand_dict


def _compare_library(test_case_instance, username, expected_bookmark_list):
    """
    Compare Library for a list of username:bookmark pairs
    """
    url = '/api/self/library/'
    response = APITestHelper.request(test_case_instance, url, 'GET', username=username, status_code=200)
    actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)
    actual_library_shorten = actual_library.shorten_data()
    test_case_instance.assertEqual(expected_bookmark_list, actual_library_shorten, 'Checking for {}'.format(username))
    return actual_library


def _create_notification(test_case_instance, from_user, folder, to_user):
    # Recreate the notification to send to Julia to share the folder
    now = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=5)
    data = {'expires_date': str(now),
            'message': 'A Simple Peer to Peer Notification',
            'peer': {
                'user': {
                  'username': to_user,
                },
                'folder_name': folder
        }}

    url = '/api/notification/'
    user = generic_model_access.get_profile(from_user).user
    test_case_instance.client.force_authenticate(user=user)
    response = test_case_instance.client.post(url, data, format='json')
    test_case_instance.assertEqual(response.status_code, status.HTTP_201_CREATED)
    return response


def _library_move_listing_to_folder(test_case_instance, username, listing_name, folder_name):
    url_lib = '/api/self/library/'
    response = APITestHelper.request(test_case_instance, url_lib, 'GET', username=username, status_code=200)

    put_data = []
    position_count = 0

    for current_bookmark_record in response.data:
        current_bookmark_listing_title = current_bookmark_record.get('listing', {}).get('title')

        data = {'id': current_bookmark_record['id'],
                'folder': current_bookmark_record['folder'],
                'listing': {'id': current_bookmark_record['listing']['id']},
                'position': current_bookmark_record['position']
                }

        if current_bookmark_listing_title == listing_name:
            data['folder'] = folder_name

        put_data.append(data)

    url_update = '/api/self/library/update_all/'
    response = APITestHelper.request(test_case_instance, url_update, 'PUT', data=put_data, username='bigbrother', status_code=200)
    test_case_instance.assertIsNotNone(response)


@override_settings(ES_ENABLED=False)
class LibraryApiTest(APITestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None

        self.wsmith_library = [
            '(F) old',
            ' (L) Air Mail',
            ' (L) Bread Basket',
            '(F) heros',
            ' (L) Iron Man',
            ' (L) Jean Grey',
            ' (L) Mallrats',
            '(F) planets',
            ' (L) Azeroth',
            ' (L) Saturn',
            '(L) Diamond',
            '(L) Grandfather clock',
            '(L) Baltimore Ravens',
        ]

        self.wsmith_bookmarks_web_app = [
            '(F) old',
            ' (L) Air Mail',
            ' (L) Bread Basket',
            '(F) planets',
            ' (L) Azeroth',
            ' (L) Saturn'
        ]

        self.bigbrother_bookmark2 = [
            '(F) Weather',
            ' (L) Tornado',
            ' (L) Lightning',
            ' (L) Snow',
            '(F) Animals',
            ' (L) Wolf Finder',
            ' (L) Killer Whale',
            ' (L) Lion Finder',
            ' (L) Monkey Finder',
            ' (L) Parrotlet',
            ' (L) White Horse',
            '(F) Instruments',
            ' (L) Electric Guitar',
            ' (L) Acoustic Guitar',
            ' (L) Sound Mixer',
            ' (L) Electric Piano',
            ' (L) Piano',
            ' (L) Violin',
            '(L) Bread Basket',
            '(L) Informational Book',
            '(L) Stop sign',
            '(L) Chain boat navigation',
            '(L) Gallery of Maps',
            '(L) Chart Course'
        ]

        self.julia_bookmark2 = [
            '(L) Astrology software',
        ]

        self.julia_bookmark2_weather_folder = [
            '(F) Weather',
            ' (L) Tornado',
            ' (L) Lightning',
            ' (L) Snow',
        ]

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_get_library(self):
        url = '/api/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        self.assertIsNotNone(response.data)

    def test_create_library(self):
        """
        test_create_library
        """
        # Listing is Enabled
        response = APITestHelper.create_bookmark(self, 'wsmith', 1, folder_name='', status_code=201)
        self.assertEqual(response.data['listing']['id'], 1)

        # Disable Listing
        APITestHelper.edit_listing(self, 1, {'is_enabled': False}, 'wsmith')

        # POST to /self/library after listing disabled
        response = APITestHelper.create_bookmark(self, 'wsmith', 1, folder_name='', status_code=400)

        # Enabled Listing
        APITestHelper.edit_listing(self, 1, {'is_enabled': True}, 'wsmith')
        # POST to /self/library after listing disabled
        response = APITestHelper.create_bookmark(self, 'wsmith', 1, folder_name='', status_code=201)
        self.assertEqual(response.data['listing']['id'], 1)

    def test_get_library_list(self):
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)
        actual_library_shorten = actual_library.shorten_data()
        self.assertEqual(self.wsmith_library, actual_library_shorten, 'Comparing bookmarks')

    def test_get_library_self_when_listing_disabled_enabled(self):
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)
        first_listing = actual_library.first_listing_bookmark()
        first_listing_id = first_listing.listing_id
        actual_library_shorten = actual_library.shorten_data()
        self.assertEqual(self.wsmith_library, actual_library_shorten, 'Comparing bookmarks #1')

        # Disable Listing
        APITestHelper.edit_listing(self, first_listing_id, {'is_enabled': False})
        first_listing.hidden(True)
        expected_library_shorten = actual_library.shorten_data()

        # Get Library for current user after listing was disabled
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)
        actual_library_shorten = actual_library.shorten_data()

        self.assertEqual(expected_library_shorten, actual_library_shorten, 'Comparing bookmarks #2')

        # Enable Listing
        APITestHelper.edit_listing(self, first_listing_id, {'is_enabled': True})
        first_listing.hidden(False)

        # Get Library for current user after listing was Enable
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)
        actual_library_shorten = actual_library.shorten_data()
        self.assertEqual(self.wsmith_library, actual_library_shorten, 'Comparing bookmarks #3')

    def test_get_library_list_listing_type(self):
        url = '/api/self/library/?type=Web Application'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)
        actual_library_shorten = actual_library.shorten_data()
        self.assertEqual(self.wsmith_bookmarks_web_app, actual_library_shorten, 'Comparing bookmarks')

    def test_get_library_list_listing_type_empty(self):
        url = '/api/self/library/?type=widget'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertEqual([], response.data)

    def test_get_library_pk(self):
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)

        url = '/api/self/library/{}/'.format(actual_library.first_listing_bookmark().id)
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertIn('listing', response.data)
        self.assertIn('id', response.data['listing'])
        self.assertIn('title', response.data['listing'])
        self.assertIn('unique_name', response.data['listing'])
        self.assertIn('folder', response.data)

    def test_library_update_all(self):
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        put_data = []
        position_count = 0

        for current_bookmark_record in response.data:
            position_count = position_count + 1

            data = {'id': current_bookmark_record['id'],
                    'folder': 'test',
                    'listing': {'id': current_bookmark_record['listing']['id']},
                    'position': position_count
                    }
            put_data.append(data)

        url = '/api/self/library/update_all/'
        response = APITestHelper.request(self, url, 'PUT', data=put_data, username='wsmith', status_code=200)
        self.assertIsNotNone(response)

    def test_import_bookmarks(self):
        """
        Test import
        """
        # Compare Library for users
        _compare_library(self, 'bigbrother', self.bigbrother_bookmark2)
        _compare_library(self, 'julia', self.julia_bookmark2)

        # Create notification to share Weather folder from Bigbrother to Julia
        response = _create_notification(self, 'bigbrother', 'Weather', 'julia')
        bookmark_notification1_id = response.data['id']

        # Compare Library for users
        _compare_library(self, 'bigbrother', self.bigbrother_bookmark2)
        _compare_library(self, 'julia', self.julia_bookmark2)

        # Import Bookmarks
        results = APITestHelper._import_bookmarks(self, 'julia', bookmark_notification1_id, status_code=201)

        # Add self.julia_bookmark2_weather_folder to self.julia_bookmark2 and compare library
        self.julia_bookmark2 = self.julia_bookmark2_weather_folder + self.julia_bookmark2

        bigbrother_actual_library = _compare_library(self, 'bigbrother', self.bigbrother_bookmark2)
        julia_actual_library = _compare_library(self, 'julia', self.julia_bookmark2)

        # Modify Bigbrother's library to add another listing to the weather library
        response = _library_move_listing_to_folder(self, 'bigbrother', 'Chart Course', 'Weather')

        # Modify Memory version of bigbrother bookmarks
        bigbrother_actual_library.move('/Chart Course', '/Weather/')

        response = _create_notification(self, 'bigbrother', 'Weather', 'julia')
        bookmark_notification1_id = response.data['id']

        # Import Bookmarks
        results = APITestHelper._import_bookmarks(self, 'julia', bookmark_notification1_id, status_code=201)
        # Adding a folder should not duplicate the same listing bookmark in the same folder
        # Compare Library for users
        julia_actual_library.search('/Weather/').add_listing_bookmark('Chart Course')

        _compare_library(self, 'bigbrother', bigbrother_actual_library.shorten_data())
        _compare_library(self, 'julia', julia_actual_library.shorten_data())
