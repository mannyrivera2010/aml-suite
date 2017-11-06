"""
https://github.com/aml-development/ozp-documentation/wiki/Notifications

Notification Type
    SYSTEM = 'system'  # System-wide Notifications
    AGENCY = 'agency'  # Agency-wide Notifications
    AGENCY_BOOKMARK = 'agency_bookmark'  # Agency-wide Bookmark Notifications # Not requirement (erivera 20160621)
    LISTING = 'listing'  # Listing Notifications
    PEER = 'peer'  # Peer to Peer Notifications
    PEER_BOOKMARK = 'peer_bookmark'  # Peer to Peer Bookmark Notifications
    SUBSCRIPTION = 'subscription' # Category and Tag Subscription Notification

Group Target
    ALL = 'all'  # All users
    STEWARDS = 'stewards'
    APP_STEWARD = 'app_steward'
    ORG_STEWARD = 'org_steward'
    USER = 'user'

=====Notification Type=====

                +--> SystemWide
                |
                +--> AgencyWide
                |
                +--> AgencyWideBookmark
                |
Notification +------+--> Listing
                |   |
                |   +--> ListingReview
                |   |
                |   +--> ListingPrivateStatus
                |   |
                |   +--> PendingDeletionRequest
                |   |
                |   +--> PendingDeletionCancellation
                |   |
                |   +--> ListingSubmission
                |
                +--> Peer
                |
                +--> PeerBookmark
                |
                +--> CategorySubscription
                |
                +--> TagSubscription

=====Vocab=====
Target: is a Profile that should receive a notification
Target List: A list of Profiles that should receive notifications
Direct notification: The notification is produced by an action that the user does.
In-direct Notification: The notification is produced by the observing a user action.
"""
import datetime
import logging
import pytz

from django.db.models import Q
from django.db import transaction

from ozpcenter import errors

from ozpcenter.models import Notification
from ozpcenter.models import NotificationMailBox
from ozpcenter.models import Profile
from ozpcenter.models import Agency
from ozpcenter.models import Listing
from ozpcenter.models import ApplicationLibraryEntry
from ozpcenter.models import Subscription

import ozpcenter.model_access as generic_model_access


logger = logging.getLogger('ozp-center.' + str(__name__))


permission_dict = {
    'APPS_MALL_STEWARD': [
        'add_system_notification',
        'change_system_notification',
        'delete_system_notification',

        'add_agency_notification',
        'change_agency_notification',
        'delete_agency_notification',

        'add_listing_notification',
        'change_listing_notification',
        'delete_listing_notification',

        'add_peer_notification',
        'change_peer_notification',
        'delete_peer_notification',

        'add_peer_bookmark_notification',
        'change_peer_bookmark_notification',
        'delete_peer_bookmark_notification',

        'add_subscription_notification',
        'change_subscription_notification',
        'delete_subscription_notification'
    ],
    'ORG_STEWARD': [
        'add_system_notification',
        'change_system_notification',
        'delete_system_notification',

        'add_agency_notification',
        'change_agency_notification',
        'delete_agency_notification',

        'add_listing_notification',
        'change_listing_notification',
        'delete_listing_notification',

        'add_peer_notification',
        'change_peer_notification',
        'delete_peer_notification',

        'add_peer_bookmark_notification',
        'change_peer_bookmark_notification',
        'delete_peer_bookmark_notification',

        'add_subscription_notification',
        'change_subscription_notification',
        'delete_subscription_notification'
    ],
    'USER': [
        'add_listing_notification',
        'change_listing_notification',
        'delete_listing_notification',

        'add_peer_notification',
        'change_peer_notification',
        'delete_peer_notification',

        'add_peer_bookmark_notification',
        'change_peer_bookmark_notification',
        'delete_peer_bookmark_notification',

        'add_subscription_notification',
        'change_subscription_notification',
        'delete_subscription_notification'
        ]
}


# Method is decorated with @transaction.atomic to ensure all logic is executed in a single transaction
@transaction.atomic
def bulk_notifications_saver(notification_instances):
    # Loop over each store and invoke save() on each entry
    for notification_instance in notification_instances:
        notification_instance.save()


