# Business Objective - Bookmarks (hud)

## Terms and Definitions
* bookmark - enabled quick access for listing

concept of shared folder was to make a
## Implementation of Legacy Bookmarks
* https://github.com/aml-development/aml-backend/issues/7
* https://github.com/aml-development/aml-backend/pull/252


## API
### Get User library
```
GET /api/self/library HTTP/1.1
Host: 127.0.0.1:8001
Authorization: Basic YmlnYnJvdGhlcjpwYXNzd29yZA==  # bigbrother

[
    {
        "listing": {
            "id": 169,
            "title": "Tornado",
            "unique_name": "tornado",
            "launch_url": "https://en.wikipedia.org/wiki/Tornado",
            "small_icon": {
                "url": "http://127.0.0.1:8001/api/image/683/",
                "id": 683,
                "security_marking": "UNCLASSIFIED"
            },
            "large_icon": {
                "url": "http://127.0.0.1:8001/api/image/684/",
                "id": 684,
                "security_marking": "UNCLASSIFIED"
            },
            "banner_icon": {
                "url": "http://127.0.0.1:8001/api/image/685/",
                "id": 685,
                "security_marking": "UNCLASSIFIED"
            },
            "owners": [
                {
                    "id": 1,
                    "user": {
                        "username": "bigbrother"
                    },
                    "display_name": "Big Brother"
                }
            ]
        },
        "folder": "Weather",
        "id": 50,
        "position": 0
    }, ...
]

```

# Business Objective - Shared Bookmarks (aml3.0 draft - 05/03/2018)
Add support for share-able folders

## Terms and Definitions
* bookmark - can represent a folder or listing
* folder bookmark - group of listing bookmarks
* shared folder owners - users who own shared folder
* listing owners - users who own listing

## UI Interactions
* Should show all bookmarks
* User management component
    * Get all users permission for a folder (username, role) ordered by role, username?
    * Change Role for a person for a folder
* Get share-able link

## Requirements

### General
* When the folder is updated by any owner, the folder updates are visible to all users after calling api again (refresh)

### Permissions
* Should allow users to share a folder that is maintained by one or more users (owner).
    * what type of users?
* Shared Folder Viewer Should be able to
    * get a list of bookmarks
* Shared Folder Owner should be able to
    * modify the folder
    * add other owners
    * delete delete owners
    * change permissions
    * Everything a Shared Folder Viewer can do
* Shared Folder Owner should be able to see user management component
* Shared Folder Viewer should **not** be able to see user management component

### Notifications
* Send notification for updates to all owners/viewers of shared folder
    * updates
        * [ ] Adding user to shared folder
        * [ ] Removing user from shared folder
        * [x] Adding listing to shared folder
        * [x] Removing listing from shared folder
        * [ ] Changing permissions of a user for shared folder
        * [x] Removing shared folder

### Un-categorized
Owners and Viewers are two different user type

The folder should have 'viewers' that can only view, but not edit, the folder, should not see user management component

The UI component, when available, would let the folder creator select users to share to, and set their permissions (similar in the way google sheets/docs sharing works).

We will also maintain the concept of a copied folder, but will also add a true 'shared' folder.

Regular Folder, Duplicate Folder, Shared Folder  are the different types of folder

if user send a shareable link to someone without access to folder,
should we send a notification to the owners saying
"User requesting access to folder,  allow - denied access",
the user side it would be "Access Denied - request for access button"
or will it be public anyone can view folder?

### Acceptance Criteria
A new type of bookmark folder is available in the backend, that has permissions associated with it (view/edit)

## API

http://www.django-rest-framework.org/api-guide/filtering/#filtering-and-object-lookups

### Operations

* bookmark
    * create - POST: /api/bookmark - create bookmark listing
    * list - GET: /api/bookmark/?type=LISTING - list all bookmarks (listing)
    * bulk update
* folder
    * create - POST /api/bookmark/ - create bookmark folder
    * lists  - GET: /api/bookmark/?type=FOLDER - list all bookmarks (folders/shared folders)
* children
    * add - PUT : /bookmark/{parentId}/children/{childId} -Adds child to a Folder
    * move - POST: /bookmark/{toparentId}/children	Move a child from one node to another
    * delete - DELETE : /bookmark/{parentId}/children/{childId} - Removes the child
    * list - GET : /bookmark/{id}/children - Lists all children

