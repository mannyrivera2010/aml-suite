# Purpose
Notifications are system-provided messages that deploy to each relevant individual user. The intent is for Notifications to be available to be sent from the system, from any individual organization, or from an application.

# Requirements
Existing Issues in github:  https://github.com/aml-development/ozp-backend/issues?utf8=%E2%9C%93&q=is%3Aissue%20notification


## Notification types
* User Triggered  
  * System-wide
  * Agency-wide
  * Listing
  * Peer-to-peer bookmark
* System Triggered
  * deletion management (Agency-wide Org Steward) **Proposed**
  * tags/categories subscription **Proposed**  

### Permissions
APPS_MALL_STEWARD
* add_system_notification
* change_system_notification
* delete_system_notification
* add_agency_notification
* change_agency_notification
* delete_agency_notification
* add_listing_notification
* change_listing_notification
* delete_listing_notification
* add_peer_notification
* change_peer_notification
* delete_peer_notification
* add_peer_bookmark_notification
* change_peer_bookmark_notification
* delete_peer_bookmark_notification

ORG_STEWARD
* add_system_notification
* change_system_notification
* delete_system_notification
* add_agency_notification
* change_agency_notification
* delete_agency_notification
* add_listing_notification
* change_listing_notification
* delete_listing_notification
* add_peer_notification
* change_peer_notification
* delete_peer_notification
* add_peer_bookmark_notification
* change_peer_bookmark_notification
* delete_peer_bookmark_notification

USER
* add_listing_notification
* change_listing_notification
* delete_listing_notification
* add_peer_notification
* change_peer_notification
* delete_peer_notification
* add_peer_bookmark_notification
* change_peer_bookmark_notification
* delete_peer_bookmark_notification

### Rules:
* Only APPS_MALL_STEWARD can create system-wide notifications
  * PermissionDenied('Only app mall stewards can create system notifications')
* Only ORG_STEWARD can create agency-wide notifications
  * PermissionDenied('Only org stewards can create agency notifications')
* Only Listing Owner can create Listing notifications
  * PermissionDenied('Cannot create a notification for a listing you do not own')

## Receiving Notifications
* For the system messages, every user should receive the notification.
* For the organizations' messages (agency-wide), every user associated with the organization should receive the notification.
* For the applications/listings, every user who has bookmarked the listing should receive the notification.

## Sending Notifications
* Owners of listings will be able to send messages only from their listing. These messages will need to be approved by a Steward of the listing's associated organization and then by a Marketplace Steward.
* Organization Stewards will be able to send messages from their organization or any listing associated with their organization.
* Marketplace Stewards will be able to send messages from the system, an organization, or any listing. These messages will not need to be approved by any other Steward.

### System-Wide Request
````
POST /api/notification/ HTTP/1.1
Request Payload:
{
  "expires_date": "2016-06-17T06:30:00.000Z",
  "message": "Test"
}
````
### Agency-wide
````
POST /api/notification/ HTTP/1.1
Request Payload:
{
  "expires_date": "2016-06-17T06:30:00.000Z",
  "message": "Test",
  "agency": {
    "id": 5
 }
}
````
### Listing-wide
````
POST /api/notification/ HTTP/1.1
Request Payload:
{
  "expires_date": "2016-06-17T06:30:00.000Z",
  "message": "Test",
  "listing": {
    "id": 5
 }
}
````
### Peer to Peer Bookmark
````
POST /api/notification/ HTTP/1.1
Request Payload:
{
  "expires_date": "2016-06-17T06:30:00.000Z",
  "message": "Test",
  "peer": {
    "user": {
      "username": "bigbrother"
    },
    "folder_name": "folder1"
  }
}
````



## Authorization
* Any User can view a System-wide notification from the system.
* Only user authorized should be able to delete the notifications.

**Related Issues:**
https://github.com/aml-development/ozp-backend/issues/122

## Protocol
  * Shall be possible to have notifications in JSON Formats and over HTTP/HTTPS transports

## Sorting Notification
**Usage:**
Default response is Descending    
```
GET /api/self/notification/?ordering=-created_date   # Descending
or
GET /api/self/notification/?ordering=created_date  # Ascending
```
https://github.com/aml-development/ozp-backend/issues/160

## 2017 Redesign
### Goal
Propose redesign of back-end architecture to inbox style (beneficial to use a task manager like celery)   

