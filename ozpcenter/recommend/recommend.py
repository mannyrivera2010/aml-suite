"""
Recommendations Engine
===============
Business Objective:
To recommend applications to users that they might find useful in their everyday objectives

Website Link: https://github.com/aml-development/ozp-documentation/wiki/Recommender-%282017%29

Data that could be used for recommendations
- Listing Bookmarked
- Keep track of folder apps

Recommendations are based on individual users

Assumptions:
    45,000 Users
    350 Listings

Worst Case Number of Recommendations = 15,750,000

Steps:
    - Load Data for each users
    - Process Data with recommendation algorthim
      - Produces a list of listing's id for each profile = Results
    - Iterate through the Results to call add_listing_to_user_profile function

Idea:
Jitting Result
"""
import logging
import time

import msgpack
from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Count
from django.db import transaction
from django.conf import settings

from ozpcenter import models
from ozpcenter.recommend import recommend_utils
from ozpcenter.recommend import recommend_es
from ozpcenter.recommend.graph_factory import GraphFactory
from ozpcenter.api.listing.elasticsearch_util import elasticsearch_factory


logger = logging.getLogger('ozp-center.' + str(__name__))


class ProfileResultSet(object):

    def __init__(self):
        """
        recommender_result_set: Dictionary with profile id, nested listing id with score pairs
        {
            profile_id#1: {
                listing_id#1: score#1,
                listing_id#2: score#2
            },
            profile_id#2: {
                listing_id#1: score#1,
                listing_id#2: score#2,
                listing_id#3: score#3,
            }
        }
        """
        self.recommender_result_set = {}

    def add_listing_to_user_profile(self, profile_id, listing_id, score, cumulative=False):
        if profile_id in self.recommender_result_set:
            if self.recommender_result_set[profile_id].get(listing_id):
                if cumulative:
                    self.recommender_result_set[profile_id][listing_id] = self.recommender_result_set[profile_id][listing_id] + float(score)
                else:
                    self.recommender_result_set[profile_id][listing_id] = float(score)
            else:
                self.recommender_result_set[profile_id][listing_id] = float(score)
        else:
            self.recommender_result_set[profile_id] = {}
            self.recommender_result_set[profile_id][listing_id] = float(score)


class RecommenderProfileResultSet(object):

    def __init__(self, profile_id):
        """
        profile_id:
        Data:
        {
            recommender_friendly_name#1:{
                recommendations:{
                    listing_id#1: score#1,
                    listing_id#2: score#2
                }
                weight: 1.0,
                ms_took: 3000
            },
            recommender_friendly_name#2:{
                recommendations:{
                    listing_id#1: score#1,
                    listing_id#2: score#2,
                    listing_id#3: score#3,
                }
                weight: 1.0
                ms_took: 5050
            }
        }
        """
        self.profile_id = profile_id
        self.recommender_result_set = {}

    def merge(self, recommender_friendly_name, recommendation_weight, current_recommendations, recommendations_time):
        """
        Purpose is to merge all of the different Recommender's algorthim recommender result together.
        This function is responsible for merging the results of the other Recommender recommender_result_set diction into self recommender_result_set

        Args:
            friendly_name: Recommender friendly name
            recommendation_weight: Recommender weight
            profile_result_set(ProfileResultSet): Recommender results
            recommendations_time: Recommender time
        """
        if recommender_friendly_name not in self.recommender_result_set:
            self.recommender_result_set[recommender_friendly_name] = {
                'recommendations': current_recommendations,
                'weight': recommendation_weight,
                'ms_took': recommendations_time
            }

    def __repr__(self):
        return str(self.recommender_result_set)


