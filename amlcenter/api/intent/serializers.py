"""
Intent Serializers
"""
import logging

from rest_framework import serializers

from amlcenter import models
import amlcenter.api.image.model_access as image_model_access
import amlcenter.api.image.serializers as image_serializers


logger = logging.getLogger('aml-center.' + str(__name__))


class IntentSerializer(serializers.ModelSerializer):
    icon = image_serializers.ShortImageSerializer()

    class Meta:
        model = models.Intent
        depth = 1
        fields = '__all__'

    def validate(self, data):
        icon = data.get('icon')
        if icon:
            data['icon'] = image_model_access.get_image_by_id(
                data['icon']['id'])
        else:
            data['icon'] = None
        return data


class ListingIntentSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Intent
        # TODO: is action the right thing?
        fields = ('action',)

        extra_kwargs = {
            'action': {'validators': []}
        }
