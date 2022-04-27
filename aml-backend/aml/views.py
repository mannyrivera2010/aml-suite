"""
Views
"""
import os
from rest_framework_swagger.renderers import OpenAPIRenderer, SwaggerUIRenderer
from rest_framework.decorators import api_view, renderer_classes
from rest_framework import response, schemas

import aml.urls
from aml import version


@api_view()
@renderer_classes([SwaggerUIRenderer, OpenAPIRenderer])
def schema_view(request):
    generator = schemas.SchemaGenerator(title='API Docs', patterns=aml.urls.apipatterns)
    return response.Response(generator.get_schema())