class RecommenderResultSet(object):

    def __init__(self):
        """
        {
            profile_id#1: RecommenderProfileResultSet(),
            profile_id#2: RecommenderProfileResultSet(),
        }

        recommender_result_set serialized
        {
            profile_id#1: {
                recommender_friendly_name#1:{
                    recommendations:[
                        [listing_id#1, score#1],
                        [listing_id#2, score#2]
                    ]
                    weight: 1.0
                    ms_took: 5050
                },
                recommender_friendly_name#2:{
                    recommendations:[
                        [listing_id#1, score#1],
                        [listing_id#2, score#2]
                    ]
                    weight: 2.0
                    ms_took: 5050
                }
            },
            profile_id#2: {
                recommender_friendly_name#1:{
                    recommendations:[
                        [listing_id#1, score#1],
                        [listing_id#2, score#2]
                    ]
                    weight: 1.0,
                    ms_took: 5050
                },
                recommender_friendly_name#2:{
                    recommendations:[
                        [listing_id#1, score#1],
                        [listing_id#2, score#2]
                    ]
                    weight: 1.0
                    ms_took: 5050
                }
            }
        }
        """
        self.recommender_result_set = {}

    def __repr__(self):
        return str(self.recommender_result_set)

    def merge(self, recommender_friendly_name, recommendation_weight, profile_result_set, recommendations_time):
        """
        Purpose is to merge all of the different Recommender's algorthim recommender result together.
        This function is responsible for merging the results of the other Recommender recommender_result_set diction into self recommender_result_set

        Args:
            friendly_name: Recommender friendly name
            recommendation_weight: Recommender weight
            profile_result_set(ProfileResultSet): Recommender results
            recommendations_time: Recommender time
        """
        for profile_id in profile_result_set.recommender_result_set:
            if profile_id not in self.recommender_result_set:
                self.recommender_result_set[profile_id] = RecommenderProfileResultSet(profile_id)
            current_recommendations = profile_result_set.recommender_result_set[profile_id]
            self.recommender_result_set[profile_id].merge(recommender_friendly_name, recommendation_weight, current_recommendations, recommendations_time)


class BaselineRecommender(object):
    """
    Baseline Recommender

    Assumptions:
    - Listing has ratings and possible not to have ratings
    - Listing can be featured
    - User bookmark Listings
    - User have bookmark folder, a collection of listing in a folder.
    - Listing has total_reviews field

    Requirements:
    - Recommendations should be explainable and believable
    - Must respect private apps
    - Does not have to repect security_marking while saving to db
    """
    friendly_name = 'Baseline'
    recommendation_weight = 1.0

    def initiate(self):
        """
        Initiate any variables needed for recommendation_logic function
        """
        pass

    def recommendation_logic(self):
        """
        Sample Recommendations for all users
        """
        all_profiles = models.Profile.objects.all()
        all_profiles_count = len(all_profiles)

        current_profile_count = 0
        for profile in all_profiles:
            current_profile_count = current_profile_count + 1
            logger.debug('Calculating Profile {}/{}'.format(current_profile_count, all_profiles_count))

            profile_id = profile.id
            profile_username = profile.user.username
            # Get Featured Listings
            featured_listings = models.Listing.objects.for_user_organization_minus_security_markings(
                profile_username).order_by('-approved_date').filter(
                    is_featured=True,
                    approval_status=models.Listing.APPROVED,
                    is_enabled=True,
                    is_deleted=False)[:36]

            for current_listing in featured_listings:
                self.profile_result_set.add_listing_to_user_profile(profile_id, current_listing.id, 3.0, True)

            # Get Recent Listings
            recent_listings = models.Listing.objects.for_user_organization_minus_security_markings(
                profile_username).order_by(
                    '-approved_date').filter(
                        is_featured=False,
                        approval_status=models.Listing.APPROVED,
                        is_enabled=True,
                        is_deleted=False)[:36]

            for current_listing in recent_listings:
                self.profile_result_set.add_listing_to_user_profile(profile_id, current_listing.id, 2.0, True)

            # Get most popular listings via a weighted average
            most_popular_listings = models.Listing.objects.for_user_organization_minus_security_markings(
                profile_username).filter(
                    approval_status=models.Listing.APPROVED,
                    is_enabled=True,
                    is_deleted=False).order_by('-avg_rate', '-total_reviews')[:36]

            for current_listing in most_popular_listings:
                if current_listing.avg_rate != 0:
                    self.profile_result_set.add_listing_to_user_profile(profile_id, current_listing.id, current_listing.avg_rate, True)

            # Get most popular bookmarked apps for all users
            # Would it be faster it this code was outside the loop for profiles?
            library_entries = models.ApplicationLibraryEntry.objects.for_user_organization_minus_security_markings(profile_username)
            library_entries = library_entries.filter(listing__is_enabled=True)
            library_entries = library_entries.filter(listing__is_deleted=False)
            library_entries = library_entries.filter(listing__approval_status=models.Listing.APPROVED)
            library_entries_group_by_count = library_entries.values('listing_id').annotate(count=Count('listing_id')).order_by('-count')
            # [{'listing_id': 1, 'count': 1}, {'listing_id': 2, 'count': 1}]

            # Calculation of Min and Max new scores dynamically.  This will increase the values that are lower
            # to a range within 2 and 5, but will not cause values higher than new_min and new_max to become even
            # larger.
            old_min = 1
            old_max = 1
            new_min = 2
            new_max = 5

            for entry in library_entries_group_by_count:
                count = entry['count']
                if count == 0:
                    continue
                if count > old_max:
                    old_max = count
                if count < old_min:
                    old_min = count

            for entry in library_entries_group_by_count:
                listing_id = entry['listing_id']
                count = entry['count']

                calculation = recommend_utils.map_numbers(count, old_min, old_max, new_min, new_max)
                self.profile_result_set.add_listing_to_user_profile(profile_id, listing_id, calculation, True)


