# Business Objective (draft - 05/03/2018)
Add support for sharable folders

## Requirements
We want to allow users to share a folder that is maintained by one or more users (owner/admin).

Owners and Viewers are two different user type

When the folder is updated by any owner, the folder updates are visible to all users.

Send notification for shared folder updates to all owners/viewers

The folder should have 'owners' who can modify the folder, add other owners, delete delete owners, change permissions, should see user management component.

The folder should have 'viewers' that can only view, but not edit, the folder, should not see user management component

The UI component, when available, would let the folder creator select users to share to, and set their permissions (similar in the way google sheets/docs sharing works).

We will also maintain the concept of a copied folder, but will also add a true 'shared' folder.

Regular Folder, Duplicate Folder, Shared Folder  are the different types of folder

### Acceptance Criteria
A new type of bookmark folder is available in the backend, that has permissions associated with it (view/edit)

## API


### operations
* bookmark
    * create - POST: /api/bookmarks - create bookmark listing
    * list - GET: /api/bookmarks/?filters=type:LISTING - list all bookmarks (listing)
    * bulk update
* folder
    * create - POST /api/bookmarks/ - create bookmark folder
    * lists  - GET: /api/bookmarks/?filters=type:FOLDER - list all bookmarks (folders/shared folders)
* children
    * add - PUT : /bookmarks/{parentId}/children/{childId} -Adds child to a Folder
    * move - POST: /bookmarks/{toparentId}/children	Move a child from one node to another
    * delete - DELETE : /bookmarks/{parentId}/children/{childId} - Removes the child
    * list - GET : /bookmarks/{id}/children - Lists all children


## Database Structure

### Method 1 - Relational self-reference

### Method 2 - Relational fully normalized (with position)

## Links
* https://stackoverflow.com/questions/9736548/database-schema-how-the-relationship-can-be-designed-between-user-file-and-fol
* https://doc.owncloud.org/server/latest/developer_manual/core/ocs-share-api.html#ocs-share-api-create-share-response-attributes
* https://docs.datastax.com/en/playlist/doc/java/playlistArchitecture.html
* https://developers.google.com/drive/api/v3/about-files
