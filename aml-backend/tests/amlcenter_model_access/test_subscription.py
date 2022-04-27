"""
Notification tests
"""
from django.test import override_settings
from django.test import TestCase

from amlcenter import models
import amlcenter.model_access as generic_model_access
from amlcenter.scripts import sample_data_generator as data_gen
import amlcenter.api.subscription.model_access as model_access


@override_settings(ES_ENABLED=False)
class SubscriptionModelAccessTest(TestCase):

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

    def test_create_update_subscription(self):
        subscription_instance = model_access.create_subscription('bigbrother', 'category', 4)

        updated_subscription_instance = model_access.update_subscription('bigbrother', subscription_instance, 'category', 1)

        self.assertEqual(updated_subscription_instance.target_profile.user.username, 'bigbrother')
        self.assertEqual(updated_subscription_instance.entity_id, 1)

        with self.assertRaisesRegex(Exception, 'Can not update a subscription that you do not own') as err:
            model_access.update_subscription('jones', subscription_instance, 'category', 1)

    def test_create_subscription_multiple_objects(self):
        target_profile = generic_model_access.get_profile('bigbrother')

        subscription = models.Subscription(
            target_profile=target_profile,
            entity_type='category',
            entity_id=2
        )
        subscription.save()

        subscription1 = models.Subscription(
            target_profile=target_profile,
            entity_type='category',
            entity_id=2
        )
        subscription1.save()

        subscription_instance = model_access.create_subscription('bigbrother', 'category', 2)
        self.assertEqual(subscription_instance.target_profile.user.username, 'bigbrother')
        self.assertEqual(subscription_instance.entity_id, 2)

    def test_update_subscription_multiple_objects(self):
        target_profile = generic_model_access.get_profile('bigbrother')

        subscription = models.Subscription(
            target_profile=target_profile,
            entity_type='category',
            entity_id=2
        )
        subscription.save()

        subscription1 = models.Subscription(
            target_profile=target_profile,
            entity_type='category',
            entity_id=2
        )
        subscription1.save()

        subscription_instance = model_access.update_subscription('bigbrother', subscription1, 'category', 2)
        self.assertEqual(subscription_instance.target_profile.user.username, 'bigbrother')
        self.assertEqual(subscription_instance.entity_id, 2)