### Backlog
"As developer, propose redesign of back-end architecture to create a solution that provides capabilities to manage current, proposed and future notification requirements."    

**Email**    
The notification system shall integrate with email system

### Proposed Solution    
* Mailbox style, Every user will have an inbox.   
* When a system wide notification occurs, it will make a list of all users in the system and put a message in the 'inbox'  of each user
* When a listing notification occurs, it will make a list of all users that has a listing bookmark and put a message in the 'inbox'  of each user
* When an agency-wide notification occurs, it will make a list of all user in that agency and put a message in the 'inbox' of each user
* When a peer-to-peer bookmark notification occurs
  * https://github.com/aml-development/ozp-backend/issues/129
* Pub/Sub Events system for system actions events (Category Notification)

## Research
* https://github.com/mcomp2010-forks/Stream-Framework    
* http://highscalability.com/blog/2013/7/8/the-architecture-twitter-uses-to-deal-with-150m-active-users.html
* http://www.slideshare.net/rabbitmq/why-databases-suck-for-messaging

### Steps
* Create new Model for redesigned Notification
* Iterate thorough all the current Notifications and put in new Notification Model
* Refactor All the Notification methods to use new Notification Model

## User-Stories
### req-173
**Date Created:** Dec 06, 2016    
**Description**    
As an admin I want notification if an owner has cancelled an app that was pending deletion   

**Message Text:**  {owner.username} cancelled {app.name} that was pending deletion

### req-170
**Date Created:** Dec 06, 2016    
**Description**    
As an Owner I want to receive notice of whether my deletion request has been approved or rejected  

**Message Text:**  {app.name} pending deletion was {approved||rejected}

### req-376
**Date Created:** March 16, 2017    
**Description**    
As a CS, I want to receive notification of Listings submitted for my organization

**Message Text:**  {owner.username} submitted a application listing for submission - {listing.title}

### req-377
**Date Created:** March 16, 2017    
**Description**    
As an owner and CS, I want to receive notification of user rating and reviews

**Message Text:**  {listing.title} had a review

**Pseudocode Steps**    
* When model_access.create_listing_review executes publish 'listing_reviewed' event with [listing, rate].   
* The observer of 'review_listing' event will create a Listing Notification targeted to Listings Owners and Listings Agency Org Stewards

### req-379
**Date Created:** March 17, 2017    
**Description**    
As a user, I want to receive notification when Listings I've bookmarked are changed to private

**Message Text:**  {listing.title} was changed to be private

**Pseudocode Steps**    
* When ListingSerializer.update function execute and if listing.is_private changes publish 'listing_is_private_changed' event with [listing, is_private].
* The observer of 'listing_is_private_changed' event will create a Listing Notification targeted to users that bookmarked listing

### req-383
**Date Created:** March 17, 2017    
**Description**    
As a owner, I want to be able to notify users when my Listing is changed from public to private and vice-versa

**Message Text:**  {listing.title} was changed to be {private||public}

**Related to**  req-379

### req-378
**Date Created:** March 17, 2017    
**Description**    
As a user, I want to receive notification about changes on Listings I've bookmarked

**Question:**    
What does changes mean


### req-380
**Date Created:** March 17, 2017    
**Description**    
As a user, I want to receive notification when a Listing is added to a subscribed category or tag  

### req-381
**Date Created:** March 17, 2017    
**Description**    
As a user, I want to receive notification when someone shares a folder with me

### req-382
**Date Created:** March 17, 2017    
**Description**    
As a user, owner or CS, I want the ability to configure notification settings/preferences

### req-384
**Date Created:** March 17, 2017    
**Description**    
As a owner, I want myself and CS to be notified when one of the Listing owner’s certificate expires

## Software Code
### Current Endpoints/Views:
* /api/self/notification/
  * UserNotificationViewSet
* /api/notifications/
  * NotificationViewSet
* /api/notifications/pending/
  * PendingNotificationView
* /api/notifications/expired/
  * ExpiredNotificationView

### Methods
* Get all notifications
* Get all pending notifications
* Get all expired notifications
* Create a Notification
* Delete/Dismiss a notifications
* Get notifications for a user
  * Sort by date
* Update notifications Expired Date
* Email Batch
  * When email_batch command occurs, it will go to every users' 'mailbox' to check if email_status on the notification is false, do the count, make value true, and email user the new notification count and telling them to login.

