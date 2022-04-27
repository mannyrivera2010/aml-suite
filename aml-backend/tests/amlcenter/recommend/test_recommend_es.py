"""
Tests for Recommendations ES
"""
import logging

from django.test import override_settings

from rest_framework import status
from tests.aml.cases import APITestCase

from amlcenter import model_access as generic_model_access
from amlcenter.scripts import sample_data_generator as data_gen
from tests.amlcenter.helper import APITestHelper
from amlcenter.utils import shorthand_dict
from amlcenter.api.listing import model_access_es
from amlcenter.api.listing.elasticsearch_util import elasticsearch_factory
from amlcenter.recommend.recommend import RecommenderDirectory


@override_settings(ES_ENABLED=False)
class ElasticsearchBaseRecommenderTest(APITestCase):

    @override_settings(ES_ENABLED=True)
    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None
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
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        title_scores = [{'title': listing['title'], '_score': listing['_score']} for listing in response.data['recommended']]
        # title_scores = sorted(title_scores, key=lambda k: (k['_score']['_sort_score'], k['title']))
        title_scores = shorthand_dict(title_scores)

        expected_result = [
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.762,weight:0.9),_sort_score:7.886),title:BeiDou Navigation Satellite System)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.677,weight:0.9),_sort_score:7.809),title:Rogue)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.572,weight:0.9),_sort_score:7.715),title:Wolverine)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.544,weight:0.9),_sort_score:7.69),title:Navigation using Maps)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.475,weight:0.9),_sort_score:7.627),title:Neptune)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.439,weight:0.9),_sort_score:7.595),title:Komodo Dragon)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.303,weight:0.9),_sort_score:7.473),title:Magneto)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.283,weight:0.9),_sort_score:7.455),title:Jupiter)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.273,weight:0.9),_sort_score:7.446),title:Uranus)",
            "(_score:(Elasticsearch Content Filtering:(raw_score:8.261,weight:0.9),_sort_score:7.435),title:Cyclops)"
        ]

        import json
        print(json.dumps(title_scores, indent=4))
        self.assertEquals(expected_result, title_scores)

    @override_settings(ES_ENABLED=True)
    def test_recommendation_user_base(self):
        if self.es_failed:
            self.skipTest('Elasticsearch is not currently up: {}'.format(self.error_string))
        recommender_wrapper_obj = RecommenderDirectory()
        actual_result = recommender_wrapper_obj.recommend('elasticsearch_user_base')
        expected_result = {'Elasticsearch User Based Filtering': {}}

        self.assertEquals(actual_result, expected_result)

        url = '/api/storefront/recommended/?randomize=False'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        title_scores = [{'title': listing['title'], '_score': listing['_score']} for listing in response.data['recommended']]
        # title_scores = sorted(title_scores, key=lambda k: (k['_score']['_sort_score'], k['title']))
        title_scores = shorthand_dict(title_scores)

        expected_result = [
            '(_score:(Elasticsearch User Based Filtering:(raw_score:10.0,weight:1.0),_sort_score:10.0),title:Railroad)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:10.0,weight:1.0),_sort_score:10.0),title:Barsoom)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:10.0,weight:1.0),_sort_score:10.0),title:Snow)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:10.0,weight:1.0),_sort_score:10.0),title:Business Management System)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:10.0,weight:1.0),_sort_score:10.0),title:Tornado)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:8.333,weight:1.0),_sort_score:8.333),title:Pluto (Not a planet))',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:8.333,weight:1.0),_sort_score:8.333),title:Project Management)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:8.333,weight:1.0),_sort_score:8.333),title:BeiDou Navigation Satellite System)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:8.333,weight:1.0),_sort_score:8.333),title:Satellite navigation)',
            '(_score:(Elasticsearch User Based Filtering:(raw_score:8.333,weight:1.0),_sort_score:8.333),title:Stop sign)'
        ]

        # import json; print(json.dumps(title_scores, indent=4))
        self.assertEquals(expected_result, title_scores)
