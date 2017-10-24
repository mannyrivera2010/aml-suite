"""
Contact Types Serializers
"""
import logging

from rest_framework import serializers

from ozpcenter import models


logger = logging.getLogger('ozp-center.' + str(__name__))


class ContactTypeSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.ContactType
        fields = '__all__'
