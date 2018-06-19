"""
Tests for library endpoints (listings in a user's library)

TODO: Figure out better way to test
"""
import datetime
import pytz

from django.test import override_settings
from rest_framework import status
from tests.ozp.cases import APITestCase

from ozpcenter import model_access as generic_model_access
from ozpcenter.scripts import sample_data_generator as data_gen
from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_types
from ozpcenter.utils import shorthand_dict


@override_settings(ES_ENABLED=False)
class LibraryApiTest(APITestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None

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
        # import json; print(json.dumps(shorthand_types(response.data), indent=2))
        self.assertEqual(10, len(response.data))
        self.assertIn('listing', response.data[0])
        self.assertIn('id', response.data[0]['listing'])
        self.assertIn('title', response.data[0]['listing'])
        self.assertIn('unique_name', response.data[0]['listing'])
        self.assertIn('folder', response.data[0])

    def test_get_library_self_when_listing_disabled_enabled(self):
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        listing_ids = [record['listing']['id'] for record in response.data]
        first_listing_id = listing_ids[0]  # Should be 2

        self.assertEqual([2, 23, 44, 63, 10, 77, 81, 101, 9, 147], listing_ids, 'Comparing Ids #1')

        # Disable Listing
        APITestHelper.edit_listing(self, first_listing_id, {'is_enabled': False})
        # Get Library for current user after listing was disabled
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        listing_ids = [record['listing']['id'] for record in response.data]
        self.assertEqual([23, 44, 63, 10, 77, 81, 101, 9, 147], listing_ids, 'Comparing Ids #2')

        # Enable Listing
        APITestHelper.edit_listing(self, first_listing_id, {'is_enabled': True})
        # Get Library for current user after listing was Enable
        url = '/api/self/library/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        listing_ids = [record['listing']['id'] for record in response.data]
        self.assertEqual([2, 23, 44, 63, 10, 77, 81, 101, 9, 147], listing_ids, 'Comparings Ids #3')

    def test_get_library_list_listing_type(self):
        url = '/api/self/library/?type=Web Application'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertEqual(4, len(response.data))
        self.assertIn('listing', response.data[0])
        self.assertIn('id', response.data[0]['listing'])
        self.assertIn('title', response.data[0]['listing'])
        self.assertIn('unique_name', response.data[0]['listing'])
        self.assertIn('folder', response.data[0])

    def test_get_library_list_listing_type_empty(self):
        url = '/api/self/library/?type=widget'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertEqual([], response.data)

    def test_get_library_pk(self):
        url = '/api/self/library/55/'
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

    def _compare_library(self, username_bookmark_dict):
        """
        Compare Library for a list of username:bookmark pairs
        """
        username_bookmark_dict_actual = {}
        for username, ids_list in username_bookmark_dict.items():
            url = '/api/self/library/'
            response = APITestHelper.request(self, url, 'GET', username=username, status_code=200)
            before_notification_ids = ['{}-{}'.format(entry['listing']['title'], entry['folder']) for entry in response.data]
            username_bookmark_dict_actual[username] = before_notification_ids

        for username, ids_list in username_bookmark_dict.items():
            before_notification_ids = username_bookmark_dict_actual[username]
            # import pprint
            # print(username)
            # print('_actual_')
            # pprint.pprint(before_notification_ids)
            # print('_expected')
            # pprint.pprint(ids_list)
            # print('----')
            self.assertEqual(sorted(ids_list), sorted(before_notification_ids), 'Checking for {}'.format(username))

    def test_import_bookmarks(self):
        """
        Test import
        """
        bigbrother_bookmark2 = [
            'Tornado-Weather',
            'Lightning-Weather',
            'Snow-Weather',
            'Wolf Finder-Animals',
            'Killer Whale-Animals',
            'Lion Finder-Animals',
            'Monkey Finder-Animals',
            'Parrotlet-Animals',
            'White Horse-Animals',
            'Electric Guitar-Instruments',
            'Acoustic Guitar-Instruments',
            'Sound Mixer-Instruments',
            'Electric Piano-Instruments',
            'Piano-Instruments',
            'Violin-Instruments',
            'Bread Basket-None',
            'Informational Book-None',
            'Stop sign-None',
            'Chain boat navigation-None',
            'Gallery of Maps-None',
            'Chart Course-None'
        ]

        julia_bookmark2 = [
            'Astrology software-None',
        ]

        julia_bookmark2_weather_folder = [
            'Tornado-Weather',
            'Lightning-Weather',
            'Snow-Weather'
        ]

        # Compare Library for users
        self._compare_library({'bigbrother': bigbrother_bookmark2, 'julia': julia_bookmark2})

        # Create notification to share Weater foler from Bigbrother to Julia
        now = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=5)
        data = {'expires_date': str(now),
                'message': 'A Simple Peer to Peer Notification',
                'peer': {
                    'user': {
                      'username': 'julia',
                    },
                    'folder_name': 'Weather'
            }}

        url = '/api/notification/'
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        bookmark_notification1_id = response.data['id']

        # Compare Library for users
        self._compare_library({'bigbrother': bigbrother_bookmark2, 'julia': julia_bookmark2})

        # Import Bookmarks
        results = APITestHelper._import_bookmarks(self, 'julia', bookmark_notification1_id, status_code=201)

        # Add julia_bookmark2_weather_folder to julia_bookmark2 and compare library
        julia_bookmark2 = julia_bookmark2 + julia_bookmark2_weather_folder
        self._compare_library({'bigbrother': bigbrother_bookmark2, 'julia': julia_bookmark2})

        # Modify Bigbrother's library to add another listing to the weather library
        url_lib = '/api/self/library/'
        response = APITestHelper.request(self, url_lib, 'GET', username='bigbrother', status_code=200)

        put_data = []
        position_count = 0

        for current_bookmark_record in response.data:
            current_bookmark_listing_title = current_bookmark_record.get('listing', {}).get('title')

            data = {'id': current_bookmark_record['id'],
                    'folder': current_bookmark_record['folder'],
                    'listing': {'id': current_bookmark_record['listing']['id']},
                    'position': current_bookmark_record['position']
                    }

            if current_bookmark_listing_title == 'Chart Course':
                data['folder'] = "Weather"

            put_data.append(data)

        # Modify Memory version of bigbrother bookmarks
        bigbrother_bookmark2.append("Chart Course-Weather")
        bigbrother_bookmark2 = [record for record in bigbrother_bookmark2 if record not in ['Chart Course-None']]

        url_update = '/api/self/library/update_all/'
        response = APITestHelper.request(self, url_update, 'PUT', data=put_data, username='bigbrother', status_code=200)
        self.assertIsNotNone(response)

        # Recreate the notification to send to Julia to share the folder
        now = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=5)
        data = {'expires_date': str(now),
                'message': 'A Simple Peer to Peer Notification',
                'peer': {
                    'user': {
                      'username': 'julia',
                    },
                    'folder_name': 'Weather'
            }}

        url = '/api/notification/'
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        bookmark_notification1_id = response.data['id']

        # Import Bookmarks
        results = APITestHelper._import_bookmarks(self, 'julia', bookmark_notification1_id, status_code=201)
        # Adding a folder should not duplicate the same listing bookmark in the same folder
        # Compare Library for users
        julia_bookmark2 = julia_bookmark2 + ['Chart Course-Weather']
        self._compare_library({
            'bigbrother': bigbrother_bookmark2,
            'julia': julia_bookmark2
        })
