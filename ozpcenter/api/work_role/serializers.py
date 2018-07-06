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
        fields = ('id', 'name',)

        # also need to explicitly remove validators for `name` field
        extra_kwargs = {
            'name': {
                'validators': []
            }
        }