class GraphCollaborativeFilteringBaseRecommender(object):
    """
    Graph Collaborative Filtering based on Bookmarkes
    """
    friendly_name = 'Bookmark Collaborative Filtering'
    recommendation_weight = 5.0

    def initiate(self):
        """
        Initiate any variables needed for recommendation_logic function
        """
        self.graph = GraphFactory.load_db_into_graph()
        self.all_profiles = models.Profile.objects.all()
        self.all_profiles_count = len(self.all_profiles)

    def recommendation_logic(self):
        """
        Recommendation logic
        """
        current_profile_count = 0
        for profile in self.all_profiles:
            profile_id = profile.id
            current_profile_count = current_profile_count + 1
            logger.debug('Calculating Profile {}/{}'.format(current_profile_count, self.all_profiles_count))

            results = self.graph.algo().recommend_listings_for_profile('p-{}'.format(profile_id))  # bigbrother

            for current_tuple in results:
                listing_raw = current_tuple[0]  # 'l-#'
                listing_id = int(listing_raw.split('-')[1])
                score = current_tuple[1]
                # No need to rebase since results are within the range of others based on testing:
                self.profile_result_set.add_listing_to_user_profile(profile_id, listing_id, score)


# Method is decorated with @transaction.atomic to ensure all logic is executed in a single transaction
@transaction.atomic
def bulk_recommendations_saver(recommendation_entries):
    # Loop over each store and invoke save() on each entry
    for recommendation_entry in recommendation_entries:
        target_profile = recommendation_entry['target_profile']
        recommendation_data = recommendation_entry['recommendation_data']

        # models.RecommendationsEntry.objects.filter(target_profile__in=profile_query).delete() occured
        # try:
        #     obj = models.RecommendationsEntry.objects.get(target_profile=target_profile)
        #     obj.recommendation_data = recommendation_data
        #     obj.save()
        # except models.RecommendationsEntry.DoesNotExist:
        recommendation_entry_obj = models.RecommendationsEntry(target_profile=target_profile, recommendation_data=recommendation_data)
        recommendation_entry_obj.save()


