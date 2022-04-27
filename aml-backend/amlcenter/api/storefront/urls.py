"""
Storefront and Metadata URLs
"""
from django.conf.urls import url, include
from rest_framework_nested import routers

import amlcenter.api.storefront.views as views

router = routers.SimpleRouter()
router.register(r'storefront', views.StorefrontViewSet, base_name='storefront')

urlpatterns = [
    url(r'^', include(router.urls)),
    url(r'^metadata/$', views.MetadataView)
]
