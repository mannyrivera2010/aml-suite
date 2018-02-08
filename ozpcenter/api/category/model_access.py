"""
Category Model Access
"""
import logging

from django.db.models.functions import Lower
from django.core.exceptions import ObjectDoesNotExist
from ozpcenter import errors

from ozpcenter import models

import ozpcenter.model_access as generic_model_access


logger = logging.getLogger('ozp-center.' + str(__name__))


def get_all_categories():
    """
    Get all categories
    """
    return models.Category.objects.order_by(Lower('title')).all()


def get_category_by_title(title, reraise=False):
    """
    Get a category by title
    """
    try:
        return models.Category.objects.get(title=title)
    except models.Category.DoesNotExist as err:
        if reraise:
            raise err
        return None


def get_category_by_id(input_id, reraise=False):
    """
    Get a category by id
    """
    try:
        return models.Category.objects.get(id=input_id)
    except models.Category.DoesNotExist as err:
        if reraise:
            raise err
        return None


def get_listing_by_category_id(username, category_id, reraise=False):
    """
    Get listings by category_id

    Args:
        username(str)
        category_id
        reraise(bool)
    """
    # TODO, GET listing based on the role
    # Logic
    # ensure apps steward sees all listings or
    # org steward only sees her organizations listings or
    # user only sees her listings
    #

    profile = generic_model_access.get_profile(username)
    print(profile, profile.highest_role(), category_id)

    try:
        user = generic_model_access.get_profile(username)

        if profile.highest_role() == 'APPS_MALL_STEWARD':
            # Get all listings that contain this category
            print('In condition: APPS_MALL_STEWARD')
            queryset = models.Listing.objects.filter(categories=category_id)
            print(queryset.query)
            return queryset
        elif profile.highest_role() == 'ORG_STEWARD':
            # Get listings where the user is an Org_Steward   TODO: Check query
            print('In condition: ORG_STEWARD')

            user_orgs = user.stewarded_organizations.all()
            # returns  <QuerySet [Ministry of Truth, Ministry of Love]>

            user_orgs = [i.title for i in user_orgs]
            # returns ['Ministry of Truth', 'Ministry of Love']

            user_agency_ids = [agency.id for agency in models.Agency.objects.filter(title__in=user_orgs)]
            # returns [ 1,3]

            queryset = (models.Listing
                        .objects
                        .filter(categories=category_id)
                        .filter(agency__in=user_agency_ids))
            print(queryset.query)
            return queryset
        else:
            # Get listings where the user is an owner
            print('In condition: Owner')
            queryset = (models.Listing
                        .objects
                        .filter(categories=category_id,
                                listing__owners__user__username__exact=username))
            print(queryset.query)
            return queryset

    except ObjectDoesNotExist as err:
        if reraise:
            raise err
        else:
            return None
