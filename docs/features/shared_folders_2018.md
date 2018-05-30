# Business Objective (draft - 05/03/2018)
Add support for sharable folders

## Implementation of Legacy Bookmarks
https://github.com/aml-development/ozp-backend/issues/7

https://github.com/aml-development/ozp-backend/pull/252


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

### operations
* bookmark
    * create - POST: /api/bookmarks - create bookmark listing
    * list - GET: /api/bookmarks/?type=LISTING - list all bookmarks (listing)
    * bulk update
* folder
    * create - POST /api/bookmarks/ - create bookmark folder
    * lists  - GET: /api/bookmarks/?type=FOLDER - list all bookmarks (folders/shared folders)
* children
    * add - PUT : /bookmarks/{parentId}/children/{childId} -Adds child to a Folder
    * move - POST: /bookmarks/{toparentId}/children	Move a child from one node to another
    * delete - DELETE : /bookmarks/{parentId}/children/{childId} - Removes the child
    * list - GET : /bookmarks/{id}/children - Lists all children

# Database Structure

## Existing Tables
* Listing
* Profile
* User

## Methods without using custom order
### Method 1 - Relational self-reference

## Methods with custom order (integer position field)
### Method 1 - Relational self-reference

### Method 2 - Relational fully normalized


# Reference

## Links
* https://stackoverflow.com/questions/9736548/database-schema-how-the-relationship-can-be-designed-between-user-file-and-fol
* https://doc.owncloud.org/server/latest/developer_manual/core/ocs-share-api.html#ocs-share-api-create-share-response-attributes
* https://docs.datastax.com/en/playlist/doc/java/playlistArchitecture.html
* https://developers.google.com/drive/api/v3/about-files
