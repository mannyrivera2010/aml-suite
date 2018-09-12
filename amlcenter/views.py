"""
Top Level View
"""
from rest_framework.decorators import api_view
from rest_framework import response, schemas

from aml import version


@api_view()
def version_view(request):
    data = {
        'name': 'aml-backend',
        'version': version
    }
    return response.Response(data)
