"""
urls
"""
from django.conf.urls import url, include

import ozpiwc.api.data.views as views

from rest_framework_nested import routers

router = routers.SimpleRouter()
router.register(r'self/data', views.DataApiViewSet, base_name='intent_list_view')

# url(r'^self/data/$', views.DataApiView),
# # this will capture things like food/pizza/cheese. In the view, the key
# # will be modified such that it always starts with a / and never ends
# # with one
# url(r'^self/data/(?P<key>[a-zA-Z0-9\-/]+)$', views.DataApiView)

urlpatterns = [
    url(r'^', include(router.urls)),
]
