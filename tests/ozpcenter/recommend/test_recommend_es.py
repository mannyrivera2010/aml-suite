"""
Tests for Recommendations ES
"""
import logging

from django.test import override_settings

from rest_framework import status
from rest_framework.test import APITestCase

from ozpcenter import model_access as generic_model_access
from ozpcenter.scripts import sample_data_generator as data_gen
from tests.ozpcenter.helper import ListingFile
from tests.ozpcenter.helper import unittest_request_helper
from tests.ozpcenter.helper import _edit_listing
from ozpcenter.api.listing import model_access_es
from ozpcenter.api.listing.elasticsearch_util import elasticsearch_factory


@override_settings(ES_ENABLED=False)
class ElasticsearchBaseRecommenderTest(APITestCase):

    @override_settings(ES_ENABLED=True)
    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.error_string = None
        self.es_failed = False
        try:
            elasticsearch_factory.check_elasticsearch()
        except Exception as err:
            self.error_string = str(err)
            self.es_failed = True

        if not self.es_failed:
            logging.getLogger('elasticsearch').setLevel(logging.CRITICAL)
            model_access_es.bulk_reindex()

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    @override_settings(ES_ENABLED=True)
    def test_recommendation_content_base(self):
        if self.es_failed:
            self.skipTest('Elasticsearch is not currently up: {}'.format(self.error_string))
        # TODO: Finish Logic

    @override_settings(ES_ENABLED=True)
    def test_recommendation_user_base(self):
        if self.es_failed:
            self.skipTest('Elasticsearch is not currently up: {}'.format(self.error_string))
        # TODO: Finish Logic
