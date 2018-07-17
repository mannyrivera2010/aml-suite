"""
Bookmark Serializers

http://127.0.0.1:8001/api/bookmark/
"""
import logging

from rest_framework import serializers

import ozpcenter.api.bookmark.model_access as model_access

import ozpcenter.models as models

from ozpcenter.api.bookmark import model_access
import ozpcenter.model_access as generic_model_access
from ozpcenter import errors

import ozpcenter.api.listing.model_access as listing_model_access
import ozpcenter.api.image.serializers as image_serializers
import ozpcenter.api.listing.serializers as listing_serializers

from ozpcenter.pipe import pipes
from ozpcenter.pipe import pipeline
from ozpcenter.recommend import recommend_utils

logger = logging.getLogger('ozp-center.' + str(__name__))


class LibraryListingSerializer(serializers.HyperlinkedModelSerializer):
    small_icon = image_serializers.ImageSerializer(required=False)
    large_icon = image_serializers.ImageSerializer(required=False)
    banner_icon = image_serializers.ImageSerializer(required=False)
    owners = listing_serializers.CreateListingProfileSerializer(required=False, allow_null=True, many=True)

    class Meta:
        model = models.Listing
        fields = ('id', 'title', 'unique_name', 'launch_url', 'small_icon',
            'large_icon', 'banner_icon', 'owners', 'security_marking')
        read_only_fields = ('title', 'unique_name', 'launch_url', 'small_icon',
            'large_icon', 'banner_icon', 'owners', 'security_marking')
        # Any AutoFields on your model (which is what the automatically
        # generated id key is) are set to read-only by default when Django
        # REST Framework is creating fields in the background. read-only fields
        # will not be part of validated_data. Override that behavior using the
        # extra_kwargs
        extra_kwargs = {
            "id": {
                "read_only": False,
                "required": False,
            },
        }


class BookmarkPermissionSerializer(serializers.ModelSerializer):
    """
    Serializer for api/bookmark/{bookmark_id}/permission - owner is always current user
    """
    profile = listing_serializers.CreateListingProfileSerializer(required=False, allow_null=True, many=False)
    # bookmark = BookmarkSerializer(many=False, required=False)

    class Meta:
        model = models.BookmarkPermission
        fields = ('id', 'profile', 'created_date', 'modified_date', 'user_type',
            # 'bookmark'
        )
        read_only_fields = ('profile', 'created_date', 'modified_date')

        extra_kwargs = {
            "id": {
                "read_only": False,
                "required": False,
            },
            "profile": {
                "read_only": True,
                "required": False,
            },
        }

    def to_representation(self, data):
        ret = super(BookmarkPermissionSerializer, self).to_representation(data)
        return ret

    def validate(self, data):
        """
        validate
        """
        request_profile = self.context['request'].user.profile
        # data: {'user_type': 'OWNER', 'profile': OrderedDict([('id', 1)])}

        user_type = data.get('user_type')
        # user_type is required field, choices are validate via django non_field_errors
        if not user_type:
            raise errors.ValidationException('user_type field is missing')

        return data

    def create(self, validated_data):
        """
        Create BookmarkPermission entry

        Required Fields:
            pass
        """
        username = self.context['request'].user.username
        request_profile = self.context['request'].user.profile
        bookmark_entry = self.context['bookmark_entry']

        user_type = validated_data.get('user_type')

        target_username = validated_data.get('profile', {}).get('user', {}).get('username')
        if not target_username:
            raise errors.ValidationException('Valid Username is Required')

        target_profile = generic_model_access.get_profile(target_username)

        if not target_profile:
            raise errors.ValidationException('Valid User is Required')

        return model_access.share_bookmark_entry(
            request_profile,
            bookmark_entry,
            target_profile,
            None,
            user_type)

    def update(self, bookmark_permission_entry, validated_data):
        request_profile = self.context['request'].user.profile
        bookmark_entry = self.context['bookmark_entry']
        user_type = validated_data.get('user_type')

        return model_access.update_profile_permission_for_bookmark_entry(
            request_profile, bookmark_permission_entry, user_type)


class BookmarkParentSerializer(serializers.ModelSerializer):
    """
    Serializer for /api/bookmark - owner is always current user
    """
    # bookmark_permission = BookmarkPermissionSerializer(many=True, required=False)

    class Meta:
        model = models.BookmarkEntry
        fields = (
            'title', 'id', 'type'  # , 'bookmark_permission'
        )
        read_only_fields = ('listing', 'bookmark_parent', 'type', 'created_date', 'modified_date', 'title')

        extra_kwargs = {
            "id": {
                "read_only": False,
                "required": False,
            },
        }


class DictField(serializers.ReadOnlyField):
    """
    Read Only Field
    """

    def from_native(self, obj):
        return None


