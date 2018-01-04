"""
Tests for category endpoints
"""
from django.test import override_settings
from rest_framework.test import APITestCase

from tests.ozpcenter.helper import APITestHelper
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen
from ozpcenter import models
import ozpcenter.api.listing.model_access as listing_model_access
import ozpcenter.model_access as generic_model_access


@override_settings(ES_ENABLED=False)
class CategoryApiTest(APITestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_get_categories_list(self):
        url = '/api/category/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        titles = ['{}.{}'.format(i['title'], i['description']) for i in response.data]
        expected_results = ['Accessories.Accessories Description',
                            'Books and Reference.Things made of paper',
                            'Business.For making money',
                            'Communication.Moving info between people and things',
                            'Education.Educational in nature',
                            'Entertainment.For fun',
                            'Finance.For managing money',
                            'Health and Fitness.Be healthy, be fit',
                            'Media and Video.Videos and media stuff',
                            'Music and Audio.Using your ears',
                            "News.What's happening where",
                            'Productivity.Do more in less time',
                            'Shopping.For spending your money',
                            'Sports.Score more points than your opponent',
                            'Tools.Tools and Utilities',
                            'Weather.Get the temperature']
        self.assertListEqual(titles, expected_results)

    def test_get_category(self):
        url = '/api/category/1/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        title = response.data['title']
        description = response.data['description']
        self.assertEqual(title, 'Accessories')
        self.assertEqual(description, 'Accessories Description')

    def test_create_category_apps_mall_steward(self):
        url = '/api/category/'
        data = {'title': 'new category', 'description': 'category description'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        title = response.data['title']
        description = response.data['description']
        self.assertEqual(title, 'new category')
        self.assertEqual(description, 'category description')

    def test_create_category_org_steward(self):
        url = '/api/category/'
        data = {'title': 'new category', 'description': 'category description'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data['error_code'], (ExceptionUnitTestHelper.permission_denied())['error_code'])

    # TODO def test_create_category(self): test different user groups access control

    def test_update_category_apps_mall_steward(self):
        url = '/api/category/1/'
        data = {'title': 'updated category', 'description': 'updated description'}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='bigbrother', status_code=200)

        title = response.data['title']
        description = response.data['description']
        self.assertEqual(title, 'updated category')
        self.assertEqual(description, 'updated description')

    def test_update_category_org_steward(self):
        url = '/api/category/1/'
        data = {'title': 'updated category', 'description': 'updated description'}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data['error_code'], (ExceptionUnitTestHelper.permission_denied())['error_code'])

    # TODO def test_update_category(self): test different user groups access control

    def test_category_ordering(self):
        url = '/api/category/'
        data = {'title': 'AAA new category', 'description': 'category description'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        title = response.data['title']
        description = response.data['description']
        self.assertEqual(title, 'AAA new category')
        self.assertEqual(description, 'category description')

        # GET request
        url = '/api/category/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        titles = ['{}.{}'.format(i['title'], i['description']) for i in response.data]
        expected_results = ['AAA new category.category description',
                            'Accessories.Accessories Description',
                            'Books and Reference.Things made of paper',
                            'Business.For making money',
                            'Communication.Moving info between people and things',
                            'Education.Educational in nature',
                            'Entertainment.For fun',
                            'Finance.For managing money',
                            'Health and Fitness.Be healthy, be fit',
                            'Media and Video.Videos and media stuff',
                            'Music and Audio.Using your ears',
                            "News.What's happening where",
                            'Productivity.Do more in less time',
                            'Shopping.For spending your money',
                            'Sports.Score more points than your opponent',
                            'Tools.Tools and Utilities',
                            'Weather.Get the temperature']
        self.assertListEqual(titles, expected_results)

    def test_delete_category_apps_mall_steward(self):
        url = '/api/category/1/'
        APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=204)

    def test_delete_category_org_steward(self):
        url = '/api/category/1/'
        response = APITestHelper.request(self, url, 'DELETE', username='wsmith', status_code=403)

        self.assertEqual(response.data['error_code'], (ExceptionUnitTestHelper.permission_denied())['error_code'])

    def test_delete_category_with_existing_listings(self):
        author = generic_model_access.get_profile('wsmith')
        air_mail = models.Listing.objects.for_user(author.user.username).get(title='Air Mail')
        listing_model_access.create_listing(author, air_mail)

        air_mail = models.Listing.objects.for_user(author.user.username).get(title='Air Mail')
        self.assertEqual(air_mail.last_activity.action, models.ListingActivity.CREATED)
        self.assertEqual(air_mail.approval_status, models.Listing.IN_PROGRESS)

        # Air Mail Categories: Communication(4) & Productivity(12)
        url = '/api/category/4/'
        response = APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=403)

    # TODO def test_delete_category(self): test different user groups access control
