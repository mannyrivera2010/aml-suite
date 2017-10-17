"""
Tests for listing feedback
"""
from django.test import override_settings
from rest_framework import status
from rest_framework.test import APITestCase

from ozpcenter import model_access as generic_model_access
from ozpcenter import models
from ozpcenter.scripts import sample_data_generator as data_gen
import ozpcenter.api.listing.model_access as model_access
from tests.ozpcenter.helper import validate_listing_map_keys
from tests.ozpcenter.helper import unittest_request_helper


@override_settings(ES_ENABLED=False)
class ListingFeedbackApiTest(APITestCase):

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

    def test_create_listing_minimal(self):
        # create a new listing with minimal data (title)
        user = generic_model_access.get_profile('bettafish').user
        self.client.force_authenticate(user=user)
        url = '/api/listing/'
        title = 'bettafish app'
        data = {'title': title, 'security_marking': 'UNCLASSIFIED'}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['title'], title)
        self.assertEquals(validate_listing_map_keys(response.data), [])
        self.assertEquals(response.data['is_bookmarked'], False)

    def test_no_feedback_listing(self):
        user = generic_model_access.get_profile('bettafish').user
        self.client.force_authenticate(user=user)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], 0)

    def test_positive_feedback_listing(self):
        user = generic_model_access.get_profile('bettafish').user
        self.client.force_authenticate(user=user)

        # Create a positive feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": 1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], 1)

        # Check with a different beta group user to see if feedback exists for said user
        user = generic_model_access.get_profile('betaraybill').user
        self.client.force_authenticate(user=user)

        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], 0)

    def test_negative_feedback_listing(self):
        user = generic_model_access.get_profile('bettafish').user
        self.client.force_authenticate(user=user)

        # Create a negative feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": -1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], -1)

        # Check with a different beta group user to see if feedback exists for said user
        user = generic_model_access.get_profile('betaraybill').user
        self.client.force_authenticate(user=user)

        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], 0)

    def test_two_user_positive_feedback_listing(self):
        """
        test_two_user_positive_feedback_listing
        bettafish user
        """
        user = generic_model_access.get_profile('bettafish').user
        self.client.force_authenticate(user=user)

        # Create a negative feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": 1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], 1)

        """
        betaraybill user
        """
        user = generic_model_access.get_profile('betaraybill').user
        self.client.force_authenticate(user=user)

        # Create a negative feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": 1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], 1)

    def test_two_user_negative_feedback_listing(self):
        """
        test_two_user_negative_feedback_listing
        bettafish user
        """
        user = generic_model_access.get_profile('bettafish').user
        self.client.force_authenticate(user=user)

        # Create a negative feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": -1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], -1)

        """
        betaraybill user
        """
        user = generic_model_access.get_profile('betaraybill').user
        self.client.force_authenticate(user=user)

        # Create a negative feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": -1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], -1)

    def test_two_user_diff_feedback_listing(self):
        """
        test_two_user_diff_feedback_listing
        bettafish user
        """
        user = generic_model_access.get_profile('bettafish').user
        self.client.force_authenticate(user=user)

        # Create a negative feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": 1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], 1)

        """
        betaraybill user
        """
        user = generic_model_access.get_profile('betaraybill').user
        self.client.force_authenticate(user=user)

        # Create a negative feedback
        url = '/api/listing/1/feedback/'
        data = {"feedback": -1}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        url = '/api/listing/1/feedback/'
        response = self.client.get(url, format='json')
        self.assertEqual(response.data['feedback'], -1)
