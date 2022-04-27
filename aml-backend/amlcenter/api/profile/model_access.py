"""
Profile Model Access
"""
import logging

from amlcenter import errors
from amlcenter import models
from amlcenter import utils
from django.contrib import auth
import amlcenter.model_access as generic_model_access
import amlcenter.api.storefront.model_access as storefront_model_access

from plugins import plugin_manager
system_has_access_control = plugin_manager.system_has_access_control


logger = logging.getLogger('aml-center.' + str(__name__))


def get_self(username):
    """
    Get Profile by username

    Args:
        username(str)

    Return:
        Profile
    """
    return generic_model_access.get_profile(username)


def get_all_profiles():
    """
    Get All Profiles
    """
    return models.Profile.objects.all().order_by('display_name')


def get_profile_by_id(profile_id):
    """
    Get profile by id
    """
    try:
        return models.Profile.objects.get(id=profile_id)
    except models.Listing.DoesNotExist:
        return None


def get_all_listings_for_profile_by_id(current_request_username, profile_id, listing_id=None, ordering=None):
    """
    Get all Listing for a profile by profile_id and listing_id

    Args:
        current_request_username
        profile_id
        listing_id
        ordering

    Raises:
        models.Profile.DoesNotExist
        models.Listing.DoesNotExist
    """

    if not profile_id or profile_id == 'self':
        profile_instance = models.Profile.objects.get(user__username=current_request_username)
    else:
        profile_instance = models.Profile.objects.get(id=profile_id)

    listings = (models.Listing.objects.for_user(current_request_username)
        .filter(owners__in=[profile_instance.id])
        .filter(is_deleted=False).order_by('approval_status'))

    if listing_id:
        listings = listings.get(id=listing_id)
    else:
        listings = storefront_model_access.custom_sort_listings(listings.all(), ordering)

    return listings


def get_visit_count_by_id(id):
    """
    Get listing visit count by id
    """
    return models.ListingVisitCount.objects.get(id=id)


def get_listing_visit_counts_for_profile(current_request_username, profile_id, listing_id=None):
    """
    Get listing visit counts for a profile_id and listing_id

    Args:
        current_request_username
        profile_id
        listing_id

    Raises:
        models.Profile.DoesNotExist
        models.Listing.DoesNotExist
    """

    if not profile_id or profile_id == 'self':
        profile_instance = models.Profile.objects.get(user__username=current_request_username)
    else:
        profile_instance = models.Profile.objects.get(id=profile_id)

    visit_counts = models.ListingVisitCount.objects.for_user(current_request_username).filter(profile=profile_instance)
    if listing_id:
        visit_counts = visit_counts.filter(listing_id=listing_id)

    return visit_counts.order_by('-count')


def get_frequently_visited_listings(current_request_username, profile_id, ordering=None):
    """
    Get frequently visited Listing objects for a profile by profile_id

    Args:
        current_request_username
        profile_id
        ordering

    Raises:
        models.Profile.DoesNotExist
    """

    if not profile_id or profile_id == 'self':
        profile_instance = models.Profile.objects.get(user__username=current_request_username)
    else:
        profile_instance = models.Profile.objects.get(id=profile_id)

    visit_counts = (models.ListingVisitCount.objects.select_related('listing')
        .filter(profile=profile_instance, count__gt=0, listing__is_deleted=False, listing__is_enabled=True)
        .order_by('-count', 'listing__title'))
    listings = [vc.listing for vc in visit_counts]
    listings = storefront_model_access.custom_sort_listings(listings, ordering)

    return listings


def create_or_update_storefront_customization(profile, section, position=None, is_hidden=None, size=None):
    """
    Updates the storefront customization settings for a given profile and section,
    or creates a new one if it doesn't exist
    """
    customizations = profile.storefront_customizations.filter(section=section)

    if customizations.exists():
        customization = customizations.first()
    else:
        customization = models.StorefrontCustomization(profile=profile, section=section)

    if position is not None:
        customization.position = position
    if is_hidden is not None:
        customization.is_hidden = is_hidden
    if size is not None:
        customization.size = size

    return customization.save()


def create_listing_visit_count(profile, listing, count, last_visit_date=None):
    """
    Set initial visit count for a given profile and listing.  Ensures that there is
    only one visit count object per profile/listing combination.
    """
    if not last_visit_date:
        last_visit_date = utils.get_now_utc()

    filtered_counts = models.ListingVisitCount.objects.filter(profile=profile, listing=listing)
    if filtered_counts.count() > 1:
        raise errors.RequestException('Only one visit count object can exist for profile {0} and listing {1}'.format(profile.display_name, listing.title))
    elif filtered_counts.count() == 1:
        return update_listing_visit_count(filtered_counts.first(), count, last_visit_date)
    else:
        visit_count = models.ListingVisitCount(profile=profile, listing=listing)
        visit_count.count = count
        visit_count.last_visit_date = last_visit_date
        visit_count.save()

        return visit_count


def update_listing_visit_count(visit_count, count, last_visit_date=None):
    """
    Update visit count for a given profile and listing.
    """
    if not last_visit_date:
        last_visit_date = utils.get_now_utc()

    visit_count.count = count
    visit_count.last_visit_date = last_visit_date

    visit_count.save()

    return visit_count


def delete_listing_visit_count(visit_count):
    """
    Delete visit count
    """
    visit_count.delete()


def clear_all_listing_visit_counts(current_request_username, profile_id):
    """
    Clear all listing visit counts for a profile_id

    Args:
        current_request_username
        profile_id

    Raises:
        models.Profile.DoesNotExist
    """
    if profile_id == 'self':
        profile_instance = models.Profile.objects.get(user__username=current_request_username)
    else:
        profile_instance = models.Profile.objects.get(id=profile_id)

    visit_counts = models.ListingVisitCount.objects.for_user(current_request_username).filter(profile=profile_instance).update(count=0)

    return visit_counts


def get_profiles_by_role(role):
    """
    Get Profiles by the role and ordered by display_name

    Args:
        role(str): Role of user - USER, ORG_STEWARD..
    """
    return models.Profile.objects.filter(
        user__groups__name__exact=role).order_by('display_name')


def filter_queryset_by_username_starts_with(queryset, starts_with):
    return queryset.filter(user__username__startswith=starts_with)


def get_all_users():
    """
    Get all Users (User Objects)
    """
    return auth.models.User.objects.all()


def get_all_groups():
    """
    Get all groups
    """
    return auth.models.Group.objects.all()
