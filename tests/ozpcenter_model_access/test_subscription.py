"""
Notification tests
"""
from django.test import override_settings
from django.test import TestCase

# from ozpcenter import models
from ozpcenter.scripts import sample_data_generator as data_gen
# import ozpcenter.api.notification.model_access as model_access


@override_settings(ES_ENABLED=False)
class SubscriptionTest(TestCase):

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
        pass
        # data_gen.run()

    def test_get_self_subscription(self):
        pass

    # TODO: Add More Tests
