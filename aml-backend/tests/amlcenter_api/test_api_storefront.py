"""
Tests for storefront endpoints
TODO: should we test keys of each item in the list of listings for storefront
"""

from django.test import override_settings
from tests.aml.cases import APITestCase

from amlcenter import model_access as generic_model_access
from amlcenter.scripts import sample_data_generator as data_gen
from tests.amlcenter.helper import APITestHelper


@override_settings(ES_ENABLED=False)
class StorefrontApiTest(APITestCase):

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

    def test_metadata_authorized(self):
        url = '/api/metadata/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        self.assertIn('agencies', response.data)
        self.assertIn('categories', response.data)
        self.assertIn('contact_types', response.data)
        self.assertIn('listing_types', response.data)
        self.assertIn('intents', response.data)
        self.assertIn('work_roles', response.data)

        for i in response.data['agencies']:
            self.assertTrue('listing_count' in i)

    def test_metadata_unauthorized(self):
        url = '/api/metadata/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, 401)

    def test_storefront_authorized(self):
        url = '/api/storefront/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertIn('featured', response.data)
        self.assertTrue(len(response.data['featured']) >= 1)
        self._check_listing_properties(response.data['featured'])
        self.assertIn('recent', response.data)
        self.assertTrue(len(response.data['recent']) >= 1)
        self._check_listing_properties(response.data['recent'])
        self.assertIn('most_popular', response.data)
        self.assertTrue(len(response.data['most_popular']) >= 1)
        self._check_listing_properties(response.data['most_popular'])
        self.assertIn('recommended', response.data)
        self.assertTrue(len(response.data['recommended']) >= 1)
        self._check_listing_properties(response.data['recommended'], ['_score'])

    def test_storefront_authorized_recommended(self):
        url = '/api/storefront/recommended/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        self.assertIn('featured', response.data)
        self.assertEqual(response.data['featured'], [])
        self.assertIn('recent', response.data)
        self.assertEqual(response.data['recent'], [])
        self.assertIn('most_popular', response.data)
        self.assertEqual(response.data['most_popular'], [])
        self.assertIn('recommended', response.data)
        self.assertTrue(len(response.data['recommended']) >= 1)
        self._check_listing_properties(response.data['recommended'], ['_score'])

    def test_storefront_authorized_featured(self):
        url = '/api/storefront/featured/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        self.assertIn('featured', response.data)
        self.assertTrue(len(response.data['featured']) >= 1)
        self._check_listing_properties(response.data['featured'])
        self.assertIn('recent', response.data)
        self.assertEqual(response.data['recent'], [])
        self.assertIn('most_popular', response.data)
        self.assertEqual(response.data['most_popular'], [])
        self.assertIn('recommended', response.data)
        self.assertEqual(response.data['recommended'], [])

    def test_storefront_authorized_most_popular(self):
        url = '/api/storefront/most_popular/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        self.assertIn('featured', response.data)
        self.assertEqual(response.data['featured'], [])
        self.assertIn('recent', response.data)
        self.assertEqual(response.data['recent'], [])
        self.assertIn('most_popular', response.data)
        self.assertTrue(len(response.data['most_popular']) >= 1)
        self._check_listing_properties(response.data['most_popular'])
        self.assertIn('recommended', response.data)
        self.assertEqual(response.data['recommended'], [])

    def test_storefront_authorized_recent(self):
        url = '/api/storefront/recent/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        self.assertIn('featured', response.data)
        self.assertEqual(response.data['featured'], [])
        self.assertIn('recent', response.data)
        self.assertTrue(len(response.data['recent']) >= 1)
        self._check_listing_properties(response.data['recent'])
        self.assertIn('most_popular', response.data)
        self.assertEqual(response.data['most_popular'], [])
        self.assertIn('recommended', response.data)
        self.assertEqual(response.data['recommended'], [])

    def test_storefront_authorized_with_ordering(self):
        # Recommended
        url = '/api/storefront/recommended/?ordering=title'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        data = response.data['recommended']
        sorted_data = sorted(data, key=lambda x: x['title'])
        self.assertEqual(data, sorted_data)

        # Featured
        url = '/api/storefront/featured/?ordering=-title'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        data = response.data['featured']
        sorted_data = sorted(data, key=lambda x: x['title'], reverse=True)
        self.assertEqual(data, sorted_data)

        # Most Popular
        url = '/api/storefront/most_popular/?ordering=-edited_date'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        data = response.data['most_popular']
        sorted_data = sorted(data, key=lambda x: x['edited_date'], reverse=True)
        self.assertEqual(data, sorted_data)

        # Recent
        url = '/api/storefront/recent/?ordering=-approved_date'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        data = response.data['recent']
        sorted_data = sorted(data, key=lambda x: x['approved_date'], reverse=True)
        self.assertEqual(data, sorted_data)

    def test_storefront_unauthorized(self):
        url = '/api/storefront/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, 401)

    def _check_listing_properties(self, listings, additional_keys=None):
        additional_keys = [] if additional_keys is None else additional_keys
        desired_keys = ['id', 'title', 'agency', 'avg_rate', 'total_votes',
            'total_reviews', 'feedback_score', 'is_private', 'is_bookmarked',
            'feedback', 'description_short', 'security_marking',
            'usage_requirements', 'system_requirements', 'launch_url', 'listing_type',
            'large_banner_icon', 'banner_icon', 'unique_name', 'is_enabled', 'owners',
            'edited_date', 'approved_date']
        desired_keys += additional_keys
        desired_keys = sorted(desired_keys)

        for listing in listings:
            actual_keys = sorted(listing.keys())

            self.assertEqual(desired_keys, actual_keys)
