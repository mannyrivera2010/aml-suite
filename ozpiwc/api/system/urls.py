from django.conf.urls import url, include

import ozpiwc.api.system.views as views

from rest_framework_nested import routers

router = routers.SimpleRouter()
router.register(r'self/application', views.ApplicationViewSet, base_name='application_view')
router.register(r'listing', views.ApplicationListingViewSet, base_name='application_listing_view')
router.register(r'system', views.SystemViewSet, base_name='system_view')

urlpatterns = [
    url(r'^', include(router.urls)),
]