def check_notification_permission(profile_instance, action, notification_type):
    """
    Check to see if user has permission

    Args:
        profile_instance(Profile): Profile Instance
        action(string): add/change/delete
        notification_type(string): notification type
    Return:
        True or PermissionDenied Exception
    """
    profile_role = profile_instance.highest_role()
    assert (profile_role in permission_dict), 'Profile group {} not found in permissions'.format(profile_role)

    user_action = '{}_{}_notification'.format(action, notification_type)

    profile_permission_list = permission_dict[profile_role]

    if user_action not in profile_permission_list:
        raise errors.PermissionDenied('Profile does not have [{}] permissions'.format(user_action))
    return True


class NotificationBase(object):
    """
    Process:
        Init NotificationBase Super Class Object
        Set sender_profile and entities list
        Validate sender_profile and entities list
        Do Global Permission Check

        Notify
            Validate expires_date, message
    """

    def set_sender_and_entity(self, sender_profile_username, entity, metadata=None):
        """
        Set Sender Profile, entity object, metadata

        Args:
            sender_profile_username(string): Sender's Profile username (normally the request profile)
            entity(object):
        """
        assert (sender_profile_username is not None), 'Sender Profile Username is necessary'

        self.sender_profile_username = sender_profile_username
        self.sender_profile = generic_model_access.get_profile(sender_profile_username)
        self.entity = entity
        self.metadata = metadata

    def check_local_permission(self, entity):
        return True

    def permission_check(self):
        """
        Global and Local check
        """
        check_notification_permission(self.sender_profile, 'add', self.get_notification_db_type())
        self.check_local_permission(self.entity)

    def get_notification_db_type(self):
        raise RuntimeError('Not Implemented')

    def get_notification_db_subtype(self):
        raise RuntimeError('Not Implemented')

    def get_target_list(self):
        raise RuntimeError('Not Implemented')

    def get_entity_id(self):
        """
        self.entity is a Model Type Instance if not overrided
        """
        if self.entity:
            return self.entity.id
        else:
            return None

    def get_group_target(self):
        return Notification.ALL

    def modify_notification_before_save(self, notification_object):
        pass

    def generate_model(self, expires_date, message):
        notification = Notification(
            expires_date=expires_date,
            author=self.sender_profile,
            message=message)
        notification_type = self.get_notification_db_type()
        notification.notification_subtype = self.get_notification_db_subtype()
        notification.notification_type = notification_type
        notification.entity_id = self.get_entity_id()
        notification.group_target = self.get_group_target()
        return notification

    def notify(self, expires_date, message):
        assert (expires_date is not None), 'Expires Date is necessary'
        assert (message is not None), 'Message is necessary'
        self.permission_check()

        notification = self.generate_model(expires_date, message)
        self.modify_notification_before_save(notification)

        notification.save()

        target_list = self.get_target_list()

        bulk_notification_list = []

        for target_profile in target_list:
            notificationv2 = NotificationMailBox()
            notificationv2.target_profile = target_profile
            notificationv2.notification = notification
            # All the flags default to false
            notificationv2.emailed_status = False

            bulk_notification_list.append(notificationv2)

            if len(bulk_notification_list) >= 2000:
                bulk_notifications_saver(bulk_notification_list)
                bulk_notification_list = []

        if bulk_notification_list:
            bulk_notifications_saver(bulk_notification_list)

        return notification


class SystemWideNotification(NotificationBase):
    """
    AMLNG-395 - SystemWide
        As a user, I want to receive System-Wide Notifications
    Targets: All Users
    Permission Constraint: Only APP_MALL_STEWARDs can send notifications
    Invoked: Directly
    """

    def get_notification_db_type(self):
        return Notification.SYSTEM

    def get_notification_db_subtype(self):
        return None

    def get_target_list(self):
        """
        Get every profile
        """
        return Profile.objects.all()