class RecommenderDirectory(object):
    """
    Wrapper for all Recommenders
    """

    def __init__(self):
        self.recommender_classes = {
            'elasticsearch_user_base': recommend_es.ElasticsearchUserBaseRecommender,
            'elasticsearch_content_base': recommend_es.ElasticsearchContentBaseRecommender,
            'baseline': BaselineRecommender,
            'graph_cf': GraphCollaborativeFilteringBaseRecommender,
        }
        self.recommender_result_set_obj = RecommenderResultSet()

    def _iterate_recommenders(self, recommender_string):
        """
        Convert recommender string into Recommender instances
        """
        for current_recommender in recommender_string.split(','):
            current_recommender_string = current_recommender.strip()

            if current_recommender_string in self.recommender_classes:
                current_recommender_obj = self.recommender_classes[current_recommender_string]()
                current_recommender_obj.profile_result_set = ProfileResultSet()

                current_recommender_class = current_recommender_obj.__class__
                friendly_name = current_recommender_class.__name__

                if hasattr(current_recommender_class, 'friendly_name'):
                    friendly_name = current_recommender_class.friendly_name

                recommendation_weight = 1.0
                if hasattr(current_recommender_class, 'recommendation_weight'):
                    recommendation_weight = current_recommender_class.recommendation_weight

                yield current_recommender_obj, friendly_name, recommendation_weight
            else:
                logger.warn('Recommender Engine [{}] Not Found'.format(current_recommender))

    def recommend(self, recommender_string):
        """
        Creates Recommender Object, and execute the recommend

        Args:
            recommender_string: Comma Delimited list of Recommender Engine to execute
        """
        start_ms = time.time() * 1000.0

        for recommender_obj, friendly_name, recommendation_weight in self._iterate_recommenders(recommender_string):
            logger.info('=={}=='.format(friendly_name))

            if hasattr(recommender_obj, 'initiate'):
                # initiate - Used for initiating variables, classes, objects, connecting to service
                recommender_obj.initiate()

            recommendations_start_ms = time.time() * 1000.0

            if not hasattr(recommender_obj, 'recommendation_logic'):
                raise Exception('Recommender instance needs recommendation_logic method')

            recommender_obj.recommendation_logic()

            profile_result_set = recommender_obj.profile_result_set
            logger.debug(profile_result_set)

            recommendations_end_ms = time.time() * 1000.0
            recommendations_time = recommendations_end_ms - recommendations_start_ms

            logger.info('Merging {} into results'.format(friendly_name))
            self.recommender_result_set_obj.merge(friendly_name, recommendation_weight, profile_result_set, recommendations_time)

        logger.info('==Start saving recommendations into database==')
        start_db_ms = time.time() * 1000.0
        self.save_to_db()
        end_db_ms = time.time() * 1000.0
        logger.info('Save to database took: {} ms'.format(end_db_ms - start_db_ms))
        logger.info('Whole Process: {} ms'.format(end_db_ms - start_ms))

    def save_to_db(self):
        """
        This function is responsible for storing the recommendations into the database

        # Pre-refactor - Save to database took: 2477.896240234375 ms, Database Calls: 1178
        # Post-refactor - Save to database took: 101.677978515625 ms, Database Calls: 584

        Performance:
            transaction.atomic() - 430 ms
            Without Atomic and Batch - 1400 ms
        """
        recommender_result_set = self.recommender_result_set_obj.recommender_result_set

        batch_list = []

        # Get all profiles in recommender_result_set
        profile_id_list = list(set([profile_id for profile_id in recommender_result_set]))

        profile_query = models.Profile.objects.filter(id__in=profile_id_list)
        profile_dict = {profile.id: profile for profile in profile_query}

        listing_dict = {listing.id: listing for listing in models.Listing.objects.all()}

        # Delete RecommendationsEntry Entries for profiles
        profile_query = models.Profile.objects.filter(id__in=profile_id_list)
        models.RecommendationsEntry.objects.filter(target_profile__in=profile_query).delete()

        for profile_id in recommender_result_set:
            # print('*-*-*-*-'); import json; print(json.dumps(self.recommender_result_set[profile_id])); print('*-*-*-*-')
            profile = profile_dict.get(profile_id)

            if profile:
                for current_recommender_friendly_name in recommender_result_set[profile_id].recommender_result_set:
                    output_current_tuples = []

                    current_recommendations = recommender_result_set[profile_id].recommender_result_set[current_recommender_friendly_name]['recommendations']
                    sorted_recommendations = recommend_utils.get_top_n_score(current_recommendations, 20)

                    for current_recommendation_tuple in sorted_recommendations:
                        current_listing_id = current_recommendation_tuple[0]
                        # current_listing_score = current_recommendation_tuple[1]
                        current_listing = listing_dict.get(current_listing_id)

                        if current_listing:
                            output_current_tuples.append(current_recommendation_tuple)

                    recommender_result_set[profile_id].recommender_result_set[current_recommender_friendly_name]['recommendations'] = output_current_tuples

                batch_list.append({'target_profile': profile,
                                   'recommendation_data': msgpack.packb(recommender_result_set[profile_id].recommender_result_set)})

                if len(batch_list) >= 1000:
                    bulk_recommendations_saver(batch_list)
                    batch_list = []

        if batch_list:
            bulk_recommendations_saver(batch_list)
