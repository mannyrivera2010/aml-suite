"""
Image tests
"""
from django.test import override_settings
from django.test import TestCase

from ozpcenter.scripts import sample_data_generator as data_gen
import ozpcenter.api.image.model_access as model_access
from ozpcenter import errors
import ozpcenter.model_access as generic_model_access
from ozpcenter import models


@override_settings(ES_ENABLED=False)
class AgencyTest(TestCase):

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

    def test_get_all_images_by_username(self):
        images = model_access.get_all_images('bigbrother')
        self.assertIsNotNone(images)

    def test_get_image_by_id_err(self):
        image = model_access.get_image_by_id(0)
        self.assertIsNone(image)
