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
from ozpcenter.recommend.recommend import RecommenderDirectory


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
        recommender_wrapper_obj = RecommenderDirectory()
        actual_result = recommender_wrapper_obj.recommend('elasticsearch_content_base')
        expected_result = {'Elasticsearch Content Filtering': {}}
        self.assertEquals(actual_result, expected_result)

        url = '/api/storefront/recommended/?randomize=False'
        response = unittest_request_helper(self, url, 'GET', username='wsmith', status_code=200)

        title_scores = [{'title': listing['title'], '_score': listing['_score']} for listing in response.data['recommended']]

        expected_result = [{'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.761904761904763,
                                                 'weight': 0.9}},
                            'title': 'Wolverine'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.31542776285455,
                                                                           'weight': 0.9}},
                            'title': 'Beast'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.268208269581375,
                                                                           'weight': 0.9}},
                            'title': 'Magneto'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.213217085881054,
                                                                           'weight': 0.9}},
                            'title': 'Jupiter'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.111898282158764,
                                                                           'weight': 0.9}},
                            'title': 'Pokemon Ruby and Sapphire'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.096267499890592,
                                                                           'weight': 0.9}},
                            'title': 'Cyclops'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.094371457453942,
                                                                           'weight': 0.9}},
                            'title': 'Barsoom'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.087702431923233,
                                                                           'weight': 0.9}},
                            'title': 'Blink'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 8.08026005270565,
                                                                           'weight': 0.9}},
                            'title': 'Clerks'},
                           {'_score': {'Elasticsearch Content Filtering': {'raw_score': 7.998745110523403,
                                                                           'weight': 0.9}},
                            'title': 'Rogue'}]

        self.assertEquals(expected_result, title_scores)  # Can not do this because results is randomized

    @override_settings(ES_ENABLED=True)
    def test_recommendation_user_base(self):
        if self.es_failed:
            self.skipTest('Elasticsearch is not currently up: {}'.format(self.error_string))
        recommender_wrapper_obj = RecommenderDirectory()
        actual_result = recommender_wrapper_obj.recommend('elasticsearch_user_base')
        expected_result = {'Elasticsearch User Based Filtering': {}}

        self.assertEquals(actual_result, expected_result)

        url = '/api/storefront/recommended/?randomize=False'
        response = unittest_request_helper(self, url, 'GET', username='wsmith', status_code=200)

        title_scores = [{'title': listing['title'], '_score': listing['_score']} for listing in response.data['recommended']]

        expected_result = [{'_score': {'Elasticsearch User Based Filtering': {'raw_score': 10.0,
                                                    'weight': 1.0}},
                            'title': 'Railroad'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 10.0,
                                                                              'weight': 1.0}},
                            'title': 'Tornado'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 10.0,
                                                                              'weight': 1.0}},
                            'title': 'Barsoom'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 10.0,
                                                                              'weight': 1.0}},
                            'title': 'Snow'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 10.0,
                                                                              'weight': 1.0}},
                            'title': 'Business Management System'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 8.33333333333333,
                                                                              'weight': 1.0}},
                            'title': 'Pluto (Not a planet)'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 8.33333333333333,
                                                                              'weight': 1.0}},
                            'title': 'Great white shark'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 8.33333333333333,
                                                                              'weight': 1.0}},
                            'title': 'Sun'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 8.33333333333333,
                                                                              'weight': 1.0}},
                            'title': 'Superunknown'},
                           {'_score': {'Elasticsearch User Based Filtering': {'raw_score': 8.33333333333333,
                                                                              'weight': 1.0}},
                            'title': 'Project Management'}]
        # import pprint
        # print(pprint.pprint(title_scores))
        self.assertEquals(expected_result, title_scores)  # Can not do this because results is randomized
