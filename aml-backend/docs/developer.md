## For Developers
Understanding this project requires knowing a moderate amount of Django and
a large amount of Django Rest Framework (DRF). From Django itself:

* Object-relational mapper (ORM)
* Authentication
* `manage.py` utility (testing, database migration)
* Logging
* Settings

Most of the URLs and Views are done with DRF, and very little is done with
templating, forms, and the admin site

### Plugins
TODO Add documentation

* How does it work
* How do make a new plugin

### Pep8
Pep8 is the Style Guide for Python Code
````
pep8 aml amlcenter plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --exclude=amlcenter/scripts/* --show-source
autopep8 . -r --diff --ignore errors=E501,E123,E128,E121,E124  --max-line-length=5000
````

### Serializers
Serialization = Python obj -> JSON

Deserialization = JSON -> Python obj

DRF does not have a built-in, defacto way of specifying different serializers
for handling input on a request vs output on a Response. Sometimes this is
acceptable, but often times the two structures are not the same. For instance,
some fields may be auto-generated on the server when a `POST` is made (so they
shouldn't be part of the `POST` Request data that will be deserialized), but a
`GET` request should return a Response that includes this information. For
simple cases like this, Serializer fields can be marked as `read_only` or
`write_only` (`read_only` fields will not become part of the serializer's
`validated_data`). If more control than this is needed (e.g. very different input
and output formats), the `get_serializer_class()` method can be overridden
in the View and selected dynamically based on request.method (`POST`, `GET`,
etc).

For details regarding input vs output serializers:
* https://github.com/tomchristie/django-rest-framework/issues/1563
* http://stackoverflow.com/questions/17551380/python-rest-framwork-different-serializers-for-input-and-output-of-service

Sometimes it might not be clear where the Serializer classes should live for
nested objects. For example, the listing resource needs to serialize the nested
Agency model - should that Agency serializer live in the listing resource
package or in the agency package? Generally speaking, if the serializer is
very generic, it should live in its respective resource package. If instead
it's highly customized (and thus unlikely to be used by other resources), it
should live with its nested resource.

One annoyance with nested serializers is that, if doing a create/POST, DRF
assumes that each nested resource should also be created. This causes validation
errors to be raised when doing things like creating a new listing with an
existing category, listing type, etc. The way around that problem is to
explicitly remove all validation on any nested serializer fields that have
unique constraints. For example, for a serializer with a `title` field:
```
extra_kwargs = {
    'title': {'validators': []}
}
```
Because we don't want to remove the validator for the base resource (only when
it's used in a nested fashion), some of the more complicated resources (namely
Listing) have lots of nested serializers that are identical to their non-nested
counterparts save for the removal of the unique field validators

### Model Access and Caching
`model_access.py` files should be used to encapsulate more complex database
queries and business logic (as opposed to placing it in Views and Serializers).
These methods are easier to use in sample data generators, easier to test,
and allows the complexity of Django Rest Framework to stay largely separate
from the core application logic

Memcache is not currently used, but this is also the layer to implement
object/query caching, such as:
```
data = cache.get('stuff')
if data is None:
    data = list(Stuff.objects.all())
    cache.set('stuff', data)
return data
```
Note that we also need logic to invalidate specific caches when resources are
modified. For example, if a Listing is updated, all cached items referring/using
that listing's data should be invalidated. By far and large, this logic is not
yet in place, so enabling the cache will likely lead to unexpected results.
In addition, the requirement to support 'tailored views' reduces the value
of caching, since most queries must be filtered against a user's particular
access controls

### Models
Regarding `__str__()`:
It’s important to add `__str__()` methods to your models, not only for your own
convenience when dealing with the interactive prompt, but also because objects’
representations are used throughout Django’s automatically-generated admin.
Note that on Python 2, `__unicode__()` should be defined instead.

By default, fields cannot be null or blank

Some of the access control logic necessary to support tailored views lives
in `models.py` as custom `models.Manager` classes (Reviews, Listings,
ListingActivities, and Images)

### Views
We generally prefer to
use class-based views and `ViewSet`s (`ModelViewSet`s in particular) just
because it's less code (assuming you don't require a significant amount of
customization)

The use of the convenience method `get_object_or_404` breaks the encapsulation
of database queries in the `model_access` files (and prevents caching). That
might be something to look at later on.

### URLs
All resource endpoints are defined in the resource's respective `urls.py` in
`amlcenter/api/`. `amlcenter.urls` collects all of these endpoints, where they
are given the `api/` prefix in the global `urls.py`

DRF uses a browsable API, meaning that you can go to
`localhost:8000/api/metadata/` (for instance) in your browser. In general, the
Swagger documentation is the recommended way to view and interact with the API.

All URLs are currently set to use a trailing `/`

### Authentication and Authorization
#### Overview
Authentication and authorization is based on the default `django.contrib.auth`
system built into Django, with numerous customizations.

The default User model is extended by giving the `Profile` model a one-to-one
relationship with the `django.contrib.auth.models.User` model, as described
[here](https://docs.djangoproject.com/en/1.8/topics/auth/customizing/#extending-the-existing-user-model)

The default [User](https://docs.djangoproject.com/en/1.8/ref/contrib/auth/#user)
model has the following fields:

* username
* first_name
* last_name
* email
* password
* groups (many-to-many relationship to Group)
* user_permissions (many-to-many relationship to Permission)
* is_staff (Boolean. Designates whether this user can access the admin site)
* is_active (Boolean. Designates whether this user account should be considered
    active)
* is_superuser (Boolean. Designates that this user has all permissions without
    explicitly assigning them)
* last_login (a datetime of the user's last login)
* date_joined (a datetime designating when the account was created)

Of these fields:

* first_name and last_name are not used
* is_superuser is always set to False
* is_staff is set to True for Org Stewards and Apps Mall Stewards
* password is only used in development. On production, client SSL certs are
    used, and so password is set to XXXXXXXX

[Groups](https://docs.djangoproject.com/en/1.8/topics/auth/default/#groups) are
used to categorize users as Users, Org Stewards, Apps Mall Stewards, etc. These
groups are used to partially control access to various resources (for example,
Users cannot make modifications to the Categories). That said, the majority
of 'access control' cannot be accomplished by creating generic permissions
and groups. For example, an Org Steward should be able to approve a Listing only
for organizations to which they belong. Furthermore, any resources (Listings,
Images) that have a specific access_control associated with them must be
hidden from users (regardless of role/group) without the appropriate level
of access.

Django Permissions are used to control access to the Admin site. By default,
add, change, and delete permissions are added to each model in the application.
The notion of separate permissions for these three operations don't make much
sense for this application - for now, the default permissions will be left
alone, but the Permissions infrastructure won't be used much beyond that. As
previously stated, it is not possible to create generic permissions that can
be statically assigned to users, like 'can_approve_listing', since the
allowance of such an action depends on the object (model instance), not just the
model type. Therefore, custom object-level permissions will typically be used
to control access to specific resource instances (for both read and write
operations). For list queries where multiple resources are returned, these
object-level permission checks are not used. Instead, filters and custom
querysets are used to ensure only the appropriate data is returned.

#### Authentication
The app currently supports two forms of authentication - HTTP Basic Auth and
PKI (client SSL authentication). HTTP Basic Auth is used for development
purposes only. PKI authentication is implemented in `amlcenter/auth/pkiauth.py`.
The method of authentication to use is controlled by
`REST_FRAMEWORK.DEFAULT_AUTHENTICATION_CLASSES` in settings.py

### Tests
Generally speaking, each resource (listing, agency, profile, etc) may have
two types of tests: business logic tests and API tests. The former typically
tests code in `model_access.py` files, which is pure Python code and independent
of Django or any "web stuff". The latter API tests, on the other hand, actually
make HTTP requests using special testing clients and factories, and are more
like end-to-end or integration tests

### Database
System uses Postgres in Production and Sqlite3 in Development

### API Documentation
There are a number of different documentation resources available, depending
on what you're looking for.

DRF's Web Browsable API can be accessed by entering an endpoint in the browser,
for example, `<rootUrl>/api/profile/`.  Limitations:
 * the API Root doesn't have a list of all endpoints, so you need to know
 what you're looking for
 * although these pages include forms that could potentially support POST
 requests, they don't work very well, making the browsable API mostly useless
 for non-GET requests

Swagger docs are created via Django REST Swagger and served at
 `<rootUrl>/docs/`. Swagger makes it easy to see all of the endpoints available.
 Unlike the Browsable API docs, Swagger supports POST, PUT, and DELETE for most
 of the endpoints as well. Limitations:
  * POST api/image/ doesn't work from Swagger
  * some of the more complicated endpoints (like POST api/listing/) might not
  have forms that show all of the required and/or optional data that must or
  could be included in the request

Postman was used extensively during the API's development, and perhaps someday
 a Postman Collection of requests will be added to this repo

### Logging
Currently, a single logger (`aml-center`) is used throughout the application.
See `settings.py` for details

### Static and Media Files
Static files: JS, CSS, fonts, etc. Media files: images uploaded during app
usage. Good explanation [here](http://timmyomahony.com/blog/static-vs-media-and-root-vs-path-in-django/)

Static files include html/css/js for:
 * Django admin site
 * DRF Browsable API
 * Swagger docs

Media files (uploaded images) have associated access controls that require
enforcement on a per-user basis. For that reason, media files are not served
statically as they typically are, but instead served by the wsgi app itself

### Scripts
The `runscript` command is installed via the django-extensions package and used
to run scripts in the django context, just as you would get by running a set
of commands in the shell using `python manage.py shell`.     
This can be used to run the script to populate the database with sample data:   
`python manage.py runscript sample_data_generator`.     
See the [docs](http://django-extensions.readthedocs.org/en/latest/runscript.html) for
details

### API Input
All POST, PUT, and PATCH endpoints should use JSON encoded input as per
[this](http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api#json-requests)

### Django Admin Site
The admin site is currently enabled in development (but will likely be
disabled in production). It is accessible by both Apps Mall Stewards and
Org Stewards. It has a number of limitations, including the inability to upload
images (since images aren't stored in the database), and the fact that many
operations (like editing reviews, approving listings, etc) should result in
additional operations (like creating ListingActivity entries), but using
the Admin interface directly bypasses that logic
