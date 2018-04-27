"""
Tests for (most) of the PkiAuthentication mechanism
"""
from django.test import override_settings
from django.test import TestCase
from unittest.mock import MagicMock

from ozpcenter import models
from ozpcenter.scripts import sample_data_generator as data_gen
import ozpcenter.model_access as model_access

from ozpcenter.wsservice.wsclient import web_service_client


@override_settings(ES_ENABLED=False)
class WSServiceTest(TestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.meta_dict = {

        }
        self.request = MagicMock()
        self.request.is_secure.side_effect = lambda *arg: True

        self.request.META.get.side_effect = lambda *arg: self.meta_dict.get(arg[0], arg[1])

        self.web_service_client = web_service_client

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    # TODO: Finish TestCase

    # def test_authenticate_is_secure_false(self):
    #     self.request.is_secure.side_effect = lambda *arg: False
    #     results = self.pki_authentication.authenticate(self.request)
    #     expected_results = None
    #
    #     self.assertEquals(expected_results, results)
