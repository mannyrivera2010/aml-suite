"""
Storefront and Metadata URLs
"""
from django.conf.urls import url, include
from rest_framework_nested import routers

import amlcenter.api.bookmark.views as views

router = routers.SimpleRouter()
router.register(r'bookmark', views.BookmarkViewSet, base_name='bookmark')

# nested routes
nested_router = routers.NestedSimpleRouter(router, r'bookmark', lookup='bookmark')
nested_router.register(r'permission', views.BookmarkPermissionViewSet, base_name='permission')


urlpatterns = [
    url(r'^', include(router.urls)),
    url(r'^', include(nested_router.urls)),
]
