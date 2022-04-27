
## Controlling Access
Anonymous users have no access - all must have a valid username/password (dev)
or valid certificate (production) to be granted any access

A few endpoints only provide READ access:

* storefront
* metadata

Several resources allow global READ access with WRITE access restricted to
Apps Mall Stewards:

* access_control
* agency
* category
* contact_type
* listing_type

**image**

* global READ of metadata, but access_control enforcement on the images
themselves
* WRITE access allowed for all users, but the associated access_control level
    cannot exceed that of the current user

**intent**

* global READ and WRITE allowed, but associated intent.icon.access_control
    cannot exceed that of the current user

**library**

* READ access for ORG stewards and above
* no WRITE access
* READ and WRITE access to /self/library for the current user

**notification**

* global READ access
* WRITE access restricted to Org Stewards and above, unless the notification
    is associated with a Listing owned by this user
* READ and WRITE access to /self/notification for the current user

**profile**

* READ access restrictpython manage.py runscript sample_dated to Org Stewards and above
* WRITE access restricted to the associated user (users cannot create, modify,
    or delete users other than themselves)
* READ and WRITE access to /self/profile for the current user

**listing**

* READ access restricted by agency (if listing is private) and by access_control
    level
* WRITE access:
    * global WRITE access to create/modify/delete a listing in the draft or
        pending state ONLY
    * Org Stewards and above can change the state to published/approved or
        rejected, and change state to enabled/disabled, but must respect
        Organization (an Org Steward cannot modify
        a listing for which they are not the owner and/or not a member of
        the listing's agency)
    * global WRITE access to create/modify/delete reviews (item_comment) for
        any listing (must respect organization (if private) and access_control)
* READ access to /self/listing to return listings that current user owns (?)

**Permission Types**

|Permission Types  | Description |
|:-----------|:------------|
|read | The Read permission refers to a user's capability to read the contents of the endpoint.|
|write | The Write permission refers to a user's capability to write contents to the endpoint.|
|access_control enforcement flag | access_control level cannot exceed that of the current user|

**Access Control Matrix**
<table>
    <tr>
        <th>aml-center</th>
        <th colspan="5">Access Control</th>
    </tr>

    <tr>
        <th>Endpoint</th>
        <th>Anonymous Users</th>
        <th>Self</th>
        <th>Other</th>
        <th>Org Steward</th>
        <th>Apps Mall Steward </th>
        <th>Notes</th>
    </tr>

    <tr>
        <td>access_control (?)</td>
        <td>---</td>
        <td>r--</td>
        <td></td>
        <td>r--</td>
        <td>rw-</td>
        <td></td>
    </tr>

    <tr>
        <td>agency</td>
        <td>---</td>
        <td>r--</td>
        <td>r--</td>
        <td>r--</td>
        <td>rw-</td>
        <td></td>
    </tr>

    <tr>
        <td>category</td>
        <td>---</td>
        <td>r--</td>
        <td>r--</td>
        <td>r--</td>
        <td>rw-</td>
        <td></td>
    </tr>

    <tr>
        <td>contact_type</td>
        <td>---</td>
        <td>r--</td>
        <td>r--</td>
        <td>r--</td>
        <td>rw-</td>
        <td></td>
    </tr>

    <tr>
        <td>image (metadata)</td>
        <td>---</td>
        <td>rwa</td>
        <td>rwa</td>
        <td>rwa</td>
        <td>rwa</td>
        <td>Read: access_control enforcement on the images themselves, Write: associated access_control level cannot exceed that of the current user</td>
    </tr>

    <tr>
        <td>intent</td>
        <td>---</td>
        <td>rwa</td>
        <td>rwa</td>
        <td>rwa</td>
        <td>rwa</td>
        <td>associated intent.icon.access_control cannot exceed that of the current user</td>
    </tr>

    <tr>
        <td>library</td>
        <td>---</td>
        <td>r--</td>
        <td>r--</td>
        <td>r--</td>
        <td>r--</td>
        <td></td>
    </tr>

    <tr>
        <td>library (self)</td>
        <td>---</td>
        <td>rw-</td>
        <td>---</td>
        <td>---</td>
        <td>---</td>
        <td></td>
    </tr>

    <tr>
        <td>listing</td>
        <td>---</td>
        <td>r-a</td>
        <td>---</td>
        <td>rw-</td>
        <td>rw-</td>
        <td></td>
    </tr>

    <tr>
        <td>listing (self)</td>
        <td>---</td>
        <td>rw-</td>
        <td>---</td>
        <td>---</td>
        <td>---</td>
        <td></td>
    </tr>

    <tr>
        <td>listing_type (?)</td>
        <td>---</td>
        <td>r--</td>
        <td>---</td>
        <td>r--</td>
        <td>rw-</td>
        <td></td>
    </tr>

    <tr>
        <td>notification</td>
        <td>---</td>
        <td>rw-</td>
        <td>r--</td>
        <td>rw-</td>
        <td>rw-</td>
        <td></td>
    </tr>

    <tr>
        <td>profile</td>
        <td>---</td>
        <td>---</td>
        <td>---</td>
        <td>rw-</td>
        <td>rw-</td>
        <td>users cannot create, modify, or delete users other than themselves</td>
    </tr>

    <tr>
        <td>profile (self route)</td>
        <td>---</td>
        <td>rw-</td>
        <td>---</td>
        <td>---</td>
        <td>---</td>
        <td>Self</td>
    </tr>

    <tr>
        <td>storefront</td>
        <td>---</td>
        <td>R--</td>
        <td>---</td>
        <td>---</td>
        <td>---</td>
        <td>Get Storefront for current user</td>
    </tr>

    <tr>
        <td>metadata</td>
        <td>---</td>
        <td>R--</td>
        <td>---</td>
        <td>---</td>
        <td>---</td>
        <td>Get metadata for current user</td>
    </tr>

</table>
