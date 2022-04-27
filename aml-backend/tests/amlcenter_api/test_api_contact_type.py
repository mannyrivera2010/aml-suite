"""
Tests for ContactType endpoints
"""
from django.test import override_settings
from tests.aml.cases import APITestCase

from tests.amlcenter.helper import ExceptionUnitTestHelper
from tests.amlcenter.helper import APITestHelper
from amlcenter.scripts import sample_data_generator as data_gen


@override_settings(ES_ENABLED=False)
class ContactTypeApiTest(APITestCase):

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

    def test_get_contact_type_list(self):
        url = '/api/contact_type/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        names = ['{}.{}'.format(i['name'], i['required']) for i in response.data]
        names_expected = ['Civilian.False', 'Government.False', 'Military.False']

        self.assertEqual(names, names_expected)

    def test_get_contact_type(self):
        url = '/api/contact_type/1/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertEqual(response.data['name'], 'Civilian')

    def test_create_contact_type_apps_mall_steward(self):
        url = '/api/contact_type/'
        data = {'name': 'New Contact Type'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['name'], 'New Contact Type')

    def test_create_contact_type_org_steward(self):
        url = '/api/contact_type/'
        data = {'name': 'New Contact Type'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_create_contact_type(self): test different user groups access control

    def test_update_contact_type_apps_mall_steward(self):
        url = '/api/contact_type/1/'
        data = {'name': 'Updated Type', 'required': True}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='bigbrother', status_code=200)

        self.assertEqual(response.data['name'], 'Updated Type')
        self.assertEqual(response.data['required'], True)

    def test_update_contact_type_org_steward(self):
        url = '/api/contact_type/1/'
        data = {'name': 'Updated Type', 'required': True}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_update_contact_type(self): test different user groups access control

    def test_delete_contact_type_apps_mall_steward(self):
        url = '/api/contact_type/1/'
        APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=204)

    def test_delete_contact_type_org_steward(self):
        url = '/api/contact_type/1/'
        response = APITestHelper.request(self, url, 'DELETE', username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_delete_contact_type(self): test different user groups access control
