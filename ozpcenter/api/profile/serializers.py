"""
Profile Serializers
"""
import logging
from collections import OrderedDict

from django.contrib import auth


from rest_framework import serializers

from ozpcenter import models
from plugins import plugin_manager
from plugins.plugin_manager import system_anonymize_identifiable_data
import ozpcenter.model_access as generic_model_access
import ozpcenter.api.profile.model_access as profile_model_access
import ozpcenter.api.agency.model_access as agency_model_access
import ozpcenter.api.work_role.model_access as work_role_model_access
import ozpcenter.api.image.model_access as image_model_access
from ozpcenter.api.work_role.serializers import WorkRoleSerializer
from ozpcenter.api.image.serializers import ImageSerializer


logger = logging.getLogger('ozp-center.' + str(__name__))


class AgencySerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Agency
        fields = ('short_name', 'title')

        extra_kwargs = {
            'title': {'validators': []}
        }


class GroupSerializer(serializers.HyperlinkedModelSerializer):

    class Meta:
        model = auth.models.Group
        fields = ('name',)

        # also need to explicitly remove validators for `name` field
        extra_kwargs = {
            'name': {
                'validators': []
            }
        }


class StorefrontCustomizationSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.StorefrontCustomization
        fields = ('section', 'position', 'is_hidden')


class UserSerializer(serializers.ModelSerializer):
    groups = GroupSerializer(many=True)

    class Meta:
        # TODO: Not supposed to reference Django's User model directly, but
        # using settings.AUTH_USER_MODEL here doesn't not work
        # model = settings.AUTH_USER_MODEL
        model = auth.models.User
        fields = ('id', 'username', 'email', 'groups')

    def validate(self, data):

        if 'groups' in data:
            groups = data['groups']

            groups_instances = set()
            for group_record in groups:
                group_name_value = group_record['name']
                groups_instances.add(auth.models.Group.objects.get(name=group_name_value))

            data['groups'] = list(groups_instances)

        return data

    def to_internal_value(self, data):
        ret = super(UserSerializer, self).to_internal_value(data)
        return ret

    def to_representation(self, data):
        access_control_instance = plugin_manager.get_system_access_control_plugin()
        ret = super(UserSerializer, self).to_representation(data)

        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(self.context['request'].user.username)

        check_request_self = False
        if self.context['request'].user.id == ret['id']:
            check_request_self = True

        del ret['id']

        if anonymize_identifiable_data and not check_request_self:
            ret['username'] = access_control_instance.anonymize_value('username')
            ret['email'] = access_control_instance.anonymize_value('email')

        return ret


class ShortUserSerializer(serializers.ModelSerializer):

    class Meta:
        # TODO: not supposed to reference Django's User model directly, but
        # using settings.AUTH_USER_MODEL here doesn't not work
        # model = settings.AUTH_USER_MODEL
        model = auth.models.User
        fields = ('id', 'username', 'email')

    def to_representation(self, data):
        access_control_instance = plugin_manager.get_system_access_control_plugin()
        ret = super(ShortUserSerializer, self).to_representation(data)

        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(self.context['request'].user.username)

        check_request_self = False
        if self.context['request'].user.id == ret['id']:
            check_request_self = True

        del ret['id']

        if anonymize_identifiable_data and not check_request_self:
            ret['username'] = access_control_instance.anonymize_value('username')
            ret['email'] = access_control_instance.anonymize_value('email')

        return ret


