"""
Aml URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
"""
from django.conf import settings
from django.conf.urls import include, url
from django.conf.urls.static import static
from django.contrib import admin

from aml import views

apipatterns = [
    url(r'^api/', include('amlcenter.urls')),
]

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^docs/', views.schema_view),
]
urlpatterns = urlpatterns + apipatterns

# In debug mode, serve the media and static resources with the django web server
# https://docs.djangoproject.com/en/1.11/howto/static-files/#serving-static-files-during-development
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