```
[
  {
    "id" : {string} "unique identifier of a bookmark", # integer
    "name" : {string} "user friendly name of a FOLDER", # string, max 256 characters
    "kind" : "LISTING", # literal string, "LISTING",  can also be "FOLDER"
    "modifiedDate" :  {datetime} Last modified date (ISO8601 date with timezone offset),
    "createdDate" : {datetime} First uploaded date (ISO8601 date with timezone offset),
    "parent": {
      "id" : {string} "unique identifier of a bookmark", # integer
      "name" : {string} "user friendly name of a FOLDER", # string, max 256 characters
      "kind" : "FOLDER", # literal string "FOLDER"
    },
    "listing": {  # If the kind is a listing then fill else null
        "id": 169,
        "title": "Tornado",
        "unique_name": "tornado",
        "launch_url": "https://en.wikipedia.org/wiki/Tornado",
        "small_icon": {
            "url": "http://127.0.0.1:8001/api/image/683/",
            "id": 683,
            "security_marking": "UNCLASSIFIED"
        },
        "large_icon": {
            "url": "http://127.0.0.1:8001/api/image/684/",
            "id": 684,
            "security_marking": "UNCLASSIFIED"
        },
        "banner_icon": {
            "url": "http://127.0.0.1:8001/api/image/685/",
            "id": 685,
            "security_marking": "UNCLASSIFIED"
        },
        "owners": [
            {
                "id": 1,
                "user": {
                    "username": "bigbrother"
                },
                "display_name": "Big Brother"
            }
        ]
    }
  },...
]
```
OR
```
[
  {
    "id" : {string} "unique identifier of a bookmark", # integer
    "name" : {string} "user friendly name of a FOLDER", # string, max 256 characters
    "kind" : "LISTING", # literal string, "LISTING",  can also be "FOLDER"
    "modifiedDate" :  {datetime} Last modified date (ISO8601 date with timezone offset),
    "createdDate" : {datetime} First uploaded date (ISO8601 date with timezone offset),
    "listing": {  # If the kind is a listing then fill else null
        "id": 169,
        "title": "Tornado",
        "unique_name": "tornado",
        "launch_url": "https://en.wikipedia.org/wiki/Tornado",
        "small_icon": {
            "url": "http://127.0.0.1:8001/api/image/683/",
            "id": 683,
            "security_marking": "UNCLASSIFIED"
        },
        "large_icon": {
            "url": "http://127.0.0.1:8001/api/image/684/",
            "id": 684,
            "security_marking": "UNCLASSIFIED"
        },
        "banner_icon": {
            "url": "http://127.0.0.1:8001/api/image/685/",
            "id": 685,
            "security_marking": "UNCLASSIFIED"
        },
        "owners": [
            {
                "id": 1,
                "user": {
                    "username": "bigbrother"
                },
                "display_name": "Big Brother"
            }
        ]
    },
    children:[
      {
        "id" : {string} "unique identifier of a bookmark", # integer
        "name" : {string} "user friendly name of a FOLDER", # string, max 256 characters
        "kind" : "LISTING", # literal string, "LISTING",  can also be "FOLDER"
        "modifiedDate" :  {datetime} Last modified date (ISO8601 date with timezone offset),
        "createdDate" : {datetime} First uploaded date (ISO8601 date with timezone offset),
        "listing": {  # If the kind is a listing then fill else null
            "id": 169,
            "title": "Tornado",
            "unique_name": "tornado",
            "launch_url": "https://en.wikipedia.org/wiki/Tornado",
            "small_icon": {
                "url": "http://127.0.0.1:8001/api/image/683/",
                "id": 683,
                "security_marking": "UNCLASSIFIED"
            },
            "large_icon": {
                "url": "http://127.0.0.1:8001/api/image/684/",
                "id": 684,
                "security_marking": "UNCLASSIFIED"
            },
            "banner_icon": {
                "url": "http://127.0.0.1:8001/api/image/685/",
                "id": 685,
                "security_marking": "UNCLASSIFIED"
            },
            "owners": [
                {
                    "id": 1,
                    "user": {
                        "username": "bigbrother"
                    },
                    "display_name": "Big Brother"
                }
            ]
        },
        children:[

        ]
      },......
    ]
  },......
]
```


# Database Structure

## Existing Tables
* Listing
* Profile
* User

