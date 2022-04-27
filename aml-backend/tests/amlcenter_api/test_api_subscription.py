"""
Tests for notification endpoints
"""
from django.test import override_settings
from rest_framework import status
from tests.aml.cases import APITestCase

from tests.amlcenter.helper import APITestHelper
from amlcenter.scripts import sample_data_generator as data_gen
from amlcenter import model_access as generic_model_access


@override_settings(ES_ENABLED=False)
class SubscriptionApiTest(APITestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.entity_types = ['tag', 'category']

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_get_all_subscriptions(self):
        url = '/api/subscription/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        self.assertEqual(len(response.data), 0)

    def test_get_self_subscriptions(self):
        url = '/api/self/subscription/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        self.assertEqual(len(response.data), 0)

    def test_search_subscriptions(self):
        for entity_type in self.entity_types:
            subscription_response = self._create_subscription(entity_type)
            search_term = subscription_response.data['entity_description']

            url = '/api/subscription/?type={}&name={}'.format(entity_type, search_term)
            response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)

            self.assertTrue(len(response.data) > 0)

            for entity_response in response.data:
                self.assertTrue(search_term in entity_response['entity_description'])

    def _create_subscription(self, entity_type, username=None):
        username = username or 'bigbrother'

        # Get Entity
        url = '/api/{}/1/'.format(entity_type)
        entity_response = APITestHelper.request(self, url, 'GET', username=username, status_code=200)

        # subscribe to entity (tag, category)
        url = '/api/subscription/'
        data = {
            'entity_type': entity_type,
            'entity_id': entity_response.data['id']
        }

        subscription_response = APITestHelper.request(self, url, 'POST', data=data, username=username, status_code=201)
        self.assertEqual(subscription_response.data['entity_type'], entity_type)
        self.assertEqual(subscription_response.data['entity_id'], entity_response.data['id'])

        if entity_type == 'tag':
            self.assertEqual(subscription_response.data['entity_description'], entity_response.data['name'])
        elif entity_type == 'category':
            self.assertEqual(subscription_response.data['entity_description'], entity_response.data['title'])

        return subscription_response

    def test_subscription_subscribe_unsubscribe(self):
        for entity_type in self.entity_types:
            subscription_response = self._create_subscription(entity_type)

            # unsubscribe
            url = '/api/self/subscription/{}/'.format(subscription_response.data['id'])
            APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=204)

            # Verify that subscription does not exist
            url = '/api/subscription/{}/'.format(subscription_response.data['id'])
            response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=404)
            # response.data = {'error_code': 'not_found', 'error': True, 'detail': 'Not found.'}

            url = '/api/self/subscription/{}/'.format(subscription_response.data['id'])
            response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=404)

    def test_subscription_subscribe_unsubscribe_non_steward(self):
        for entity_type in self.entity_types:
            subscription_response = self._create_subscription(entity_type, username='jones')

            url = '/api/subscription/{}/'.format(subscription_response.data['id'])
            APITestHelper.request(self, url, 'DELETE', username='jones', status_code=403)

    def test_get_deleted_tag_subscription(self):
        subscription_response = self._create_subscription('tag', username='bigbrother')
        url = '/api/tag/{}/'.format(subscription_response.data['entity_id'])
        APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=204)

        url = '/api/subscription/{}/'.format(subscription_response.data['id'])
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        # TODO: should status_code be 404?
        self.assertEqual(response.data['entity_description'], 'OBJECT NOT FOUND')

    def test_create_subscription_invalid_entity_type(self):
        url = '/api/subscription/'
        data = {
            'entity_type': 'none',
            'entity_id': 5
        }
        APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=400)
        # TODO Use ExceptionUnitTestHelper
    # TODO POST (Update) Tests
