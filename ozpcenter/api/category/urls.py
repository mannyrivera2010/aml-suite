"""
Category URLs
"""
from django.conf.urls import url, include
from rest_framework_nested import routers

import ozpcenter.api.category.views as views

router = routers.SimpleRouter()
router.register(r'category', views.CategoryViewSet)

urlpatterns = [
    url(r'^', include(router.urls)),
]
