"""
Tests for listing endpoints
"""
from django.test import override_settings
from tests.aml.cases import APITestCase
from tests.amlcenter.helper import APITestHelper

from amlcenter.scripts import sample_data_generator as data_gen


@override_settings(ES_ENABLED=False)
class TagApiTest(APITestCase):

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

    def test_get_all_tags(self):
        url = '/api/tag/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        self.assertTrue(len(response.data) > 0)

    def test_get_all_tags_with_search(self):
        search_term = 'one'
        url = '/api/tag/?search={}'.format(search_term)
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)

        for tag_response in response.data:
            self.assertTrue(search_term in tag_response['name'])

    # TODO: Add more Unit Test (rivera 20160727)
