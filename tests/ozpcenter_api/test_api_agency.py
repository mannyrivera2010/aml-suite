"""
Tests for agency endpoints
"""
from django.test import override_settings
from rest_framework.test import APITestCase

from tests.ozpcenter.helper import unittest_request_helper
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


@override_settings(ES_ENABLED=False)
class AgencyApiTest(APITestCase):

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

    def test_get_agencies_list(self):
        url = '/api/agency/'
        response = unittest_request_helper(self, url, 'GET', username='wsmith', status_code=200)

        titles = ['{}.{}'.format(i['short_name'], i['title']) for i in response.data]

        expected_results = ['Miniluv.Ministry of Love',
                            'Minipax.Ministry of Peace',
                            'Miniplen.Ministry of Plenty',
                            'Minitrue.Ministry of Truth',
                            'Test.Test',
                            'Test 1.Test 1',
                            'Test2.Test 2',
                            'Test 3.Test 3',
                            'Test 4.Test 4']

        self.assertEqual(titles, expected_results)

    def test_get_agency(self):
        url = '/api/agency/1/'
        response = unittest_request_helper(self, url, 'GET', username='wsmith', status_code=200)

        title = response.data['title']
        short_name = response.data['short_name']
        self.assertEqual(title, 'Ministry of Truth')
        self.assertEqual(short_name, 'Minitrue')

    def test_create_agency_apps_mall_steward(self):
        url = '/api/agency/'
        data = {'title': 'new agency', 'short_name': 'orgname'}
        response = unittest_request_helper(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        title = response.data['title']
        short_name = response.data['short_name']
        self.assertEqual(title, 'new agency')
        self.assertEqual(short_name, 'orgname')

    def test_create_agency_org_steward(self):
        url = '/api/agency/'
        data = {'title': 'new agency', 'short_name': 'orgname'}
        response = unittest_request_helper(self, url, 'POST', data=data, username='wsmith', status_code=403)
        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_create_agency(self): test different user groups access control

    def test_update_agency_apps_mall_steward(self):
        url = '/api/agency/1/'
        data = {'title': 'updated agency', 'short_name': 'uporg'}
        response = unittest_request_helper(self, url, 'PUT', data=data, username='bigbrother', status_code=200)

        title = response.data['title']
        short_name = response.data['short_name']
        self.assertEqual(title, data['title'])
        self.assertEqual(short_name, data['short_name'])

    def test_update_agency_org_steward(self):
        url = '/api/agency/1/'
        data = {'title': 'updated agency', 'short_name': 'uporg'}
        response = unittest_request_helper(self, url, 'PUT', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_update_agency(self): test different user groups access control

    def test_delete_agency_apps_mall_steward(self):
        url = '/api/agency/1/'
        unittest_request_helper(self, url, 'DELETE', username='bigbrother', status_code=204)

    def test_delete_agency_org_steward(self):
        url = '/api/agency/1/'
        response = unittest_request_helper(self, url, 'DELETE', username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_delete_agency(self): test different user groups access control
