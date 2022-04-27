"""
Recommendation Engine Runner

settings.py/or this file?
-----
recommendation_engines = ['ElasticsearchUserBaseRecommender', 'ElasticsearchContentBaseRecommender', 'CrabUserBaseRecommender']
----
os.getenv('RECOMMENDATION_ENGINE')


ES_ENABLED=True RECOMMENDATION_ENGINE=elasticsearch_content_base python manage.py runscript recommend

************************************WARNING************************************
Running this script will delete existing Recommendations in database
************************************WARNING************************************
"""
import logging
import sys
import os

sys.path.insert(0, os.path.realpath(os.path.join(os.path.dirname(__file__), '../../')))

from amlcenter.recommend.recommend import RecommenderDirectory
# TODO: Uncomment line below when Elasticsearch is ready to be turned on along with other code changes below.
from django.conf import settings

# TODO: Uncomment lines and indent current RECOMMENDATION_ENGINE line when Elasticsearch is ready to be added
#       to the recommendation engine list.
if settings.ES_ENABLED is True:
    RECOMMENDATION_ENGINE = os.getenv('RECOMMENDATION_ENGINE', 'baseline,graph_cf,elasticsearch_user_base,elasticsearch_content_base')
else:
    RECOMMENDATION_ENGINE = os.getenv('RECOMMENDATION_ENGINE', 'baseline,graph_cf')


logger = logging.getLogger('aml-center.' + str(__name__))


def run():
    """
    Run the Recommendation Engine
    """
    logger.info('RECOMMENDATION_ENGINE: {}'.format(RECOMMENDATION_ENGINE))

    recommender_wrapper_obj = RecommenderDirectory()
    recommender_wrapper_obj.recommend(RECOMMENDATION_ENGINE)
