"""
Profile URLs
"""
from django.conf.urls import url, include
from rest_framework_nested import routers

import ozpcenter.api.profile.views as views

router = routers.SimpleRouter()
router.register(r'profile', views.ProfileViewSet, base_name='profile')
router.register(r'user', views.UserViewSet)
router.register(r'group', views.GroupViewSet)

profile_router = routers.NestedSimpleRouter(router, r'profile', lookup='profile')
profile_router.register(r'listing', views.ProfileListingViewSet, base_name='listing')
profile_router.register(r'listingvisits', views.ProfileListingVisitCountViewSet, base_name='listingvisits')

urlpatterns = [
    url(r'^', include(router.urls)),
    url(r'^', include(profile_router.urls)),
    url(r'^self/profile/$', views.CurrentUserViewSet.as_view({'get': 'retrieve', 'put': 'update', 'patch': 'update'})),
    url(r'^self/token/$', views.CurrentUserTokenViewSet.as_view({'get': 'retrieve'}))
]