class AgencyWideNotification(NotificationBase):
    """
    AMLNG-398 - AgencyWide
        As a user, I want to receive Agency-Wide Notifications
    Targets: All Users in an agency
    Permission Constraint: Only APP_MALL_STEWARDs, ORG_STEWARDs can send notifications
    Invoked: Directly
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.agency = self.entity

    def get_notification_db_type(self):
        return Notification.AGENCY

    def get_notification_db_subtype(self):
        return None

    def get_target_list(self):
        """
        Get every profile that belongs to an organization and get all stewards for that organization
        """
        return Profile.objects.filter(Q(organizations__in=[self.entity]) |
                                      Q(stewarded_organizations__in=[self.entity])).all()


class AgencyWideBookmarkNotification(NotificationBase):
    """
    AMLNG-398 - AgencyWide Bookmark
        As a user, I want to receive Agency-Wide Notifications
    Targets: All Users in an agency
    Permission Constraint: Only APP_MALL_STEWARDs, ORG_STEWARDs can send notifications
    Invoked: Directly
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.agency = self.entity

    def get_notification_db_type(self):
        return Notification.AGENCY_BOOKMARK

    def get_notification_db_subtype(self):
        return None

    def get_target_list(self):
        """
        Get every profile that belongs to an organization and get all stewards for that organization
        """
        return Profile.objects.filter(Q(organizations__in=[self.entity]) |
                                      Q(stewarded_organizations__in=[self.entity])).all()


class ListingNotification(NotificationBase):
    """
    AMLNG-396 - Listing Notifications
    Targets: All users that bookmarked listing
    Permission Constraint: Only APP_MALL_STEWARDs and ORG_STEWARDs or owners of listing can send notifications
    Invoked: Directly
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.LISTING

    def get_notification_db_subtype(self):
        return None

    def get_target_list(self):
        """
        Get every profile that has bookmarked that listing
        """
        owner_id_list = ApplicationLibraryEntry.objects.filter(listing__in=[self.entity],
                                                               listing__isnull=False,
                                                               listing__approval_status=Listing.APPROVED,
                                                               listing__is_deleted=False).values_list('owner', flat=True).distinct()
        return Profile.objects.filter(id__in=owner_id_list, listing_notification_flag=True).all()

    def check_local_permission(self, entity):
        if self.sender_profile.highest_role() in ['APPS_MALL_STEWARD', 'ORG_STEWARD']:
            return True

        if self.sender_profile not in entity.owners.all():
            raise errors.PermissionDenied('Cannot create a notification for a listing you do not own')
        else:
            return True
        return False


class PeerNotification(NotificationBase):
    """
    Peer
        As a user, I want to receive notification when someone send a message to me
    Targets: User Given Target
    Permission Constraint:
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.peer = self.metadata

    def get_notification_db_type(self):
        return Notification.PEER

    def get_notification_db_subtype(self):
        return None

    def get_group_target(self):
        return Notification.USER

    def get_target_list(self):
        entities_id = [entity.id for entity in [self.entity]]
        return Profile.objects.filter(id__in=entities_id).all()


class PeerBookmarkNotification(NotificationBase):
    """
    AMLNG-381 - PeerBookmark
        As a user, I want to receive notification when someone shares a folder with me
    Targets: User Given Target
    Permission Constraint:  Must be owner of shared folder to send

    Test Case:
        Logged on as jones
        Shared a folder with aaronson
        Logged on as aaronson
        RESULTS: aaronson has a new notification added to the notification count.Add folder button is present and adds the shared folder to HuD screen.
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.peer = self.metadata

    def get_notification_db_type(self):
        return Notification.PEER_BOOKMARK

    def get_notification_db_subtype(self):
        return None

    def get_group_target(self):
        return Notification.USER

    def get_target_list(self):
        entities_id = [entity.id for entity in [self.entity]]
        return Profile.objects.filter(id__in=entities_id).all()


class ListingReviewNotification(NotificationBase):  # Not Verified
    """
    AMLNG-377 - ListingReview
        As an owner or CS, I want to receive notification of user rating and reviews
    Targets: Users that ___
    Invoked: In-directly

    Test Case:
        Description - Verify the CS and listing owner receives a notification when the review is added or modified.
        *Pre-req*- Add aaronson as listing owner to Airmail.
        Log on as syme (minipax)
        Deleted, Added and Modified review on Airmail ( minitru)
        Log on as wsmith (minitru-org steward)
        EXPECTED RESULTS - At least two notifications should display for wsmith.
        Log on as aaronson
        EXPECTED RESULTS - At least two notifications should display for aaronson.
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.LISTING

    def get_notification_db_subtype(self):
        return Notification.LISTING_REVIEW

    def get_group_target(self):
        return Notification.USER

    def get_target_list(self):
        current_listing = self.entity

        target_set = set()

        for owner in current_listing.owners.filter(listing_notification_flag=True).all():
            target_set.add(owner)

        current_listing_agency_id = current_listing.agency.id

        for steward in Profile.objects.filter(stewarded_organizations__in=[current_listing_agency_id], listing_notification_flag=True).all():
            target_set.add(steward)

        return list(target_set)


