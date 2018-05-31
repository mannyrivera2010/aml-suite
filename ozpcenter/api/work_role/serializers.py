"""
Work Roles Serializers
"""
import logging

from rest_framework import serializers

from ozpcenter import models


logger = logging.getLogger('ozp-center.' + str(__name__))


class WorkRoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.WorkRole
        fields = '__all__'
