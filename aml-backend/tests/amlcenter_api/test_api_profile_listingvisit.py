"""
Tests for listingvisit endpoints
"""
from django.test import override_settings
from rest_framework import status
from tests.aml.cases import APITestCase

from tests.amlcenter.helper import APITestHelper
from amlcenter import model_access as generic_model_access
from amlcenter.scripts import sample_data_generator as data_gen


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

        url = '/api/profile/self/listingvisits/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        visit_counts = dict((i['listing']['id'], i['count']) for i in response.data)

        curr_count = None
        for id in freq_visit_ids:
            if curr_count is not None:
                self.assertTrue(visit_counts[id] <= curr_count)
            curr_count = visit_counts[id]

    def test_frequently_visited_listings_with_ordering(self):
        url = '/api/profile/self/listingvisits/frequent/?ordering=-title'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        data = response.data

        url = '/api/profile/self/listingvisits/frequent/?ordering=title'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        reverse_data = response.data

        self.assertEqual(data, reverse_data[::-1])

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

        self.assertTrue(visit['count'] >= 0)

        url = '/api/profile/self/listingvisits/clear/'
        data = {'listing': {'id': visit['listing']['id']}}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=200)

        # get the visit count after making the clear API call
        url = '/api/profile/self/listingvisits/{0}/'.format(visit['id'])
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        new_visit = response.data

        self.assertTrue(new_visit['count'] == 0)

    def test_clear_all_visits(self):
        # assumes bigbrother has at least one listing visit
        url = '/api/profile/self/listingvisits/frequent/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        visit = response.data[0]

        self.assertTrue(len(response.data) > 0)

        url = '/api/profile/self/listingvisits/clear/'
        data = {}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=200)

        # get the freq visited listings after making the clear all API call
        url = '/api/profile/self/listingvisits/frequent/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)

        self.assertTrue(len(response.data) == 0)