class ListingOwnerNotification(NotificationBase):  # Not Verified
    """
    AMLNG-??? - ListingOwner
        As an user, I want to send a notification to the owners and org_steward for that listing's agency
    Targets: owners and org_steward for that listing's agency
    Invoked: Directly
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.LISTING

    def get_group_target(self):
        return Notification.USER

    def get_target_list(self):
        current_listing = self.entity

        target_set = set()

        for owner in current_listing.owners.filter(listing_notification_flag=True).all():
            target_set.add(owner)

        current_listing_agency_id = current_listing.agency.id

        for steward in Profile.objects.filter(stewarded_organizations__in=[current_listing_agency_id], listing_notification_flag=True).all():
            target_set.add(steward)

        return list(target_set)


class ListingPrivateStatusNotification(NotificationBase):
    """
    AMLNG-383 - ListingPrivateStatus
        As a owner, I want to notify users who have bookmarked my listing when the
        listing is changed from public to private and vice-versa
    Permission Constraint: Only APP_MALL_STEWARDs and ORG_STEWARDs or owners of listing can
    Targets: Users that bookmarked listing
    Invoked: In-directly

    Test Case:
        Bookmarked an app listing in my own org
        Went to Bookmarked App Listing Quick View Modal | Send Notifications | Sent a notification
        RESULTS - I received the notification
        Bookmarked an app listing that did not belong to the org I was in
        Went to Bookmarked App Listing  Quick View Modal | Send Notifications | Sent a notification
        RESULTS - I received the notification
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.LISTING

    def get_notification_db_subtype(self):
        return Notification.LISTING_PRIVATE_STATUS

    def get_target_list(self):
        owner_id_list = ApplicationLibraryEntry.objects.filter(listing__in=[self.entity],
                                                               listing__isnull=False,
                                                               listing__approval_status=Listing.APPROVED,
                                                               listing__is_enabled=True,
                                                               listing__is_deleted=False).values_list('owner', flat=True).distinct()
        return Profile.objects.filter(id__in=owner_id_list, listing_notification_flag=True).all()

    def check_local_permission(self, entity):
        if self.sender_profile.highest_role() in ['APPS_MALL_STEWARD', 'ORG_STEWARD']:
            return True

        if self.sender_profile not in entity.owners.all():
            raise errors.PermissionDenied('Cannot create a notification for a listing you do not own')
        else:
            return True
        return False


class PendingDeletionRequestNotification(NotificationBase):  # Not Verified
    """
    AMLNG-170 - PendingDeletionRequest
        As an Owner I want to receive notice of whether my deletion request has been approved or rejected
    Targets: Users that ___
    Invoked: In-directly

    This event occurs when
        Listing DELETED - Steward approved deletion
            PENDING_DELETION --> DELETED

        User undeleted the listing - Steward rejects deletion
            PENDING_DELETION --> PENDING

    Test Case:
        Logged on as jones
        Set Test Notification Listing to Pend for Deletion state
        Logged on as minitrue Org Content Steward- julia
        Approved the deletion
        Logged on as jones
        RESULTS The notification launched = Test Notification Listing listing was approved for deletion by steward
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.LISTING

    def get_notification_db_subtype(self):
        return Notification.PENDING_DELETION_REQUEST

    def get_target_list(self):
        current_listing = self.entity
        return current_listing.owners.filter(listing_notification_flag=True).all().distinct()


class PendingDeletionCancellationNotification(NotificationBase):  # Not Verified
    """
    AMLNG-173 - PendingDeletionCancellation
        As an cs I want a notification if an owner has cancelled an app
        that was pending deletion

    This event occurs when
        User undeleted the listing
            PENDING_DELETION --> PENDING

    Test Case:
        Set Test Notification Listing to Pend for Deletion Status
        Logged on as jones ( owner of <Test Notification> Listing)
        Undeleted the Test Notification Listing
        Logged on as Org Content Steward - julia
        RESULTS - Notificaiton launched = Listing Owner cancelled deletion of Test Notification Listing listing
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.LISTING

    def get_notification_db_subtype(self):
        return Notification.PENDING_DELETION_CANCELLATION

    def get_target_list(self):
        current_listing = self.entity
        current_listing_agency_id = current_listing.agency.id
        return Profile.objects.filter(stewarded_organizations__in=[current_listing_agency_id], listing_notification_flag=True).all().distinct()