class ProfileSerializer(serializers.ModelSerializer):
    avatar = ImageSerializer()
    organizations = AgencySerializer(many=True)
    stewarded_organizations = AgencySerializer(many=True)
    work_roles = WorkRoleSerializer(many=True)
    storefront_customizations = StorefrontCustomizationSerializer(many=True)
    user = UserSerializer()

    class Meta:
        model = models.Profile
        fields = ('id', 'display_name', 'bio', 'avatar', 'organizations',
            'stewarded_organizations', 'work_roles', 'storefront_customizations', 'user',
            'highest_role', 'dn', 'center_tour_flag', 'hud_tour_flag', 'webtop_tour_flag',
            'email_notification_flag', 'listing_notification_flag', 'subscription_notification_flag',
            'leaving_ozp_warning_flag', 'only_508_search_flag', 'is_beta_user', 'theme')

        read_only_fields = ('id', 'bio', 'organizations', 'user',
            'highest_role', 'is_beta_user')

    def to_internal_value(self, data):
        ret = super(ProfileSerializer, self).to_internal_value(data)

        if 'work_roles' in data:
            ret['work_roles'] = []
            for work_role in data['work_roles']:
                work_role_dict = OrderedDict({'id': work_role['id']})
                ret['work_roles'].append(work_role_dict)

        return ret

    def to_representation(self, data):
        access_control_instance = plugin_manager.get_system_access_control_plugin()
        ret = super(ProfileSerializer, self).to_representation(data)

        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(self.context['request'].user.username)

        from_current_view = self.context.get('self')

        if from_current_view:
            if anonymize_identifiable_data:
                ret['second_party_user'] = True
            else:
                ret['second_party_user'] = False

        check_request_self = False
        if self.context['request'].user.id == ret['id']:
            check_request_self = True

        if anonymize_identifiable_data and not check_request_self:
            ret['display_name'] = access_control_instance.anonymize_value('display_name')
            ret['bio'] = access_control_instance.anonymize_value('bio')
            ret['dn'] = access_control_instance.anonymize_value('dn')

        return ret

    def validate(self, data):
        stewarded_organizations = None
        if 'stewarded_organizations' in data:
            stewarded_organizations = []
            for org in data['stewarded_organizations']:
                stewarded_organizations.append(agency_model_access.get_agency_by_title(org['title']))
        data['stewarded_organizations'] = stewarded_organizations

        if 'work_roles' in data:
            work_roles = []
            for work_role in data['work_roles']:
                work_roles.append(work_role_model_access.get_work_role_by_id(work_role['id']))
            data['work_roles'] = work_roles

        if 'storefront_customizations' in data:
            for customization in data['storefront_customizations']:
                if not customization.get('section', None):
                    raise serializers.ValidationError("All items in storefront_customizations must have a section")

        avatar = None
        if 'avatar' in data and 'id' in data['avatar']:
            avatar = image_model_access.get_image_by_id(data['avatar']['id'])
        data['avatar'] = avatar

        return data

    def update(self, profile_instance, validated_data):
        if 'center_tour_flag' in validated_data:
            profile_instance.center_tour_flag = validated_data['center_tour_flag']

        if 'hud_tour_flag' in validated_data:
            profile_instance.hud_tour_flag = validated_data['hud_tour_flag']

        if 'webtop_tour_flag' in validated_data:
            profile_instance.webtop_tour_flag = validated_data['webtop_tour_flag']

        if 'only_508_search_flag' in validated_data:
            profile_instance.only_508_search_flag = validated_data['only_508_search_flag']

        if 'email_notification_flag' in validated_data:
            profile_instance.email_notification_flag = validated_data['email_notification_flag']

        if 'listing_notification_flag' in validated_data:
            profile_instance.listing_notification_flag = validated_data['listing_notification_flag']

        if 'subscription_notification_flag' in validated_data:
            profile_instance.subscription_notification_flag = validated_data['subscription_notification_flag']

        if 'leaving_ozp_warning_flag' in validated_data:
            profile_instance.leaving_ozp_warning_flag = validated_data['leaving_ozp_warning_flag']

        if 'theme' in validated_data:
            profile_instance.theme = validated_data['theme']

        if 'avatar' in validated_data:
            profile_instance.avatar = validated_data['avatar']

        current_request_profile = generic_model_access.get_profile(self.context['request'].user.username)

        if current_request_profile.highest_role() == 'APPS_MALL_STEWARD':
            if validated_data['stewarded_organizations'] is not None:
                profile_instance.stewarded_organizations.clear()
                for org in validated_data['stewarded_organizations']:
                    profile_instance.stewarded_organizations.add(org)

            if 'user' in validated_data:
                user_dict = validated_data['user']
                if 'groups' in user_dict:
                    groups_list = user_dict['groups']
                    if groups_list:
                        profile_instance.user.groups.clear()
                        for group_instance in groups_list:
                            profile_instance.user.groups.add(group_instance)

        if 'work_roles' in validated_data:
            profile_instance.work_roles.clear()
            for work_role in validated_data['work_roles']:
                profile_instance.work_roles.add(work_role)

        if 'storefront_customizations' in validated_data:
            for customization in validated_data['storefront_customizations']:
                profile_model_access.create_or_update_storefront_customization(
                    profile_instance,
                    customization['section'],
                    customization['position'] if 'position' in customization else None,
                    customization['is_hidden'] if 'is_hidden' in customization else None,
                )

        profile_instance.save()
        return profile_instance


class ShortProfileSerializer(serializers.ModelSerializer):
    user = ShortUserSerializer()

    class Meta:
        model = models.Profile
        fields = ('id', 'user', 'display_name', 'dn')

    def to_representation(self, data):
        access_control_instance = plugin_manager.get_system_access_control_plugin()
        ret = super(ShortProfileSerializer, self).to_representation(data)

        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(self.context['request'].user.username)

        check_request_self = False
        if self.context['request'].user.id == ret['id']:
            check_request_self = True

        if anonymize_identifiable_data and not check_request_self:
            ret['display_name'] = access_control_instance.anonymize_value('display_name')
            ret['dn'] = access_control_instance.anonymize_value('dn')

        return ret