class BookmarkSerializer(serializers.ModelSerializer):
    """
    Serializer for /api/bookmark - owner is always current user
    """
    listing = LibraryListingSerializer(required=False)
    bookmark_parent = BookmarkParentSerializer(many=True, required=False)
    bookmark_permission_self = serializers.SerializerMethodField('get_bookmark_permission')
    children = serializers.ListField(
       child=DictField(), read_only=True
    )

    def get_bookmark_permission(self, container):
        request_profile = self.context['request'].user.profile

        if container.type == 'FOLDER':
            profile_bookmark_permission = container.bookmark_permission.filter(profile=request_profile)
            # profile_bookmark_permission = models.BookmarkPermission.objects.filter(profile=request_profile, bookmark=container).first()
            # print(profile_bookmark_permission)
            # container = BookmarkEntry(40, bookmark_parent,title:InstrumentSharing,type:FOLDER,is_root:False,listing:None)
            return BookmarkPermissionSerializer(profile_bookmark_permission.first(), context={'request': self.context['request']}).data
        else:
            return {}

    class Meta:
        model = models.BookmarkEntry
        fields = (
            'listing', 'bookmark_parent',
            # 'bookmark_permission',  # TODO: Figure out how to do custom queryset for this field, should only show
            'bookmark_permission_self', 'children',
            'id', 'type', 'created_date', 'modified_date', 'title'
        )

        extra_kwargs = {
            "listing": {
                "read_only": False,
                "required": False,
            },
            "title": {
                "read_only": False,
                "required": False,
            },
            # Type is a Required Field
            "type": {
                "read_only": False,
                "required": True,
            },
            # "children": {
            #     "read_only": True,
            #     "required": False,
            # },
        }

    def to_representation(self, data):
        ret = super(BookmarkSerializer, self).to_representation(data)

        # import pprint
        # print(pprint.pprint(ret))
        # if bookmark_parent length is more than or equal to two, it means that folder is shared between users
        if len(ret['bookmark_parent']) >= 2:
            ret['is_shared'] = True
        else:
            ret['is_shared'] = False

        del ret['bookmark_parent']

        if ret['type'] == model_access.LISTING_TYPE:
            del ret['title']  # listing type does not have titles
            del ret['bookmark_permission_self']  # listing type does not have titles
        elif ret['type'] == model_access.FOLDER_TYPE:
            del ret['listing']  # folder type does not have listings

        return ret

    def to_internal_value(self, data):
        ret = super(BookmarkSerializer, self).to_internal_value(data)
        ret['children'] = data.get('children', [])
        if 'children' in ret:
            for child in ret['children']:
                if not isinstance(child, dict):
                    raise errors.ValidationException('children has to be a list of dictionaries')
                if 'id' not in child:
                    raise errors.ValidationException('child in children list of dictionaries is mising id field')

        return ret

    def validate(self, data):
        """
        validate
        """
        request_profile = self.context['request'].user.profile
        username = self.context['request'].user.username

        if 'bookmark_parent' in data:
            bookmark_parent_len = len(data['bookmark_parent'])

            if bookmark_parent_len > 1:
                raise errors.ValidationException('bookmark_parent has more than one folder')
            elif bookmark_parent_len == 1:
                bookmark_parent_id = data['bookmark_parent'][0]['id']
                data['bookmark_parent_object'] = model_access.get_bookmark_entry_by_id(request_profile, bookmark_parent_id)

                if data['bookmark_parent_object'].type != 'FOLDER':
                    raise errors.ValidationException('bookmark_parent entry must be FOLDER')
            elif bookmark_parent_len < 1:
                data['bookmark_parent_object'] = model_access.create_get_user_root_bookmark_folder(request_profile)

        if 'children' in data:
            bookmark_children_ids = []
            for child in data['children']:
                if 'id' in child:
                    bookmark_children_ids.append(child['id'])
            data['bookmark_children'] = bookmark_children_ids

        return data

    def create(self, validated_data):
        """
        Create BOOKMARK entry

        Required Fields:
            * Type
            * `listing id` if type is LISTING
            * `title` if type is folder
        """
        username = self.context['request'].user.username
        request_profile = self.context['request'].user.profile
        bookmark_parent_object = validated_data.get('bookmark_parent_object')
        type = validated_data.get('type')
        bookmark_children = validated_data.get('bookmark_children')
        listing_id = validated_data.get('listing', {}).get('id')

        if type == model_access.LISTING_TYPE:
            if not listing_id:
                raise errors.ValidationException('Listing id entry not found')

            listing = listing_model_access.get_listing_by_id(username, listing_id)

            if not listing:
                raise errors.ValidationException('Listing id entry not found')

            return model_access.create_listing_bookmark_for_profile(
                request_profile,
                listing,
                bookmark_parent_object)

        elif type == model_access.FOLDER_TYPE:
            if 'title' not in validated_data:
                raise errors.ValidationException('No title provided')

            listing = None
            if listing_id:
                listing = listing_model_access.get_listing_by_id(username, listing_id)

                if not listing:
                    raise errors.ValidationException('Listing id entry not found')

            return model_access.create_folder_bookmark_for_profile(
                request_profile,
                validated_data['title'],
                bookmark_parent_object,
                bookmark_children,
                listing)
        else:
            raise errors.ValidationException('No valid type provided')

    def update(self, bookmark_entry_instance, validated_data):
        request_profile = self.context['request'].user.profile
        bookmark_parent_object = validated_data.get('bookmark_parent_object')
        title = validated_data.get('title')

        return model_access.update_bookmark_entry_for_profile(
            request_profile,
            bookmark_entry_instance,
            bookmark_parent_object,
            title)


