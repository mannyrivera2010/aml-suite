"""
Views
"""
import os
from rest_framework_swagger.renderers import OpenAPIRenderer, SwaggerUIRenderer
from rest_framework.decorators import api_view, renderer_classes
from rest_framework import response, schemas

import ozp.urls


@api_view()
@renderer_classes([SwaggerUIRenderer, OpenAPIRenderer])
def schema_view(request):
    generator = schemas.SchemaGenerator(title='API Docs', patterns=ozp.urls.apipatterns)
    return response.Response(generator.get_schema())


@api_view()
def version_view(request):
    data = {
        'name': 'ozp-backend',
        'version': os.environ['OZP_BACKEND_VERSION']
    }
    return response.Response(data)
