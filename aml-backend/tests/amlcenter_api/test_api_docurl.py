"""
Tests for listing endpoints
"""
from django.test import override_settings
from tests.aml.cases import APITestCase

from amlcenter.scripts import sample_data_generator as data_gen


@override_settings(ES_ENABLED=False)
class DocUrlApiTest(APITestCase):

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

    # TODO: Add more Unit Test (rivera 20160727)
