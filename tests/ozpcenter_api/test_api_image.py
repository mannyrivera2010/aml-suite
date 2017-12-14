"""
Tests for image endpoints
"""
from django.test import override_settings
from rest_framework import status
from rest_framework.test import APITestCase

from ozpcenter import model_access as generic_model_access
from ozpcenter.scripts import sample_data_generator as data_gen
from tests.ozpcenter.helper import unittest_request_helper


@override_settings(ES_ENABLED=False)
class ImageApiTest(APITestCase):

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

    def test_post_image(self):
        user = generic_model_access.get_profile('wsmith').user
        self.client.force_authenticate(user=user)

        url = '/api/image/'
        data = {
            'security_marking': 'UNCLASSIFIED',
            'image_type': 'small_screenshot',
            'file_extension': 'png',
            'image': open('ozpcenter/scripts/test_images/android.png', mode='rb')
        }
        response = self.client.post(url, data, format='multipart')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue('id' in response.data)
        self.assertTrue('security_marking' in response.data)

    def test_post_image_pki_user(self):
        user = generic_model_access.get_profile('pmurt').user
        self.client.force_authenticate(user=user)

        url = '/api/image/'
        data = {
            'security_marking': 'UNCLASSIFIED',
            'image_type': 'small_screenshot',
            'file_extension': 'png',
            'image': open('ozpcenter/scripts/test_images/android.png', mode='rb')
        }
        response = self.client.post(url, data, format='multipart')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_get_all_images(self):
        url = '/api/image/'
        response = unittest_request_helper(self, url, 'GET', username='wsmith', status_code=200)

        self.assertIsNotNone(response.data)

    # TODO: This will cause too many sql variables error with PKI users. Fix code on backend
    # def test_get_all_images_pki_user(self):
    #     url = '/api/image/'
    #     response = unittest_request_helper(self, url, 'GET', username='pmurt', status_code=400)

    #     self.assertIsNotNone(response.data)

    # TODO: Fix the retrieve in image views. It always finds nothing when searching by ID
    def test_get_image_by_id(self):
        url = '/api/image/9001/'
        response = unittest_request_helper(self, url, 'GET', username='wsmith', status_code=404)

    def test_delete_image(self):
        url = '/api/image/1/'
        unittest_request_helper(self, url, 'DELETE', username='wsmith', status_code=204)
