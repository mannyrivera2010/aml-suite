"""
Tests for notification endpoints
"""
from django.test import override_settings
# from rest_framework import status
from rest_framework.test import APITestCase

from ozpcenter.scripts import sample_data_generator as data_gen


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
        # data_gen.run()