### Model
**Current Model**
```python
class Notification(models.Model):
    """
    Setter for peer variable
    {
        'user': {
        'username': str
        },
        '_bookmark_listing_ids': list[int],
        'folder_name': str
    }
    """
    created_date = models.DateTimeField(default=utils.get_now_utc)
    message = models.CharField(max_length=4096)
    expires_date = models.DateTimeField()
    author = models.ForeignKey(Profile, related_name='authored_notifications')
    dismissed_by = models.ManyToManyField(
        'Profile',
        related_name='dismissed_notifications',
        db_table='notification_profile'
    )
    listing = models.ForeignKey(Listing, related_name='notifications',
                                null=True, blank=True)
    agency = models.ForeignKey(Agency, related_name='agency_notifications',
                               null=True, blank=True)
    _peer = models.CharField(max_length=4096, null=True, blank=True, db_column='peer')

    def notification_type(self):
        """
        Dynamically figure out Notification Type

        Types:
            SYSTEM - System-wide Notifications
            AGENCY - Agency-wide Notifications
            AGENCY.BOOKMARK - Agency-wide Bookmark Notifications # Not requirement (erivera 20160621)
            LISTING - Listing Notifications
            PEER - Peer to Peer Notifications
            PEER.BOOKMARK - Peer to Peer Bookmark Notifications
        """
```
**Redesign Model**
```python

class NotificationV2(models.Model):
    # Mailbox Profile ID
    profile_target_id = models.ForeignKey(Profile, related_name='mailbox_notifications')

    # It is a unique id for notifications that allow to correlate between different 'mailboxes'
    # Example) For deleting system-wide notifications,
    #    for every 'mailbox' delete the notification with notification_id
    notification_id = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)

    created_date = models.DateTimeField(default=utils.get_now_utc)
    expires_date = models.DateTimeField()

    # Author of Notification
    author = models.ForeignKey(Profile, related_name='authored_notificationsv2')
    message = models.CharField(max_length=4096)

    # Notification Type
    SYSTEM = 'system'  # System-wide Notifications
    AGENCY = 'agency'  #   Agency-wide Notifications
    AGENCY_BOOKMARK = 'agency_bookmark'  #  Agency-wide Bookmark Notifications # Not requirement (erivera 20160621)
    LISTING = 'listing'  # Listing Notifications
    PEER = 'peer'  # Peer to Peer Notifications
    PEER_BOOKMARK = 'peer_bookmark'  # PEER.BOOKMARK - Peer to Peer Bookmark Notifications

    NOTIFICATION_TYPE_CHOICES = (
        (SYSTEM, 'system'),
        (AGENCY, 'agency'),
        (AGENCY_BOOKMARK, 'agency_bookmark'),
        (LISTING, 'listing'),
        (PEER, 'peer'),
        (PEER_BOOKMARK, 'peer_bookmark'),
    )

    notification_type = models.CharField(max_length=24, choices=NOTIFICATION_TYPE_CHOICES, db_index=True)

    # Depending on notification_type, it could be listing_id/agency_id/profile_user_id/category_id/tag_id
    entity_id  = models.IntegerField(default=0, null=True, blank=True)

    # If it has been emailed. then make value true
    email_status = models.BooleanField(default=False)

    # Field use to store extra data.
    # For PEER.BOOKMARK Notifications this field will be use to store FolderName and Listing Ids
    _metadata = models.CharField(max_length=4096, null=True, blank=True, db_column='metadata')

    # User Target
    ALL = 'all'  # All users
    STEWARDS = 'stewards'
    APP_STEWARD = 'app_steward'
    ORG_STEWARD = 'org_steward'
    USER = 'user'

    TARGET_USER_CHOICES = (
        (ALL, 'all'),
        (STEWARDS, 'stewards'),
        (APP_STEWARD, 'app_steward'),
        (ORG_STEWARD, 'org_steward'),
        (USER, 'user'),
    )
    user_target = models.CharField(max_length=24, choices=TARGET_USER_CHOICES) # db_index=True)

    @property
    def metadata(self):
        if self._metadata:
            return json.loads(self._metadata)
        else:
            return None

    @metadata.setter
    def metadata(self, value):
        """
        Setter for metadata variable
        {
            '_bookmark_listing_ids': list[int],
            'folder_name': str
        }

        Args:
            value (dict): dictionary
        """
        if value:
            assert isinstance(value, dict), 'Argument of wrong type is not a dict'
            self._metadata = json.dumps(value)
        else:
            return None

    def __repr__(self):
        return '{0!s}: {1!s}'.format(self.author.user.username, self.message)

    def __str__(self):
        return '{0!s}: {1!s}'.format(self.author.user.username, self.message)
```
CQL (cassandra)
```cql
DROP KEYSPACE IF EXISTS notification;

CREATE KEYSPACE IF NOT EXISTS notification
    WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

// Schema
CREATE TABLE notification.messages (
    // Mailbox Profile ID
    profile_target_id int,

    // It is a unique id for notifications that allow to correlate between different 'mailboxes'
    notification_id  uuid,

    // Author Profile username
    author_username text,

    // Type: SYSTEM, AGENCY, AGENCY_BOOKMARK, LISTING, PEER, PEER_BOOKMARK
    notification_type text,

    // Create Date
    created_date  timestamp,

    // Expires Date
    expires_date timestamp,

    // Message of Notification
    message text,

    // If it has been emailed. then make value true
    email_status boolean,

    // Field use to store extra data.
    metadata map<text, text>,

    // Group Target, Used for debugging
    // All, Stewards, App Stewards, Org Stewards, User
    role_target text,

    primary key (profile_target_id , expires_date, created_date)
)
WITH CLUSTERING ORDER BY (expires_date DESC, created_date DESC);


// Inserts
// System-Wide Notification
INSERT INTO notification.messages(
        profile_target_id,
        notification_id,
        email_status,
        created_date,
        expires_date,
        role_target,
        message,
        notification_type,
        author_username,
        metadata
        )
VALUES (2,
        now(),
        False,
        toTimestamp(now()),
        toTimestamp(now()),
        'all',
        'Sample Message',
        'system',
        'bigbrother',
        {'test':'test'}
);


// Get all Notifications for user 2
SELECT * FROM notification.messages WHERE profile_target_id = 2;

SELECT count(*) FROM notification.messages WHERE profile_target_id = 2;


```
### Model Access Signatures:
**Get All Notifications**
```python
def get_all_notifications():
    """
    Get all notifications (expired and un-expired notifications)
    """
```

