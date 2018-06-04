"""
Contact Types URLs
"""
from django.conf.urls import url, include
from rest_framework_nested import routers

import ozpcenter.api.work_role.views as views

router = routers.SimpleRouter()
router.register(r'work_role', views.WorkRoleViewSet)

urlpatterns = [
    url(r'^', include(router.urls)),
]
