"""
URLs for all resources - will be placed under /api route by the project level
"""
from django.conf.urls import url, include

from amlcenter import views
from rest_framework_jwt.views import obtain_jwt_token
from rest_framework_jwt.views import verify_jwt_token
from rest_framework_jwt.views import refresh_jwt_token

urlpatterns = [
    url(r'', include('amlcenter.api.agency.urls')),
    url(r'', include('amlcenter.api.category.urls')),
    url(r'', include('amlcenter.api.contact_type.urls')),
    url(r'', include('amlcenter.api.image.urls')),
    url(r'', include('amlcenter.api.intent.urls')),
    url(r'', include('amlcenter.api.library.urls')),
    url(r'', include('amlcenter.api.listing.urls')),
    url(r'', include('amlcenter.api.notification.urls')),
    url(r'', include('amlcenter.api.profile.urls')),
    url(r'', include('amlcenter.api.storefront.urls')),
    url(r'', include('amlcenter.api.subscription.urls')),
    url(r'', include('amlcenter.api.work_role.urls')),
    url(r'', include('amlcenter.api.bookmark.urls')),
    url(r'^version/', views.version_view),
    url(r'^token-auth/', obtain_jwt_token),
    url(r'^token-verify/', verify_jwt_token),
    url(r'^token-refresh/', refresh_jwt_token),
]
