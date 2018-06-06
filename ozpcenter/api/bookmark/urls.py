"""
Storefront and Metadata URLs
"""
from django.conf.urls import url, include
from rest_framework_nested import routers

import ozpcenter.api.bookmark.views as views

router = routers.SimpleRouter()
router.register(r'bookmark', views.BookmarkViewSet, base_name='bookmark')

urlpatterns = [
    url(r'^', include(router.urls)),
]