class ListingSubmissionNotification(NotificationBase):
    """
    AMLNG-376 - ListingSubmission
        As a CS, I want to receive notification of Listings submitted for my organization
    Targets: Listing Agency ORG_STEWARDs
    Invoked: In-directly

    This event occurs when
        User Submitted Listings
            IN_PROGRESS --> PENDING

    a = Listing.objects.last(); a.approval_status = Listing.IN_PROGRESS; a.save()

    Test Case:
        Logged into Apps Mall as jones ( minitrue)
        Submitted a new listing using org minitrue.
        Logged into Apps mall as CS - julia (minitrue)
        RESULTS - Notification displays = Test Notification Listing listing was submitted
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_group_target(self):
        return Notification.ORG_STEWARD

    def get_notification_db_type(self):
        return Notification.LISTING

    def get_notification_db_subtype(self):
        return Notification.LISTING_NEW

    def get_target_list(self):
        current_listing = self.entity
        current_listing_agency_id = current_listing.agency.id
        return Profile.objects.filter(stewarded_organizations__in=[current_listing_agency_id], listing_notification_flag=True).all().distinct()


class TagSubscriptionNotification(NotificationBase):  # Not Verified
    """
    AMLNG-392 - TagSubscription
        As a user, I want to receive notification when a Listing is added to a subscribed tag
    Targets: Users that ___
    Invoked: In-directly
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.SUBSCRIPTION

    def get_notification_db_subtype(self):
        return Notification.SUBSCRIPTION_TAG

    def get_target_list(self):
        subscription_entries = Subscription.objects.filter(entity_type='tag', entity_id__in=list(self.metadata))
        target_profiles = set()
        for subscription_entry in subscription_entries:
            target_profile = subscription_entry.target_profile
            if target_profile.subscription_notification_flag:
                target_profiles.add(target_profile)

        return list(target_profiles)


class CategorySubscriptionNotification(NotificationBase):  # Not Verified
    """
    AMLNG-380 - CategorySubscription
        As a user, I want to receive notification when a Listing is added to a subscribed category
    Targets: Users that are subscribed to category
    Invoked: In-directly
        Should occur when a user submits a listing with a category and listing gets approved,
            it should send out notifications for users that have that category subscribed and has the Subscription Preference Flag to True
        Should occur when a published listing add new category,
            it should send out notifications for users that have that category subscribed and has the Subscription Preference Flag to True

    Test Case:
        Logged on as jones
        Subscribed to Finance
        Logged on as big brother
        Add any Listing to Finance
        Logged on as jones
        RESULTS- Notification "A new listing in category Finance"
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.SUBSCRIPTION

    def get_notification_db_subtype(self):
        return Notification.SUBSCRIPTION_CATEGORY

    def get_target_list(self):
        subscription_entries = Subscription.objects.filter(entity_type='category', entity_id__in=list(self.metadata))
        target_profiles = set()
        for subscription_entry in subscription_entries:
            target_profile = subscription_entry.target_profile
            if target_profile.subscription_notification_flag:
                target_profiles.add(target_profile)

        return list(target_profiles)


class StewardAppNotification(NotificationBase):
    """
    AMLNG-745 - Listing Review Notification
    Targets: All ORG_STEWARDS
    Permission Constraint: Only APP_MALL_STEWARDs can send notifications
    Invoked: Directly
    """

    def modify_notification_before_save(self, notification_object):
        notification_object.listing = self.entity

    def get_notification_db_type(self):
        return Notification.SYSTEM

    def get_notification_db_subtype(self):
        return Notification.REVIEW_REQUEST

    def get_group_target(self):
        return Notification.ORG_STEWARD

    def get_target_list(self):

        target_set = set()
        agencies = Agency.objects.all()
        for steward in Profile.objects.filter(stewarded_organizations__in=agencies, listing_notification_flag=True).all():
            target_set.add(steward)

        return list(target_set)
