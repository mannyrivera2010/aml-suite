"""
Tests for WorkRole endpoints
"""
from django.test import override_settings
from tests.ozp.cases import APITestCase

from tests.ozpcenter.helper import ExceptionUnitTestHelper
from tests.ozpcenter.helper import APITestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


@override_settings(ES_ENABLED=False)
class WorkRoleApiTest(APITestCase):

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

    def test_get_work_role_list(self):
        url = '/api/work_role/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        names = sorted([i['name'] for i in response.data])
        names_expected = ['CEO', 'Contractor', 'Developer', 'Manager']

        self.assertEqual(names, names_expected)

    def test_get_work_role(self):
        id = 1
        url = '/api/work_role/{}/'.format(id)
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertEqual(response.data['id'], id)

    def test_create_work_role_apps_mall_steward(self):
        new_name = 'New Work Role'
        url = '/api/work_role/'
        data = {'name': new_name}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['name'], new_name)

    def test_create_work_role_org_steward(self):
        new_name = 'New Work Role'
        url = '/api/work_role/'
        data = {'name': new_name}
        response = APITestHelper.request(self, url, 'POST', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    def test_update_work_role_apps_mall_steward(self):
        id = 1
        new_name = 'Updated Work Role'
        url = '/api/work_role/{}/'.format(id)
        data = {'name': new_name}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='bigbrother', status_code=200)

        self.assertEqual(response.data['id'], id)
        self.assertEqual(response.data['name'], new_name)

    def test_update_work_role_org_steward(self):
        id = 1
        new_name = 'Updated Work Role'
        url = '/api/work_role/{}/'.format(id)
        data = {'name': new_name}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    def test_delete_work_role_apps_mall_steward(self):
        id = 1
        url = '/api/work_role/{}/'.format(id)
        APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=204)

    def test_delete_work_role_org_steward(self):
        id = 1
        url = '/api/work_role/{}/'.format(id)
        response = APITestHelper.request(self, url, 'DELETE', username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())
