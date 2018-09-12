"""
Utils tests
"""
from django.test import TestCase
from django.conf import settings


class SettingsTest(TestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        pass

    def test_has_default_agency(self):
        self.assertTrue(hasattr(settings, 'DEFAULT_AGENCY'))

    def test_aml_variable(self):
        self.assertTrue(hasattr(settings, 'AML'))

        # Testing to make sure keys exist
        aml = settings.AML
        aml_level_keys = ['DEMO_APP_ROOT',
                          'USE_AUTH_SERVER',
                          'PREPROCESS_DN',
                          'AML_AUTHORIZATION']
        for current_key in aml_level_keys:
            self.assertTrue(current_key in aml)

        # Testing to make sure keys exist
        aml_aml_authorization = aml['AML_AUTHORIZATION']
        aml_aml_authorization_levels = ['SERVER_CRT',
                                        'SERVER_KEY',
                                        'USER_INFO_URL',
                                        'USER_GROUPS_URL',
                                        'APPS_MALL_STEWARD_GROUP_NAME',
                                        'ORG_STEWARD_GROUP_NAME',
                                        'METRICS_GROUP_NAME',
                                        'BETA_USER_GROUP_NAME',
                                        'PROJECT_NAME',
                                        'SECONDS_TO_CACHE_DATA']
        for current_key in aml_aml_authorization_levels:
            self.assertTrue(current_key in aml_aml_authorization)
