"""
Tests for notification endpoints
"""
from django.test import override_settings
from rest_framework import status
from rest_framework.test import APITestCase

from ozpcenter.scripts import sample_data_generator as data_gen
from ozpcenter import model_access as generic_model_access


@override_settings(ES_ENABLED=False)
class SubscriptionApiTest(APITestCase):

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
        pass
        data_gen.run()

    def test_get_all_subscriptions(self):
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/subscription/'
        response = self.client.get(url, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_get_self_subscriptions(self):
        user = generic_model_access.get_profile('wsmith').user
        self.client.force_authenticate(user=user)

        url = '/api/self/subscription/'
        response = self.client.get(url, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_category_subscription(self):
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/category/1/'
        category_response = self.client.get(url, format='json')

        self.assertEqual(category_response.status_code, status.HTTP_200_OK)

        url = '/api/subscription/'
        data = {
            'entity_type': 'category',
            'entity_id': category_response.data['id']
        }
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['entity_type'], 'category')
        self.assertEqual(response.data['entity_id'], category_response.data['id'])
        self.assertEqual(response.data['entity_description'], category_response.data['title'])

    def test_create_category_subscription_invalid_entity_type(self):
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/category/1/'
        category_response = self.client.get(url, format='json')

        self.assertEqual(category_response.status_code, status.HTTP_200_OK)

        url = '/api/subscription/'
        data = {
            'entity_type': 'none',
            'entity_id': category_response.data['id']
        }
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_unsubscribe_category_subscription(self):
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/category/1/'
        category_response = self.client.get(url, format='json')

        self.assertEqual(category_response.status_code, status.HTTP_200_OK)

        url = '/api/subscription/'
        data = {
            'entity_type': 'category',
            'entity_id': category_response.data['id']
        }
        subscription_response = self.client.post(url, data, format='json')

        self.assertEqual(subscription_response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(subscription_response.data['entity_type'], 'category')
        self.assertEqual(subscription_response.data['entity_id'], category_response.data['id'])
        self.assertEqual(subscription_response.data['entity_description'], category_response.data['title'])

        url = '/api/self/subscription/{}/'.format(subscription_response.data['id'])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_self_unsubscribe_category_subscription(self):
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/category/1/'
        category_response = self.client.get(url, format='json')

        self.assertEqual(category_response.status_code, status.HTTP_200_OK)

        url = '/api/subscription/'
        data = {
            'entity_type': 'category',
            'entity_id': category_response.data['id']
        }
        subscription_response = self.client.post(url, data, format='json')

        self.assertEqual(subscription_response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(subscription_response.data['entity_type'], 'category')
        self.assertEqual(subscription_response.data['entity_id'], category_response.data['id'])
        self.assertEqual(subscription_response.data['entity_description'], category_response.data['title'])

        url = '/api/self/subscription/{}/'.format(subscription_response.data['id'])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_unsubscribe_category_subscription_non_steward(self):
        user = generic_model_access.get_profile('jones').user
        self.client.force_authenticate(user=user)

        url = '/api/category/1/'
        category_response = self.client.get(url, format='json')

        self.assertEqual(category_response.status_code, status.HTTP_200_OK)

        url = '/api/subscription/'
        data = {
            'entity_type': 'category',
            'entity_id': category_response.data['id']
        }
        subscription_response = self.client.post(url, data, format='json')

        self.assertEqual(subscription_response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(subscription_response.data['entity_type'], 'category')
        self.assertEqual(subscription_response.data['entity_id'], category_response.data['id'])
        self.assertEqual(subscription_response.data['entity_description'], category_response.data['title'])

        url = '/api/subscription/1/'
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_create_tag_subscription(self):
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/tag/1/'
        tag_response = self.client.get(url, format='json')

        self.assertEqual(tag_response.status_code, status.HTTP_200_OK)

        url = '/api/subscription/'
        data = {
            'entity_type': 'tag',
            'entity_id': tag_response.data['id']
        }
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['entity_type'], 'tag')
        self.assertEqual(response.data['entity_id'], tag_response.data['id'])
        self.assertEqual(response.data['entity_description'], tag_response.data['name'])

    def test_get_deleted_tag_subscription(self):
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/tag/1/'
        tag_response = self.client.get(url, format='json')

        self.assertEqual(tag_response.status_code, status.HTTP_200_OK)

        url = '/api/subscription/'
        data = {
            'entity_type': 'tag',
            'entity_id': tag_response.data['id']
        }
        subscription_response = self.client.post(url, data, format='json')

        self.assertEqual(subscription_response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(subscription_response.data['entity_type'], 'tag')
        self.assertEqual(subscription_response.data['entity_id'], tag_response.data['id'])
        self.assertEqual(subscription_response.data['entity_description'], tag_response.data['name'])

        url = '/api/tag/' + str(tag_response.data['id']) + '/'
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

        url = '/api/subscription/' + str(subscription_response.data['id']) + '/'
        response = self.client.get(url)

        self.assertEqual(response.data['entity_description'], 'OBJECT NOT FOUND')
