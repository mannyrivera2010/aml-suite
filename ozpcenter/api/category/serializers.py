"""
Category Serializers
"""
import logging

from rest_framework import serializers

import ozpcenter.api.agency.serializers as agency_serializers
from ozpcenter import models


logger = logging.getLogger('ozp-center.' + str(__name__))


class CategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Category
        fields = '__all__'


class ListingCategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Category
        fields = ('title', 'description')

        extra_kwargs = {
            'title': {'validators': []}
        }


class CategoryListingSerializer(serializers.HyperlinkedModelSerializer):
    agency = agency_serializers.CreateAgencySerializer(required=False)
    categories = ListingCategorySerializer(many=True, required=False)

    class Meta:
        model = models.Listing
        fields = ('unique_name', 'title', 'id', 'agency', 'categories')