## Methods without using custom order
### Method 1 - Relational self-reference (child-parent not using root folder)
#### Models
```
class BookmarkEntry(models.Model):
    bookmark_parent = models.ForeignKey('BookmarkEntry', null=True, blank=True)
    title = models.CharField(max_length=255)

    created_date = models.DateTimeField(default=utils.get_now_utc)
    modified_date = models.DateTimeField(default=utils.get_now_utc)

    listing = models.ForeignKey('Listing', related_name='listing_entries', null=True, blank=True)

    FOLDER = 'FOLDER'
    LISTING = 'LISTING'

    TYPE_CHOICES = (
        (FOLDER, 'FOLDER'),
        (LISTING, 'LISTING'),
    )
    type = models.CharField(max_length=255, choices=TYPE_CHOICES, default=FOLDER)

    creator = models.ForeignKey('Profile')

class BookmarkPermission(models.Model):
    bookmark = models.ForeignKey('BookmarkEntry', related_name='bookmark_permission')
    profile = models.ForeignKey('Profile')

    created_date = models.DateTimeField(default=utils.get_now_utc)
    modified_date = models.DateTimeField(default=utils.get_now_utc)

    OWNER = 'OWNER'
    VIEWER = 'VIEWER'

    USER_TYPE_CHOICES = (
        (OWNER, 'OWNER'),
        (VIEWER, 'VIEWER'),
    )
    user_type = models.CharField(max_length=255, choices=USER_TYPE_CHOICES, default=VIEWER)
```

#### Methods (pseudocode)
##### Getting root folder for user
```

```

##### Getting first level entries for user
````

````

#### Adding a new listing under a folder
````

````

#### Adding new user as a viewer to a shared folder

#### Removing a user from shared folder list


### Method 2 - Relational self-reference (child-parent using root folder)
#### Models
```
class BookmarkEntry(models.Model):
    bookmark_parent = models.ForeignKey('BookmarkEntry', null=True, blank=True)
    # bookmark_parents = models.ManyToManyField('BookmarkEntry', null=True, blank=True)
    # bookmark_parents m2mField is needed becuause of bookmark_parent_relationships
    title = models.CharField(max_length=255)

    created_date = models.DateTimeField(default=utils.get_now_utc)
    modified_date = models.DateTimeField(default=utils.get_now_utc)

    listing = models.ForeignKey('Listing', related_name='listing_entries', null=True, blank=True)

    is_root = models.BooleanField(default=False)

    FOLDER = 'FOLDER'
    LISTING = 'LISTING'

    TYPE_CHOICES = (
        (FOLDER, 'FOLDER'),
        (LISTING, 'LISTING'),
    )
    type = models.CharField(max_length=255, choices=TYPE_CHOICES, default=FOLDER)


class BookmarkPermission(models.Model):
    bookmark = models.ForeignKey('BookmarkEntry', related_name='bookmark_permission')
    profile = models.ForeignKey('Profile')

    created_date = models.DateTimeField(default=utils.get_now_utc)
    modified_date = models.DateTimeField(default=utils.get_now_utc)

    OWNER = 'OWNER'
    VIEWER = 'VIEWER'

    USER_TYPE_CHOICES = (
        (OWNER, 'OWNER'),
        (VIEWER, 'VIEWER'),
    )
    user_type = models.CharField(max_length=255, choices=USER_TYPE_CHOICES, default=VIEWER)
```


* bookmark_parent_relationships (m2m table - storage of child-parent relationships)
    * id (integer)
    * bookmark (foreign_key to bookmarks id)
    * parent_bookmark (foreign_key to bookmarks id, 1 bookmark can have many parents)

when would `bookmark_parent_relationships` table be good to use?
```
r1 = root folder for user 1
r2 = root folder for user 2
S1 = Shared Folder for user 1 and user 2
+-----------------+  +-----------------+
|                 |  |                 |
|         +----+  |  | +------+        |
|         |r1  |  |  | |r2    |        |
|         +----+  |  | +--+---+        |
|    +------+     |  |    |            |
|    v            |  |    v            |
| +--+-+          |  | +--+---+        |
| | S1 |          |  | |S1    |        |
| +----+          |  | +------+        |
|   Owner         |  |  Viewer         |
|                 |  |                 |
+-----------------+  +-----------------+
```

Rules
* Each user has only one bookmark root folder, the user is the owner of root folder
    * bookmarks.objects.filter(root=true, )

