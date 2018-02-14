"""
Tests for category endpoints
"""
from django.test import override_settings
from rest_framework.test import APITestCase

from tests.ozpcenter.helper import APITestHelper
from tests.ozpcenter.helper import shorthand_dict
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
        self.expected_categories = ['Accessories.Accessories Description',
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
        self.assertListEqual(titles, self.expected_categories)

    def test_get_category(self):
        url = '/api/category/1/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        self.assertEqual(response.data['title'], 'Accessories')
        self.assertEqual(response.data['description'], 'Accessories Description')

    def test_get_category_not_found(self):
        url = '/api/category/1000/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=404)
        self.assertEqual(response.data, ExceptionUnitTestHelper.not_found())

    def test_create_category_apps_mall_steward(self):
        url = '/api/category/'
        data = {'title': 'new category', 'description': 'category description'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['title'], 'new category')
        self.assertEqual(response.data['description'], 'category description')

    def test_create_category_org_steward(self):
        url = '/api/category/'
        data = {'title': 'new category', 'description': 'category description'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_create_category(self): test different user groups access control

    def test_update_category_apps_mall_steward(self):
        url = '/api/category/1/'
        data = {'title': 'updated category', 'description': 'updated description'}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='bigbrother', status_code=200)

        self.assertEqual(response.data['title'], 'updated category')
        self.assertEqual(response.data['description'], 'updated description')

    def test_update_category_org_steward(self):
        url = '/api/category/1/'
        data = {'title': 'updated category', 'description': 'updated description'}
        response = APITestHelper.request(self, url, 'PUT', data=data, username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    # TODO def test_update_category(self): test different user groups access control

    def test_category_ordering(self):
        # Create new category
        url = '/api/category/'
        data = {'title': 'AAA new category', 'description': 'category description'}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['title'], 'AAA new category')
        self.assertEqual(response.data['description'], 'category description')

        # GET request
        url = '/api/category/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        titles = ['{}.{}'.format(i['title'], i['description']) for i in response.data]
        expected_results = ['AAA new category.category description'] + self.expected_categories

        self.assertListEqual(titles, expected_results)

    def test_delete_category_apps_mall_steward(self):
        url = '/api/category/1/'
        APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=204)

    def test_delete_category_org_steward(self):
        url = '/api/category/1/'
        response = APITestHelper.request(self, url, 'DELETE', username='wsmith', status_code=403)

        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

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

    def test_GET_bulk_category_listings_apps_mall_steward(self):
        expected_results = ['apocalypse',
                        'applied_ethics_inc.',
                        'beast',
                        'blink',
                        'cyclops',
                        'deadpool',
                        'diamond',
                        'harley-davidson_cvo',
                        'iron_man',
                        'jean_grey',
                        'magneto',
                        'rogue',
                        'ruby',
                        'sapphire',
                        'saturn',
                        'uranus',
                        'wolverine']

        # get list of listings containing category id {7}
        url = '/api/category/7/listing/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        listing_names = ['{}'.format(i['unique_name']) for i in response.data]

        self.assertIsNotNone(response.data)
        self.assertListEqual(listing_names, expected_results)

    def test_GET_bulk_category_listings_org_steward(self):
        expected_results = ['harley-davidson_cvo', 'ruby']

        # get list of listings containing category id {7} within the org_steward's agencies.
        url = '/api/category/7/listing/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        listing_names = ['{}'.format(i['unique_name']) for i in response.data]

        self.assertIsNotNone(response.data)
        self.assertListEqual(listing_names, expected_results)

    def test_GET_bulk_category_listings_owner(self):
        # The listing categories in these test case all have two or more category associations

        expected_results = ['apocalypse',
                        'beast',
                        'blink',
                        'cyclops',
                        'deadpool',
                        'iron_man',
                        'jean_grey',
                        'magneto',
                        'rogue',
                        'wolverine']

        # get list of listings containing category id {7} for this owner.
        url = '/api/category/7/listing/'
        response = APITestHelper.request(self, url, 'GET', username='syme', status_code=200)
        listing_names = ['{}'.format(i['unique_name']) for i in response.data]

        self.assertIsNotNone(response.data)
        self.assertListEqual(listing_names, expected_results)

    def _transform_categories(self, response_data):
        output = []
        for current_record in response_data:
            output_dict = {}
            output_dict['id'] = current_record['id']

            categories_output = []
            for current_category_dict in current_record['categories']:
                categories_output.append({'title': current_category_dict['title']})

            output_dict['categories'] = categories_output
            output.append(output_dict)

        return output

    def test_bulk_category_update_owner(self):
        # Update category listing by owner (test remove, add and validate)
        # POST url = '/api/category/{0!s}/listing/'.format(category_id)

        # Finance (id = 7)
        # Weather (id = 16)
        starting_list = [{"id": 6, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 16, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 19, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 41, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 42, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 77, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 81, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 100, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 135, "categories": [{"title": "Finance"}, {"title": "Weather"}]},
                         {"id": 187, "categories": [{"title": "Finance"}, {"title": "Weather"}]}
                        ]

        # test case: remove a category - Finance (id = 7)
        data_removed = [{"id": 6, "categories": [{"title": "Weather"}]},
                        {"id": 16, "categories": [{"title": "Weather"}]},
                        {"id": 19, "categories": [{"title": "Weather"}]},
                        {"id": 41, "categories": [{"title": "Weather"}]},
                        {"id": 42, "categories": [{"title": "Weather"}]},
                        {"id": 77, "categories": [{"title": "Weather"}]},
                        {"id": 81, "categories": [{"title": "Weather"}]},
                        {"id": 100, "categories": [{"title": "Weather"}]},
                        {"id": 135, "categories": [{"title": "Weather"}]},
                        {"id": 187, "categories": [{"title": "Weather"}]}
                        ]

        # test case: add a category - Accessories (id = 1)
        data_added = [{"id": 6, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 16, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 19, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 41, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 42, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 77, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 81, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 100, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 135, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                      {"id": 187, "categories": [{"title": "Accessories"}, {"title": "Weather"}]}
                      ]

        # test case validation - Attempt to add more than three(3) categories or  Zero categories
        data_validated = [{"id": 6, "categories": [{"title": "Accessories"}, {"title": "News", }, {"title": "Shopping", }, {"title": "Weather"}]},
                          {"id": 16, "categories": [{}]},
                          {"id": 19, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                          {"id": 41, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                          {"id": 42, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                          {"id": 77, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                          {"id": 81, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                          {"id": 100, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                          {"id": 135, "categories": [{"title": "Accessories"}, {"title": "Weather"}]},
                          {"id": 187, "categories": [{"title": "Accessories"}, {"title": "Finance"}]}
                        ]

        # retrieve starting category listings for this owner
        url = '/api/category/7/listing/'
        response = APITestHelper.request(self, url, 'GET', username='syme', status_code=200)

        actual_data = self._transform_categories(response.data)
        self.assertListEqual(shorthand_dict(actual_data), shorthand_dict(starting_list))
        # ------------------------------------------------
        #    Test case # 1: Remove categories
        # ------------------------------------------------
        url = '/api/category/7/listing/'
        response = APITestHelper.request(self, url, 'POST', data=data_removed, username='syme', status_code=201)

        actual_data = self._transform_categories(response.data)
        self.assertListEqual(shorthand_dict(actual_data), shorthand_dict(data_removed))

        # retrieve updated category listings for this owner under Finance (id = 7)
        url = '/api/category/7/listing/'
        response = APITestHelper.request(self, url, 'GET', username='syme', status_code=200)

        actual_data = self._transform_categories(response.data)
        self.assertListEqual(shorthand_dict(actual_data), [])

        # retrieve updated category listings for this owner under Weather (id = 16)
        url = '/api/category/16/listing/'
        response = APITestHelper.request(self, url, 'GET', username='syme', status_code=200)

        actual_data = self._transform_categories(response.data)
        self.assertListEqual(shorthand_dict(actual_data), shorthand_dict(data_removed))

        # ------------------------------------------------
        #    Test case # 2:  Add categories
        # ------------------------------------------------
        url = '/api/category/1/listing/'
        response = APITestHelper.request(self, url, 'POST', data=data_added, username='syme', status_code=201)

        # retrieve updated category listings for this owner
        response = APITestHelper.request(self, url, 'GET', username='syme', status_code=200)

        actual_data = self._transform_categories(response.data)
        self.assertListEqual(shorthand_dict(actual_data), shorthand_dict(data_added))

        # ------------------------------------------------
        #    Test case # 3: Validate categories
        # ------------------------------------------------
        url = '/api/category/1/listing/'
        response = APITestHelper.request(self, url, 'POST', data=data_validated, username='syme', status_code=400)

        self.assertEquals(response.data['error'], True)
        self.assertEquals(response.data['error_code'], 'validation_error')
        self.assertEquals(response.data['detail'], "[{'non_field_errors': ['Can not add more than 3 categories for one listing']}, {'categories': [{'title': ['This field is required.']}]}, {}, {}, {}, {}, {}, {}, {}, {}]")
