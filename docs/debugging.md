## Performance Debugging
We check the performance of a Database model using shell_plus command for manage.py.
````shell
python manage.py shell_plus --print-sql
````
````python
# Shell Plus Model Imports
from corsheaders.models import CorsModel
from django.contrib.admin.models import LogEntry
from django.contrib.auth.models import Group, Permission, User
from django.contrib.contenttypes.models import ContentType
from django.contrib.sessions.models import Session
from ozpcenter.models import Agency, ApplicationLibraryEntry, Category, ChangeDetail, Contact, ContactType, DocUrl, Image, ImageType, Intent, Listing, ListingActivity, ListingType, Notification, Profile, Review, Screenshot, Tag
from ozpiwc.models import DataResource
# Shell Plus Django Imports
from django.utils import timezone
from django.conf import settings
from django.core.cache import cache
from django.core.urlresolvers import reverse
from django.db.models import Avg, Count, F, Max, Min, Sum, Q, Prefetch
from django.db import transaction
Python 3.4.3 (default, Feb 25 2016, 10:08:19)
[GCC 4.8.2] on linux
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>>
````

## Getting all Profiles (without any optimizations)
````python
>>> Profile.objects.all()
QUERY = 'SELECT "ozpcenter_profile"."id", "ozpcenter_profile"."display_name", "ozpcenter_profile"."bio", "ozpcenter_profile"."center_tour_flag", "ozpcenter_profile"."hud_tour_flag", "ozpcenter_profile"."webtop_tour_flag", "ozpcenter_profile"."dn", "ozpcenter_profile"."issuer_dn", "ozpcenter_profile"."auth_expires", "ozpcenter_profile"."access_control", "ozpcenter_profile"."user_id" FROM "ozpcenter_profile" LIMIT 21' - PARAMS = ()

Execution time: 0.000324s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (1,)

Execution time: 0.000207s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (2,)

Execution time: 0.000203s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (3,)

Execution time: 0.000202s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (4,)

Execution time: 0.000124s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (5,)

Execution time: 0.000101s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (6,)

Execution time: 0.000145s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (7,)

Execution time: 0.000145s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (8,)

Execution time: 0.000131s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (9,)

Execution time: 0.000099s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (10,)

Execution time: 0.000098s [Database: default]

QUERY = 'SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."id" = %s' - PARAMS = (11,)

Execution time: 0.000096s [Database: default]

[Profile: wsmith, Profile: julia, Profile: obrien, Profile: bigbrother, Profile: bigbrother2, Profile: aaronson, Profile: jones, Profile: rutherford, Profile: syme, Profile: tparsons, Profile: charrington]

````
Results:
12 database calls ( 1 + num of user = Database calls)

## Getting all Profiles (with join)
````python
>>> Profile.objects.all().select_related('user')
QUERY = 'SELECT "ozpcenter_profile"."id", "ozpcenter_profile"."display_name", "ozpcenter_profile"."bio", "ozpcenter_profile"."center_tour_flag", "ozpcenter_profile"."hud_tour_flag", "ozpcenter_profile"."webtop_tour_flag", "ozpcenter_profile"."dn", "ozpcenter_profile"."issuer_dn", "ozpcenter_profile"."auth_expires", "ozpcenter_profile"."access_control", "ozpcenter_profile"."user_id", "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "ozpcenter_profile" LEFT OUTER JOIN "auth_user" ON ( "ozpcenter_profile"."user_id" = "auth_user"."id" ) LIMIT 21' - PARAMS = ()

Execution time: 0.000472s [Database: default]

[Profile: wsmith, Profile: julia, Profile: obrien, Profile: bigbrother, Profile: bigbrother2, Profile: aaronson, Profile: jones, Profile: rutherford, Profile: syme, Profile: tparsons, Profile: charrington]
````
Results:
1 database call

## Debugging Storefront Serializer
````python
from rest_framework.response import Response
import ozpcenter.api.storefront.model_access as ma
import ozpcenter.api.storefront.serializers as se
import timeit
from django.test.client import RequestFactory

rf = RequestFactory()
get_request = rf.get('/hello/')

data = ma.get_storefront('bigbrother') # Database calls
sea = se.StorefrontSerializer(data,context={'request':get_request})
start = timeit.timeit(); r= Response(sea.data) ; end = timeit.timeit() # Database calls
print('Time: %s' % end)
````