**Create Notification**
```python
def create_notification(author_username, expires_date, message, listing=None, agency=None, peer=None):
    """
    Args:
        author_username (str): Username of author
        expires_date (datetime.datetime): Expires Date (datetime.datetime(2016, 6, 24, 1, 0, tzinfo=<UTC>))
        message (str): Message of notification
        listing (models.Listing)-Optional: Listing
        Agency (models.Agency)-Optional: Agency
    """
```
**Dismiss Notification**
```python
def dismiss_notification(notification_instance, username):
    """
    Args:
        notification_instance (models.Notification): notification_instance
        username (string)
    """
```

**Update Notification**
```python
def update_notification(author_username, notification_instance, expires_date):
    """
    Args:
        notification_instance (models.Notification): notification_instance
        author_username (str): Username of author
    """
    notification_instance.expires_date = expires_date
```

**get_all_pending_notifications**
```python
def get_all_pending_notifications(for_user=False):
    """
    Gets all system-wide pending notifications
    """
```

**get_all_expired_notifications**
````python
def get_all_expired_notifications():
    """
    Get all expired notifications
    """
````

````python
def get_notification_by_id(username, id, reraise=False):
    """
    Get Notification by id
    """
````

````python
def get_self_notifications(username):
    """
    Get notifications for current user

    User's Notifications are
        * Notifications that have not yet expired (A)
        * Notifications have not been dismissed by this user (B)
        * Notifications that are regarding a listing in this user's library
          if the notification is listing-specific
        * Notification that are System-wide are included

    Args:
        username (str): current username to get notifications
    """
    notifications = (unexpired_system_notifications | unexpired_agency_notifications | unexpired_peer_notifications |
                     unexpired_listing_notifications).exclude(pk__in=dismissed_notifications)
````



## Questions (past)
* Will messages from organizations have to be approved by the Marketplace Steward?
    * Can Org. Stewards cancel their notifications without approval from the Marketplace Steward?
* Will messages created by Org Stewards or MP Stewards for/from listings need to be approved in the typical fashion? (By Org Stewards and then by MP Stewards)
* What level of information about all the current notifications should Org Stewards have?
    * Should the get to see all the other orgs' notifications but not interact?
    * Should they only get to see notifications from their own org(s) and the listings associated with their org?
    * Should they get to see OZONE Platform notifications?
* Can an owner cancel an approved notification?
