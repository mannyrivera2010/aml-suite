"""
Tests for listingvisit endpoints
"""
from django.test import override_settings
from rest_framework import status
from tests.ozp.cases import APITestCase

from tests.ozpcenter.helper import APITestHelper
from ozpcenter import model_access as generic_model_access
from ozpcenter.scripts import sample_data_generator as data_gen
from tests.ozpcenter.helper import validate_listing_map_keys


@override_settings(ES_ENABLED=False)
class ProfileListingVisitApiTest(APITestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        pass

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_frequently_visited_listings(self):
        url = '/api/profile/self/listingvisits/frequent/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        freq_visit_ids = [i['id'] for i in response.data]

        # API call sorts data by count DESC, title ASC, just like /frequent
        url = '/api/profile/self/listingvisits/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        visit_ids = [i['listing']['id'] for i in response.data if i['count'] > 0]

        self.assertEqual(freq_visit_ids, visit_ids)

    def test_increment_visit(self):
        # assumes bigbrother has at least one listing visit
        url = '/api/profile/self/listingvisits/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        visit = response.data[0]

        url = '/api/profile/self/listingvisits/increment/'
        data = {'listing': {'id': visit['listing']['id']}}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=200)
        new_visit = response.data

        self.assertEqual(visit['count'] + 1, new_visit['count'])

    def test_clear_visit(self):
        # assumes bigbrother has at least one listing visit
        url = '/api/profile/self/listingvisits/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        visit = response.data[0]

        self.assertTrue(visit['count'] > 0)

        url = '/api/profile/self/listingvisits/clear/'
        data = {'listing': {'id': visit['listing']['id']}}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=200)

        # get the visit count after making the clear API call
        url = '/api/profile/self/listingvisits/{0}/'.format(visit['id'])
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        new_visit = response.data

        self.assertTrue(new_visit['count'] == 0)
