from django.conf.urls import url, include

import ozpiwc.api.intent.views as views

from rest_framework_nested import routers

router = routers.SimpleRouter()
router.register(r'self/intent', views.IntentListViewSet, base_name='intent_list_view')
router.register(r'intent', views.IntentViewSet, base_name='intent_view')

urlpatterns = [
    url(r'^', include(router.urls)),
]
