"""
Tests for Profile endpoints
"""
from unittest.mock import patch

from django.test import override_settings
from django.conf import settings
from rest_framework import status
from tests.aml.cases import APITestCase

from amlcenter import errors
from tests.aml import helper
from amlcenter import model_access as generic_model_access
from amlcenter.scripts import sample_data_generator as data_gen
from tests.amlcenter.helper import APITestHelper
from tests.amlcenter.helper import ExceptionUnitTestHelper


@override_settings(ES_ENABLED=False)
class ProfileApiTest(APITestCase):
    """
    Testing Profile API

    Users:
      aaronson (miniluv) - Aaronson - 6
      jones (minitrue) - Jones - 7
      rutherford (miniplenty) - Rutherford - 8
      syme (minipax) - Syme - 9
      tparsons (minipax, miniluv) - Tom Parsons - 10
      charrington (minipax, miniluv, minitrue) - Charrington - 11
    Org Stewards:
      wsmith (minitrue, stewarded_orgs: minitrue) - Winston Smith - 1
      julia (minitrue, stewarded_orgs: minitrue, miniluv) - Julia Dixon - 2
      obrien (minipax, stewarded_orgs: minipax, miniplenty) - O'brien - 3
    Admins:
      bigbrother (minipax) - Big Brother - 4
      bigbrother2 (minitrue) - Big Brother2 - 5
    """

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        # Store the orginal value of USE_AUTH_SERVER
        self.USE_AUTH_SERVER_ORGINAL = settings.AML['USE_AUTH_SERVER']

    def tearDown(self):
        """
        tearDown is invoked after each test method
        """
        # Set the value of USE_AUTH_SERVER to the orginal value
        settings.AML['USE_AUTH_SERVER'] = self.USE_AUTH_SERVER_ORGINAL

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def _get_profile_url_for_username(self, username, postfix=None):
        """
        Get Profile Url
        """
        postfix = postfix or ''
        user_id = generic_model_access.get_profile(username).user.id
        return '/api/profile/{}/{}'.format(user_id, postfix)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_all_listing_for_self_profile_auth_enabled(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        self._all_listing_for_self_profile()

    def test_all_listing_for_self_profile_auth_disabled(self):
        settings.AML['USE_AUTH_SERVER'] = False
        self._all_listing_for_self_profile()

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_all_listing_for_self_profile_auth_enabled_with_ordering(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        self._all_listing_for_self_profile(True)

    def _all_listing_for_self_profile(self, with_ordering=False):
        # Tests rely on sorting by title (asc) so an easy check for ordering is
        # sort by title (desc).  Eventually, this test should be more robust.
        url = '/api/profile/self/listing/' + ('?ordering=-title' if with_ordering else '')  # 2/7/18/26/27
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        titles = sorted([i['title'] for i in response.data], reverse=with_ordering)
        expected_listing = ['Air Mail', 'Applied Ethics Inc.', 'Bleach', 'Business Insurance Risk',
            'Business Management System', 'Chart Course', 'Clipboard', 'Desktop Virtualization',
            'Diamond', 'FrameIt', 'Hatch Latch', 'Intelligence Unleashed', 'JotSpot',
            'LocationAnalyzer', 'LocationLister', 'LocationViewer', 'Project Management',
            'Ruby', 'Ruby Miner', 'Sapphire', 'Wikipedia']
        self.assertEqual(expected_listing[::-1] if with_ordering else expected_listing, titles)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_one_listing_for_self_profile_auth_enabled(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        self._one_listing_for_self_profile()

    def test_one_listing_for_self_profile_auth_disabled(self):
        settings.AML['USE_AUTH_SERVER'] = False
        self._one_listing_for_self_profile()

    def _one_listing_for_self_profile(self):
        url = '/api/profile/self/listing/2/'  # 2/7/18/26/27
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        data = response.data
        self.assertEqual(data['id'], 2)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_all_listing_for_minitrue_profile_from_multi_org_profile_auth_enabled(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        self._all_listing_for_minitrue_profile_from_multi_org_profile()

    def test_all_listing_for_minitrue_profile_from_multi_org_profile_auth_disabled(self):
        settings.AML['USE_AUTH_SERVER'] = False
        self._all_listing_for_minitrue_profile_from_multi_org_profile()

    def _all_listing_for_minitrue_profile_from_multi_org_profile(self):
        """
        test_all_listing_for_minitrue_profile_from_multi_org_profile_auth_disabled

        Getting
            wsmith (minitrue, stewarded_orgs: minitrue) - Winston Smith - 4
        From
            charrington (minipax, miniluv, minitrue) - Charrington - 17
        """
        url = self._get_profile_url_for_username('wsmith', 'listing/')
        response = APITestHelper.request(self, url, 'GET', username='charrington', status_code=200)

        titles = sorted([i['title'] for i in response.data])
        expected_listing = ['Air Mail', 'Applied Ethics Inc.', 'Bleach', 'Business Insurance Risk',
            'Business Management System', 'Chart Course', 'Clipboard', 'Desktop Virtualization',
            'Diamond', 'FrameIt', 'Hatch Latch', 'Intelligence Unleashed', 'JotSpot',
            'LocationAnalyzer', 'LocationLister', 'LocationViewer', 'Project Management',
            'Ruby', 'Ruby Miner', 'Sapphire', 'Wikipedia']
        self.assertEqual(expected_listing, titles)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_all_listing_for_app_profile_from_multi_org_profile_auth_enabled(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        self._all_listing_for_app_profile_from_multi_org_profile()

    def test_all_listing_for_app_profile_from_multi_org_profile_auth_disabled(self):
        settings.AML['USE_AUTH_SERVER'] = False
        self._all_listing_for_app_profile_from_multi_org_profile()

    def _all_listing_for_app_profile_from_multi_org_profile(self):
        """
        Testing GET /api/profile/4/listing/ endpoint

        Getting
            wsmith (minitrue, stewarded_orgs: minitrue) - Winston Smith - 4
        From
            bigbrother (minipax) - Big Brother - 1
        """
        url = self._get_profile_url_for_username('wsmith', 'listing/')
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)

        titles = sorted([i['title'] for i in response.data])
        expected_listing = ['Air Mail', 'Applied Ethics Inc.', 'Bleach', 'Business Insurance Risk',
            'Business Management System', 'Chart Course', 'Clipboard', 'Desktop Virtualization',
            'Diamond', 'FrameIt', 'Hatch Latch', 'Intelligence Unleashed', 'JotSpot',
            'LocationAnalyzer', 'LocationLister', 'LocationViewer', 'Project Management',
            'Ruby', 'Ruby Miner', 'Sapphire', 'Wikipedia']
        self.assertEqual(expected_listing, titles)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_all_listing_for_minitrue_profile_from_minitrue_profile(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        self._all_listing_for_minitrue_profile_from_minitrue_profile()

    def _all_listing_for_minitrue_profile_from_minitrue_profile(self):
        """
        test_all_listing_for_minitrue_profile_from_minitrue_profile

        Getting
            julia (minitrue, stewarded_orgs: minitrue, miniluv) - Julia Dixon - 5
        From
            jones (minitrue) - Jones - 9
        """
        url = self._get_profile_url_for_username('julia', 'listing/')
        response = APITestHelper.request(self, url, 'GET', username='jones', status_code=200)

        titles = sorted([i['title'] for i in response.data])
        expected_listing = ['Bread Basket', 'Chatter Box']
        # BreadBasket(Minitrue, private, julia)
        # ChatterBox(Miniluv, public, julia)
        self.assertEqual(expected_listing, titles)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_username_starts_with(self, mock_request):
        """
        Testing GET /api/profile/?username_starts_with={username} endpoint
        """
        settings.AML['USE_AUTH_SERVER'] = True

        url = '/api/profile/?username_starts_with=ws'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        usernames = sorted([i['user']['username'] for i in response.data])
        expected_usernames = ['wsmith']
        self.assertEqual(usernames, expected_usernames)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_username_starts_with_no_results(self, mock_request):
        """
        Testing GET /api/profile/?username_starts_with={username} endpoint
        """
        settings.AML['USE_AUTH_SERVER'] = True

        url = '/api/profile/?username_starts_with=asdf'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        usernames = sorted([i['user']['username'] for i in response.data])
        expected_usernames = []
        self.assertEqual(usernames, expected_usernames)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_get_users_based_on_roles_for_all_access_control_levels(self, mock_request):
        """
        Testing GET /api/profile/?roles={role} endpoint
        """
        settings.AML['USE_AUTH_SERVER'] = True
        roles_combos = {'APPS_MALL_STEWARD': [1, 0, 0],
                        'ORG_STEWARD': [0, 1, 0],
                        'USER': [0, 0, 1]}
        user_list = ['bigbrother',
                     'wsmith',
                     'jones']

        for role in roles_combos:
            combo = roles_combos[role]
            for current_username in user_list:
                # Get all '{role}' profiles at '{current_username}' access control level
                user = generic_model_access.get_profile(current_username).user
                self.client.force_authenticate(user=user)
                url = '/api/profile/?role={0!s}'.format(role)
                response = self.client.get(url, format='json')
                self.assertEqual(response.status_code, status.HTTP_200_OK)
                usernames = [i['user']['username'] for i in response.data]

                self.assertEqual('bigbrother' in usernames, bool(combo[0]), 'bigbrother role [{0!s}] in {1!s}'.format(role, bool(combo[0])))
                self.assertEqual('julia' in usernames, bool(combo[1]))
                self.assertEqual('jones' in usernames, bool(combo[2]))
                # Reference
                # displaynames = [i['display_name'] for i in response.data]
                # self.assertEqual(displaynames, sorted(displaynames))

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_work_roles(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True

        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/self/profile/'
        data = {
            "work_roles": [{"id": 1}, {"id": 2}]
        }
        response = self.client.put(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        expected_ids = sorted([x['id'] for x in data['work_roles']])
        actual_ids = sorted([x['id'] for x in response.data.get('work_roles')])

        self.assertEqual(expected_ids, actual_ids)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_storefront_customizations(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True

        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)

        url = '/api/self/profile/'
        data = {
            "storefront_customizations": [
                {"section": "FEATURED", "is_hidden": True},
                {"section": "RECOMMENDED", "position": 1},
                {"section": "RECENTLY_ADDED", "position": 2, "is_hidden": False},
                {"section": "MOST_POPULAR", "position": 3, "is_hidden": True},
                {"section": "FREQUENTLY_VISITED"},
                {"section": "UPDATES", "is_hidden": False},
                {"section": "MY_LISTINGS", "position": 4, "is_hidden": False},
            ]
        }
        response = self.client.put(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        expected_results = []
        for item in data['storefront_customizations']:
            expected_item = {
                "section": item['section'],
                "position": item['position'] if 'position' in item else 0,
                "is_hidden": item['is_hidden'] if 'is_hidden' in item else False,
                "size": item['size'] if 'size' in item else None,
            }
            expected_results.append(expected_item)
        results = sorted(response.data.get('storefront_customizations'), key=lambda x: x['section'])
        expected_results = sorted(expected_results, key=lambda x: x['section'])

        self.assertEqual(results, expected_results)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_get_update_self_for_all_access_control_levels(self, mock_request):
        """
        test_get_update_self_for_all_access_control_levels
        """
        settings.AML['USE_AUTH_SERVER'] = True
        # aaronson - 7
        # abe - 4
        # bigbrother - 1
        # bigbrother2 - 2
        # charrington - 17
        # khaleesi- 3
        # hodor - 8
        # johnson - 18
        # jsnow - 16
        # jones - 9
        # julia - 5
        # noah -12
        # obrien - 6
        # rutherford - 11
        # syme - 13
        # tammy - 10
        # tparsons - 15
        # wsmith - 4

        user_combo_list = [
            # bigbrother (minipax)
            {'username': 'bigbrother', 'display_name': 'Big Brother',
                'stewarded_organizations': [],
                'groups': [{'name': 'APPS_MALL_STEWARD'}],
                'highest_role': 'APPS_MALL_STEWARD',
                'test_data_input_stewarded_organizations': False},
            # bigbrother2 (minitrue)
            {'username': 'bigbrother2', 'display_name': 'Big Brother2',
                'stewarded_organizations': [],
                'groups': [{'name': 'APPS_MALL_STEWARD'}],
                'highest_role': 'APPS_MALL_STEWARD',
                'test_data_input_stewarded_organizations': False},
            # wsmith (minitrue, stewarded_orgs: minitrue) - Org Steward Level
            {'username': 'wsmith', 'display_name': 'Winston Smith',
                'stewarded_organizations': [{"short_name": "Minitrue", "title": "Ministry of Truth"}],
                'groups': [{"name": "ORG_STEWARD"}],
                'highest_role': 'ORG_STEWARD',
                'test_data_input_stewarded_organizations': True},
            # charrington (minipax, miniluv, minitrue) - User Level
            {'username': 'charrington', 'display_name': 'Charrington',
                'stewarded_organizations': [],
                'groups': [{'name': 'USER'}],
                'highest_role': 'USER',
                'test_data_input_stewarded_organizations': True},
            # jones (minitrue) - User Level
            {'username': 'jones',
                'display_name': 'Jones',
                'stewarded_organizations': [],
                'groups': [{'name': 'USER'}],
                'highest_role': 'USER',
                'test_data_input_stewarded_organizations': True}
        ]

        for current_user_info in user_combo_list:
            current_username = current_user_info['username']
            current_display_name = current_user_info['display_name']
            current_stewarded_organizations = current_user_info['stewarded_organizations']
            current_groups = current_user_info['groups']
            current_highest_role = current_user_info['highest_role']
            current_test_data_input_stewarded_organizations = current_user_info['test_data_input_stewarded_organizations']

            user = generic_model_access.get_profile(current_username).user
            self.client.force_authenticate(user=user)

            url = '/api/self/profile/'
            response = self.client.get(url, format='json')
            response_username = response.data.get('user').get('username')

            self.assertEqual(response.status_code, status.HTTP_200_OK)
            self.assertEqual(response.data.get('display_name'), current_display_name)
            self.assertEqual(response.data.get('stewarded_organizations'), current_stewarded_organizations)
            self.assertEqual(response_username, current_username)
            self.assertEqual(response.data.get('user').get('groups'), current_groups)
            self.assertEqual(response.data.get('highest_role'), current_highest_role)
            self.assertEqual(response.data.get('center_tour_flag'), True)
            self.assertEqual(response.data.get('hud_tour_flag'), True)
            self.assertEqual(response.data.get('webtop_tour_flag'), True)
            self.assertEqual(response.data.get('email_notification_flag'), True)
            self.assertEqual(response.data.get('listing_notification_flag'), True)
            self.assertEqual(response.data.get('subscription_notification_flag'), True)
            self.assertEqual(response.data.get('leaving_aml_warning_flag'), True)

            combinations = [[0, 0, 0], [0, 0, 1], [0, 1, 0], [0, 1, 1],
                            [1, 0, 0], [1, 0, 1], [1, 1, 0], [1, 1, 1]]

            # This loop is testing for all possible flags combinations
            for combination in combinations:
                center_tour_flag = bool(combination[0])
                hud_tour_flag = bool(combination[1])
                webtop_tour_flag = bool(combination[2])
                # email_notification_flag = bool(combination[3])
                # listing_notification_flag = bool(combination[4])
                # subscription_notification_flag = bool(combination[5])
                # leaving_aml_warning_flag = bool(combination[6])

                data = {'id': -1,
                        'center_tour_flag': center_tour_flag,
                        'hud_tour_flag': hud_tour_flag,
                        'webtop_tour_flag': webtop_tour_flag}
                # 'email_notification_flag': email_notification_flag,
                # 'listing_notification_flag': listing_notification_flag,
                # 'subscription_notifcation_flag': subscription_notification_flag,
                # 'leaving_aml_warning_flag': leaving_aml_warning_flag}

                # Testing to make sure that profiles that are lower than
                # APP Mall Steward profile can't edit the stewarded_organizations
                if current_test_data_input_stewarded_organizations:
                    data['stewarded_organizations'] = [{'title': 'Ministry of Truth'},
                                                       {'title': 'Ministry of Love'}]

                response = self.client.put(url, data, format='json')
                self.assertEqual(response.status_code, status.HTTP_200_OK)
                self.assertEqual(response.data.get('display_name'), current_display_name)
                self.assertEqual(response.data.get('stewarded_organizations'), current_stewarded_organizations)
                self.assertEqual(response.data.get('user').get('username'), current_username)
                self.assertEqual(response.data.get('user').get('groups'), current_groups)
                self.assertEqual(response.data.get('highest_role'), current_highest_role)
                self.assertEqual(response.data.get('center_tour_flag'), center_tour_flag)
                self.assertEqual(response.data.get('hud_tour_flag'), hud_tour_flag)
                self.assertEqual(response.data.get('webtop_tour_flag'), webtop_tour_flag)
                # self.assertEqual(response.data.get('email_notification_flag'), email_notification_flag)
                # self.assertEqual(response.data.get('listing_notification_flag'), listing_notification_flag)
                # self.assertEqual(response.data.get('subscription_notification_flag'), subscription_notification_flag)
                # self.assertEqual(response.data.get('leaving_aml_warning_flag'), leaving_aml_warning_flag)

                response = self.client.get(url, format='json')
                self.assertEqual(response.data.get('center_tour_flag'), center_tour_flag)
                self.assertEqual(response.data.get('hud_tour_flag'), hud_tour_flag)
                self.assertEqual(response.data.get('webtop_tour_flag'), webtop_tour_flag)
                # self.assertEqual(response.data.get('email_notification_flag'), email_notification_flag)
                # self.assertEqual(response.data.get('listing_notification_flag'), listing_notification_flag)
                # self.assertEqual(response.data.get('subscription_notification_flag'), subscription_notification_flag)
                # self.assertEqual(response.data.get('leaving_aml_warning_flag'), leaving_aml_warning_flag)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_self_for_apps_mall_steward_level_serializer_exception(self, mock_request):
        """
        test_update_self_for_apps_mall_steward_level_serializer_exception - serializer exception
        """
        settings.AML['USE_AUTH_SERVER'] = True
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)
        url = '/api/self/profile/'
        data = {'id': 5, 'center_tour_flag': 4}
        response = self.client.put(url, data, format='json')
        self.assertEqual(response.data, ExceptionUnitTestHelper.validation_error('{\'center_tour_flag\': [\'"4" is not a valid boolean.\']}'))

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_self_for_apps_mall_steward_level_invalid_user(self, mock_request):
        """
        test_update_self_for_apps_mall_steward_level_invalid_user - invalid user
        """
        settings.AML['USE_AUTH_SERVER'] = True
        url = '/api/self/profile/'
        data = {'id': 5, 'center_tour_flag': False}
        self.client.login(username='invalid', password='invalid')
        response = self.client.put(url, data, format='json')
        self.assertEqual(response.data, ExceptionUnitTestHelper.not_authenticated('Authentication credentials were not provided.'))

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_stewarded_orgs_for_apps_mall_steward_level(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)
        url = self._get_profile_url_for_username('wsmith')
        data = {'display_name': 'Winston Smith', 'stewarded_organizations': [
               {'title': 'Ministry of Truth'}, {'title': 'Ministry of Love'}]}
        response = self.client.put(url, data, format='json')

        orgs = [i['title'] for i in response.data.get('stewarded_organizations')]
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue('Ministry of Truth' in orgs)
        self.assertTrue('Ministry of Love' in orgs)
        self.assertEqual(len(orgs), 2)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_stewarded_orgs_for_apps_mall_steward_level_serializer_exception(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)
        url = self._get_profile_url_for_username('wsmith')
        data = {'display_name': 'Winston Smith', 'stewarded_organizations': False}
        response = self.client.put(url, data, format='json')

        self.assertEqual(response.data, ExceptionUnitTestHelper.request_error("{'stewarded_organizations': {'non_field_errors': ['Expected a " 'list of items but got type "bool".\']}}'))

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_stewarded_orgs_for_org_steward_level(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        user = generic_model_access.get_profile('wsmith').user
        self.client.force_authenticate(user=user)
        url = self._get_profile_url_for_username('wsmith')
        data = {'display_name': 'Winston Smith', 'stewarded_organizations': [
               {'title': 'Ministry of Truth'}, {'title': 'Ministry of Love'}]}
        response = self.client.put(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    @patch('plugins.plugin_manager.requests.get', side_effect=helper.mocked_requests_get)
    def test_update_stewarded_orgs_for_user_level(self, mock_request):
        settings.AML['USE_AUTH_SERVER'] = True
        user = generic_model_access.get_profile('jones').user
        self.client.force_authenticate(user=user)
        url = self._get_profile_url_for_username('wsmith')
        data = {'display_name': 'Winston Smith', 'stewarded_organizations': [
               {'title': 'Ministry of Truth'}, {'title': 'Ministry of Love'}]}
        response = self.client.put(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
