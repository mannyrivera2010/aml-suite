"""
Tests for library endpoints (listings in a user's library)

TODO: Figure out better way to test
"""
from django.test import override_settings
from rest_framework import status
from rest_framework.test import APITestCase

from ozpcenter import model_access as generic_model_access
from ozpcenter.scripts import sample_data_generator as data_gen

from tests.ozpcenter.helper import APITestHelper


@override_settings(ES_ENABLED=False)
class LibraryApiTest(APITestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self

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

        self.assertEqual(0, len(response.data))

    def test_get_library_pk(self):
        url = '/api/self/library/2/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertIn('listing', response.data)
        self.assertIn('id', response.data['listing'])
        self.assertIn('title', response.data['listing'])
        self.assertIn('unique_name', response.data['listing'])
        self.assertIn('folder', response.data)

    def test_update_library(self):
        user = generic_model_access.get_profile('wsmith').user
        self.client.force_authenticate(user=user)

        url = '/api/self/library/'
        response = self.client.get(url, format='json')

        put_data = []
        position_count = 0

        for i in response.data:
            position_count = position_count + 1

            data = {'id': i['id'],
                    'folder': 'test',
                    'listing': {'id': i['listing']['id']},
                    'position': position_count
                    }
            put_data.append(data)

        url = '/api/self/library/update_all/'
        response = self.client.put(url, put_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