def _create_folder_listing_queries_and_serialized(request_profile, request, folder_bookmark_entry, is_parent=None, ordering_fields=None):
    """
    Create queries to get folder and listing data

    Args:
        request_profile:
            used to filter profile bookmarks
        request:
            used for serializer to create urls
        folder_bookmark_entry:
        is_parent:
        ordering_fields:
    """
    is_parent = is_parent if is_parent else False
    ordering_fields = ordering_fields if ordering_fields else ['created_date']

    folder_query = models.BookmarkEntry.objects.filter(
        type=model_access.FOLDER_TYPE,
        bookmark_parent__bookmark_permission__profile=request_profile  # Validate to make sure user can see folder
    )

    # for_profile should do `private listing` check for listing
    listing_query = models.BookmarkEntry.objects.for_profile_minus_security_marking(request_profile).filter(
        type=model_access.LISTING_TYPE,
        bookmark_parent__bookmark_permission__profile=request_profile  # Validate to make sure user can see folder,
    )

    folder_order_fields = []
    listing_order_fields = []

    for ordering_field in ordering_fields:
        if ordering_field in model_access.FOLDER_QUERY_ORDER_MAPPING:
            folder_order_fields.append(model_access.FOLDER_QUERY_ORDER_MAPPING[ordering_field])

        if ordering_field in model_access.LISTING_QUERY_ORDER_MAPPING:
            listing_order_fields.append(model_access.LISTING_QUERY_ORDER_MAPPING[ordering_field])

    folder_query = folder_query.order_by(*folder_order_fields)
    listing_query = listing_query.order_by(*listing_order_fields)

    if is_parent:
        folder_query = folder_query.filter(id=folder_bookmark_entry.id)
        listing_query = listing_query.filter(id=folder_bookmark_entry.id)
    else:
        folder_query = folder_query.filter(bookmark_parent=folder_bookmark_entry)
        listing_query = listing_query.filter(bookmark_parent=folder_bookmark_entry)

    folder_data = BookmarkSerializer(folder_query, many=True, context={'request': request}).data
    listing_data = BookmarkSerializer(listing_query, many=True, context={'request': request}).data

    # Filter out all listings that request_profile does not have access to
    listing_data_after_filter = pipeline.Pipeline(recommend_utils.ListIterator(listing_data),
                                    [pipes.BookmarkListingDictPostSecurityMarkingCheckPipe(request_profile.user.username)]).to_list()

    return {"folder_data": folder_data,
            "listing_data_after_filter": listing_data_after_filter}


def get_bookmark_tree(request_profile, request, folder_bookmark_entry=None, is_parent=None, ordering_fields=None):
    """
    Helper Function to get all nested bookmark

    Args:
        request_profile
        request
        folder_bookmark_entry
        is_parent
    """
    folder_bookmark_entry = folder_bookmark_entry if folder_bookmark_entry else model_access.create_get_user_root_bookmark_folder(request_profile)
    is_parent = is_parent if is_parent is not None else False

    bookmarks_dict = _create_folder_listing_queries_and_serialized(
        request_profile, request, folder_bookmark_entry, is_parent, ordering_fields=ordering_fields)

    return {
        "folders": _get_nested_bookmarks_tree(request_profile, bookmarks_dict['folder_data'], request=request, ordering_fields=ordering_fields),
        # "folders": bookmarks_dict['folder_data'],
        "listings": bookmarks_dict['listing_data_after_filter']
    }


def _get_nested_bookmarks_tree(request_profile, data, serialized=False, request=None, ordering_fields=None):
    """
    Recursive function to get all the nested folder and listings
    """
    output = []
    for current_record in data:
        if current_record.get('type') == 'FOLDER':
            bookmarks_dict = _create_folder_listing_queries_and_serialized(
                request_profile, request, current_record['id'], ordering_fields=ordering_fields)

            current_record['children'] = {
                "folders": _get_nested_bookmarks_tree(request_profile, bookmarks_dict['folder_data'], request=request, ordering_fields=ordering_fields),
                "listings": bookmarks_dict['listing_data_after_filter']
            }

        output.append(current_record)
    return output