#### Methods (pseudocode)
##### Getting root folder for user
```
def create_get_user_root_bookmark_folder(profile):
    """
    Create or Get user's root folder
    profile = Profile.objects.first()
    """
    bookmark_entry_query = models.BookmarkEntry.objects.filter(
                            bookmark_permission__profile=profile,
                            bookmark_permission__user_type='OWNER',
                            is_root=True)


    if bookmark_entry_query:
        if len(bookmark_entry_query) >= 2:
            print('A USER SHOULD NOT HAVE MORE THAN ONE ROOT FOLDER')

        return bookmark_entry_query[0]
    else:
        bookmark_entry = models.BookmarkEntry()
        bookmark_entry.type = bookmark_entry.FOLDER
        bookmark_entry.is_root = True
        bookmark_entry.title = 'ROOT'
        bookmark_entry.save()

        bookmark_permission = models.BookmarkPermission()
        bookmark_permission.bookmark=bookmark_entry
        bookmark_permission.profile=profile
        bookmark_permission.user_type=models.BookmarkPermission.OWNER
        bookmark_permission.save()

        return bookmark_entry
```

##### Getting first level entries for user
````

````

## Methods with custom order (integer position field)
```
[Listing,...] = List
(Type-Title[Listing,...]) = Folder

bigbrother
[
  (
    Shard-F1
      [1, 2]
  )
  (
      Folder-F2
      [1]
  )
  1
  2
]

jones
  [
    1
    (
      Shared-F1
        [1,2]
    )
    3
  ]

```

Table View for entries
```
username   | folder_name | listing | position
---------------------------------------------
bigbrother (1) | s1          | 1       | 1 (nested order = 7)
bigbrother (1) | s1          | 2       | 1 (nested order = 8)

bigbrother (1) | f1          | 1       | 2 (nested order?)
bigbrother (1) | f1          | 4       | 2 (nested order?)

bigbrother (1) | null        | 1       | 3
bigbrother (1) | null        | 2       | 4

jones      (2) | null        | 1       | 1
jones      (2) | s1          | 1       | 1 (nested order = 7)
jones      (2) | s1          | 2       | 1 (nested order = 8)
jones      (2) | null        | 3       | 6

```

### Method 2 - Relational self-reference

Table `entry_profile`

Table `entry`


### Method 3 - Relational fully normalized

Tables
```
Table `profile`                 |   Table `Listing`
                                |
id | username                   |   id | ...
1  | bigbrother                 |   1  |
2  | jones                      |   2  |
                                |   3  |
                                |
Table `folder_entry `           |  Table `entry_permission`
                                |
id | name | entry               |  id | entry | profile | permission
1  | S1   | 1                   |  1  | 1     | 1       | owner
2  | F1   | 2                   |  2  | 1     | 2       | viewer
                                |
                                |
Table `folder_listing_entry`    |    Table `listing_entry`
                                |    id  | listing | entry
id | listing | folder | entry   |    1   | 1       | 3
1  | 1       | 1      | 7       |    2   | 2       | 4
2  | 2       | 1      | 8       |    3   | 1       | 5
3  | 1       | 2      | 9       |    4   | 3       | 6


Table `entry`

id  | creator (profile)
1   |  1
2   |  1
3   |  1
4   |  1
5   |  2
6   |  2
7   |  1
8   |  1
9   |  2

Table `entry_position`

id | entry | profile | position
1  | 1     | 1       | 1
2  | 2     | 1       | 2
3  | 3     | 1       | 3
4  | 4     | 1       | 4
5  | 7     | 1       | 1
6  | 8     | 1       | 2
7  | 9     | 1       | 1
8  | 5     | 2       | 1
9  | 1     | 2       | 2
10 | 7     | 2       | 1
11 | 8     | 2       | 2
12 | 6     | 2       | 3
```

## Methods to maintain backward compatability

### Method 4 - Create V2 API for 3.0 use
* look at method 1

### Method 5 - Create a secondary API for shared folders
* This will leave the current bookmark folder structure intact
* Will require frontend to call 2 API methods to receive personal and shared folders
* Will not require a full re-structure of bookmarks and folders from 2.0

# Reference

## Links
* https://stackoverflow.com/questions/9736548/database-schema-how-the-relationship-can-be-designed-between-user-file-and-fol
* https://doc.owncloud.org/server/latest/developer_manual/core/ocs-share-api.html#ocs-share-api-create-share-response-attributes
* https://docs.datastax.com/en/playlist/doc/java/playlistArchitecture.html
* https://developers.google.com/drive/api/v3/about-files
