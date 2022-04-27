"""
Observers
"""
import logging
import datetime
import pytz

from rest_framework import serializers


from django.conf import settings
from amlcenter import models
from amlcenter.pubsub import Observer
from amlcenter.models import Notification
import amlcenter.api.notification.model_access as notification_model_access
from amlcenter.api.listing import elasticsearch_util


logger = logging.getLogger('aml-center.' + str(__name__))


class ReadOnlyListingSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Listing
        depth = 2
        fields = '__all__'


class ListingObserver(Observer):

    def events_to_listen(self):
        return ['listing_created',
                'listing_enabled_status_changed',
                'listing_approval_status_changed',
                'listing_private_status_changed',
                'listing_review_created',
                'listing_review_changed',
                'listing_categories_changed',
                'listing_tags_changed',
                'listing_changed']

    def execute(self, event_type, **kwargs):
        logger.debug('ListingObserver: event_type:{}, kwards:{}'.format(event_type, kwargs))

    def listing_approval_status_changed(self, listing=None, profile=None, old_approval_status=None, new_approval_status=None):
        """
        Listing Approval Status Change

        State Transitions:
            {Action}
                {old_approval_status} --> {new_approval_status}

            User Submitted Listings
                IN_PROGRESS --> PENDING

            User put Listing in deletion pending
                PENDING --> PENDING_DELETION
                APPROVED --> PENDING_DELETION

            User undeleted the listing
                PENDING_DELETION --> PENDING

            Org Steward APPROVED listing
                PENDING --> APPROVED_ORG

            App Mall Steward Rejected Listing
                APPROVED_ORG --> REJECTED

            App Mall Steward Approved Lising
                APPROVED_ORG --> APPROVED

            Listing DELETED - Steward Approved deletion
                PENDING_DELETION --> DELETED
                APPROVED --> DELETED

        AMLNG-170 - As an Owner I want to receive notice of whether my deletion request has been approved or rejected
        AMLNG-173 - As an Admin I want notification if an owner has cancelled an app that was pending deletion
        AMLOS-490 - As an Org Steward or Admin, I want to receive a notification when a listing is submitted to pending deletion

        AMLNG-380 - As a user, I want to receive notification when a Listing is added to a subscribed category
        AMLNG-392 - As a user, I want to receive notification when a Listing is added to a subscribed tag

        Args:
            listing: Listing instance
            profile(Profile Instance): Profile that triggered a change
            approval_status(String): Status
        """
        username = profile.user.username
        now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)

        # AMLNG-380/AMLNG-392
        # APPROVED_ORG --> APPROVED
        if (old_approval_status == models.Listing.APPROVED_ORG and
                new_approval_status == models.Listing.APPROVED):
            self.listing_categories_changed(listing=listing, profile=profile, old_categories=[], new_categories=listing.categories.all())
            self.listing_tags_changed(listing=listing, profile=profile, old_tags=[], new_tags=listing.tags.all())

        # AMLNG-376 - ListingSubmission
        if (old_approval_status == models.Listing.IN_PROGRESS and
                new_approval_status == models.Listing.PENDING):
            message = 'The <b>{}</b> listing was submitted'.format(listing.title)
            notification_model_access.create_notification(author_username=username,
                                                          expires_date=now_plus_month,
                                                          message=message,
                                                          listing=listing,
                                                          group_target=Notification.ORG_STEWARD,
                                                          notification_type='ListingSubmissionNotification')

        # AMLNG-173 - PendingDeletionCancellation
        if profile in listing.owners.all():  # Check to see if current profile is owner of listing
            if (new_approval_status == models.Listing.PENDING_DELETION):
                message = 'The <b>{}</b> listing was submitted for deletion by its owner'.format(listing.title)
                notification_model_access.create_notification(author_username=username,
                                                              expires_date=now_plus_month,
                                                              message=message,
                                                              listing=listing,
                                                              group_target=Notification.ORG_STEWARD,
                                                              notification_type='PendingDeletionToStewardNotification')

            if (old_approval_status == models.Listing.PENDING_DELETION and
                    new_approval_status == models.Listing.PENDING):
                message = 'A Listing Owner cancelled the deletion of the <b>{}</b> listing. This listing is now awaiting organizational approval'.format(listing.title)
                notification_model_access.create_notification(author_username=username,
                                                              expires_date=now_plus_month,
                                                              message=message,
                                                              listing=listing,
                                                              group_target=Notification.ORG_STEWARD,
                                                              notification_type='PendingDeletionToStewardNotification')

        # AMLNG-170 - PendingDeletionRequest
        elif profile.highest_role() in ['APPS_MALL_STEWARD', 'ORG_STEWARD']:
            if (old_approval_status == models.Listing.PENDING_DELETION and
                    new_approval_status == models.Listing.DELETED):
                message = 'The <b>{}</b> listing was approved for deletion by an Organization Steward'.format(listing.title)

                notification_model_access.create_notification(author_username=username,
                                                              expires_date=now_plus_month,
                                                              message=message,
                                                              listing=listing,
                                                              group_target=Notification.USER,
                                                              notification_type='PendingDeletionApprovedNotification')

            if (old_approval_status == models.Listing.PENDING_DELETION and
                    new_approval_status == models.Listing.PENDING):
                message = 'The <b>{}</b> listing was undeleted by an Organization Steward'.format(listing.title)

                notification_model_access.create_notification(author_username=username,
                                                              expires_date=now_plus_month,
                                                              message=message,
                                                              listing=listing,
                                                              group_target=Notification.USER,
                                                              notification_type='PendingDeletionToOwnerNotification')

            if (old_approval_status == models.Listing.PENDING_DELETION and
                    new_approval_status == models.Listing.REJECTED):
                message = 'The <b>{}</b> listing was rejected for deletion by an Organization Steward'.format(listing.title)

                notification_model_access.create_notification(author_username=username,
                                                              expires_date=now_plus_month,
                                                              message=message,
                                                              listing=listing,
                                                              group_target=Notification.USER,
                                                              notification_type='PendingDeletionToOwnerNotification')

    def listing_categories_changed(self, listing=None, profile=None, old_categories=None, new_categories=None):
        """
        AMLNG-380 - As a user, I want to receive notification when a Listing is added to a subscribed category

        Args:
            listing: Listing instance
            profile(Profile Instance): Profile that triggered a change
            old_categories: List of category instances
            new_categories: List of category instances
        """
        if listing.approval_status == models.Listing.APPROVED:
            username = profile.user.username
            now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)

            old_categories_set = set(old_categories)
            new_categories_set = set(new_categories)
            new_categories_diff = set()
            for new_category in new_categories_set:
                if new_category not in old_categories_set:
                    new_categories_diff.add(new_category)

            for current_category in new_categories_diff:
                message = 'A new listing, <b>{}</b>, is available in the category <i>{}</i>'.format(listing.title, current_category)

                notification_model_access.create_notification(author_username=username,
                                                              expires_date=now_plus_month,
                                                              message=message,
                                                              listing=listing,
                                                              entities=[current_category.id],
                                                              notification_type='CategorySubscriptionNotification')

    def listing_tags_changed(self, listing=None, profile=None, old_tags=None, new_tags=None):
        """
        AMLNG-392 - As a user, I want to receive notification when a Listing is added to a subscribed tag

        Args:
            listing: Listing instance
            profile(Profile Instance): Profile that triggered a change
            old_tags: List of Tag instances
            new_tags: List of Tag instances
        """
        if listing.approval_status == models.Listing.APPROVED:
            username = profile.user.username
            now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)

            old_tags_set = set(old_tags)
            new_tags_set = set(new_tags)
            new_tags_diff = set()
            for new_tag in new_tags_set:
                if new_tag not in old_tags_set:
                    new_tags_diff.add(new_tag)

            for current_tag in new_tags_diff:
                message = 'A new listing, <b>{}</b>, is available in the tag <i>{}</i>'.format(listing.title, current_tag)

                notification_model_access.create_notification(author_username=username,
                                                              expires_date=now_plus_month,
                                                              message=message,
                                                              listing=listing,
                                                              entities=[current_tag.id],
                                                              notification_type='TagSubscriptionNotification')

    def listing_created(self, listing=None, profile=None):
        """
        Args:
            listing: Listing Instance
            user(Profile Instance): The user that created listing
        """
        pass

    def listing_changed(self, listing=None, profile=None, change_details=None):
        """
        AMLNG-378 - As a user, I want to receive notification about changes on Listings I've bookmarked

        Args:
            listing: Listing Instance
            user(Profile Instance): The user that created listing
        """
        username = profile.user.username
        ignoreFields = ['doc_urls',
                        'banner_icon',
                        'large_banner_icon',
                        'small_icon',
                        'large_icon',
                        'screenshots',
                        'security_marking',
                        'is_featured',
                        'owners',
                        'contacts']

        changes = []

        for change_detail in change_details:
            if not (change_detail['field_name'] in ignoreFields):
                changes.append(change_detail['field_name'].title().replace('_', ' '))

        # Notifications with html markup will display with the change in
        # ActiveNotification.jsx using dangerouslySetInnerHTML.
        if changes:
            message = 'The <b>{}</b> listing was updated. The following field{} changed: {}'.format(
                listing.title,
                's have' if len(change_details) != 1 else ' has',
                ', '.join(changes)
                )

            now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)
            notification_model_access.create_notification(author_username=username,
                                                          expires_date=now_plus_month,
                                                          message=message,
                                                          listing=listing,
                                                          group_target=Notification.USER)

        if settings.ES_ENABLED is True:
            serializer = ReadOnlyListingSerializer(listing)
            record = serializer.data  # TODO Find a faster way to serialize data, makes test take a long time to complete

            elasticsearch_util.update_es_listing(record['id'], record, None)

    def listing_review_created(self, listing=None, profile=None, rating=None, text=None):
        """
        AMLNG- 377 - As an owner or CS, I want to receive notification of user rating and reviews

        Args:
            listing: Listing instance
        """
        username = profile.user.username
        now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)

        message = 'A user has rated listing <b>{}</b> {} star{}'.format(
            listing.title,
            rating,
            's' if rating != 1 else ''
            )

        notification_model_access.create_notification(author_username=username,
                                                      expires_date=now_plus_month,
                                                      message=message,
                                                      listing=listing,
                                                      notification_type='ListingReviewNotification')

    def listing_review_changed(self, listing=None, profile=None, rating=None, text=None):
        """
        AMLNG- ??? - As an owner or CS, I want to receive notification of user rating and reviews

        Args:
            listing: Listing instance
        """
        username = profile.user.username
        now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)

        message = 'A user has changed the rating for listing <b>{}</b> to {} star{}'.format(
            listing.title,
            rating,
            's' if rating != 1 else ''
            )

        notification_model_access.create_notification(author_username=username,
                                                      expires_date=now_plus_month,
                                                      message=message,
                                                      listing=listing,
                                                      notification_type='ListingReviewNotification')

    def listing_private_status_changed(self, listing=None, profile=None, is_private=None):
        """
        AMLNG-383 - As a owner, I want to notify users who have bookmarked my listing when the
            listing is changed from public to private and vice-versa

        Args:
            listing: Listing instance
            profile(Profile Instance): Profile that triggered a change ()
            is_private: boolean value
        """
        username = profile.user.username
        message = None

        if is_private:
            message = '<b>{}</b> was changed to be a private listing '.format(listing.title)
        else:
            message = '<b>{}</b> was changed to be a public listing '.format(listing.title)

        now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)
        notification_model_access.create_notification(author_username=username,
                                                      expires_date=now_plus_month,
                                                      message=message,
                                                      listing=listing,
                                                      group_target=Notification.USER)

    def listing_enabled_status_changed(self, listing=None, profile=None, is_enabled=None):
        """
        Args:
            listing: Listing instance
            profile(Profile Instance): Profile that triggered a change
            is_enabled: boolean value
        """
        username = profile.user.username

        message = None

        if is_enabled:
            message = '<b>{}</b> was changed to be enabled '.format(listing.title)
        else:
            message = '<b>{}</b> was changed to be disabled '.format(listing.title)

        now_plus_month = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=30)
        notification_model_access.create_notification(author_username=username,
                                                      expires_date=now_plus_month,
                                                      message=message,
                                                      listing=listing,
                                                      group_target=Notification.USER)
