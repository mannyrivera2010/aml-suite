"""
Profile Views
TODO: GET api/profile?role=ORG_STEWARD for view (shown on create/edit listing page)
TODO: POST api/profile/self/library - add listing to library (bookmark)
    params: listing id
TODO: DELETE api/profile/self/library/<id> - unbookmark a listing
"""


import logging

from rest_framework import filters
from rest_framework import viewsets
# from rest_framework.decorators import permission_classes
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import list_route, detail_route

from plugins.plugin_manager import system_anonymize_identifiable_data
from ozpcenter import errors
from ozpcenter import permissions
import ozpcenter.api.profile.serializers as serializers
import ozpcenter.api.listing.serializers as listing_serializers
import ozpcenter.api.storefront.serializers as storefront_serializers
# from ozpcenter import pagination
import ozpcenter.api.profile.model_access as model_access
import ozpcenter.api.listing.model_access as listing_model_access


logger = logging.getLogger('ozp-center.' + str(__name__))


class ProfileViewSet(viewsets.ModelViewSet):
    """
    ModelViewSet for getting all profiles

    Access Control
    ===============
    - All users can read
    - AppsMallSteward can view

    URIs
    ======
    GET /api/profile
    Summary:
        Get a list of all system-wide Profiles
    Response:
        200 - Successful operation - [ProfileSerializer]

    POST /api/profile/
    Summary:
        Add a Profile
    Request:
        data: ProfileSerializer Schema
    Response:
        200 - Successful operation - ProfileSerializer

    GET /api/profile/{pk}
    Summary:
        Find a Profile by ID
    Response:
        200 - Successful operation - ProfileSerializer

    PUT /api/profile/{pk}
    Summary:
        Update a Profile by ID

    PATCH /api/profile/{pk}
    Summary:
        Update (Partial) a Profile by ID

    DELETE /api/profile/{pk}
    Summary:
        Delete a Profile by ID
    """

    permission_classes = (permissions.IsOrgStewardOrReadOnly,)
    serializer_class = serializers.ProfileSerializer
    filter_backends = (filters.SearchFilter,)
    search_fields = ('dn',)

    def get_queryset(self):
        role = self.request.query_params.get('role', None)
        if role:
            queryset = model_access.get_profiles_by_role(role)
        else:
            queryset = model_access.get_all_profiles()
        # support starts-with matching for finding users in the
        # Submit/Edit Listing form
        username_starts_with = self.request.query_params.get(
            'username_starts_with', None)
        if username_starts_with:
            queryset = model_access.filter_queryset_by_username_starts_with(
                queryset, username_starts_with)
        return queryset

    def update(self, request, pk=None):
        current_request_profile = model_access.get_self(request.user.username)
        if current_request_profile.highest_role() != 'APPS_MALL_STEWARD':
            raise errors.PermissionDenied

        profile_instance = self.get_queryset().get(pk=pk)
        serializer = serializers.ProfileSerializer(profile_instance,
            data=request.data, context={'request': request}, partial=True)
        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.RequestException('{0!s}'.format(serializer.errors))

        serializer.save()

        return Response(serializer.data, status=status.HTTP_200_OK)


class ProfileListingViewSet(viewsets.ModelViewSet):
    """
    Get all listings owned by a specific user

    ModelViewSet for getting all profile listings

    Access Control
    ===============
    - All users can view

    URIs
    ======
    POST /api/profile/{pk}/listing/
    Summary:
        Add a Profile Listing
    Request:
        data: ListingSerializer Schema
    Response:
        200 - Successful operation - ListingSerializer

    GET /api/profile/{pk}/listing/
    Summary:
        Find a Profile Listing by ID
    Response:
        200 - Successful operation - ListingSerializer
    """

    permission_classes = (permissions.IsUser,)
    serializer_class = listing_serializers.ListingSerializer

    def get_queryset(self, profile_pk=None, listing_pk=None):
        current_request_username = self.request.user.username

        if listing_pk:
            queryset = model_access.get_all_listings_for_profile_by_id(current_request_username, profile_pk, listing_pk)
        else:
            queryset = model_access.get_all_listings_for_profile_by_id(current_request_username, profile_pk)
        return queryset

    def list(self, request, profile_pk=None):
        """
        Retrieves all listings for a specific profile that they own
        """
        current_request_username = request.user.username
        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(current_request_username)

        if anonymize_identifiable_data:
            return Response([])

        queryset = self.get_queryset(profile_pk)
        page = self.paginate_queryset(queryset)

        if page is not None:
            serializer = listing_serializers.ListingSerializer(page,
                context={'request': request}, many=True)
            response = self.get_paginated_response(serializer.data)
            return response

        serializer = listing_serializers.ListingSerializer(queryset,
            context={'request': request}, many=True)
        return Response(serializer.data)

    def retrieve(self, request, pk, profile_pk=None):
        """
        Retrieves a specific listing for a specific profile that they own
        """
        current_request_username = request.user.username
        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(current_request_username)

        if anonymize_identifiable_data:
            return Response({'detail': 'Permission Denied'}, status=status.HTTP_403_FORBIDDEN)

        queryset = self.get_queryset(profile_pk, pk)

        serializer = listing_serializers.ListingSerializer(queryset,
            context={'request': request})
        return Response(serializer.data)

    def create(self, request, profile_pk=None):
        """
        This method is not supported
        """
        raise errors.NotImplemented('HTTP Verb(POST) Not Supported')

    def update(self, request, pk=None, profile_pk=None):
        """
        This method is not supported
        """
        raise errors.NotImplemented('HTTP Verb(PUT) Not Supported')

    def partial_update(self, request, pk=None, profile_pk=None):
        """
        This method is not supported
        """
        raise errors.NotImplemented('HTTP Verb(PATCH) Not Supported')

    def destroy(self, request, pk=None, profile_pk=None):
        """
        This method is not supported
        """
        raise errors.NotImplemented('HTTP Verb(DELETE) Not Supported')


class ProfileListingVisitCountViewSet(viewsets.ModelViewSet):
    """
    Get listing visit counts for a specific user

    ModelViewSet for getting all profile listing visit counts

    Access Control
    ===============
    - All users can view

    URIs
    ======
    POST /api/profile/{pk}/listingvisit/
    Summary:
        Add a Listing Visit Count for the given listing and profile
    Request:
        data: ListingVisitCountSerializer Schema
    Response:
        200 - Successful operation - ListingVisitCountSerializer

    GET /api/profile/{pk}/listingvisit/
    Summary:
        Find a Listing Visit Count by ID
    Response:
        200 - Successful operation - ListingVisitCountSerializer

    GET /api/profile/{pk}/listingvisit/frequent/
    Summary:
        Get a list of frequently visited listings
    Response:
        200 - Successful operation - StorefrontListingSerializer

    POST /api/profile/{pk}/listingvisit/increment/
    Summary:
        Increments a listing visit for the given profile by 1
    Response:
        200 - Successful operation - ListingVisitCountSerializer

    POST /api/profile/{pk}/listingvisit/clear/
    Summary:
        Sets a listing visit count for the given profile to 0
    Response:
        200 - Successful operation - ListingVisitCountSerializer
    """

    permission_classes = (permissions.IsUser,)
    serializer_class = listing_serializers.ListingVisitCountSerializer

    def get_queryset(self, profile_pk=None, listing_pk=None):
        queryset = model_access.get_listing_visit_counts_for_profile(self.request.user.username, profile_pk, listing_pk)
        return queryset

    @list_route(methods=['get'])
    def frequent(self, request, profile_pk=None):
        """
        Retrieves frequently visited listings for a specific profile
        """
        current_request_username = request.user.username
        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(current_request_username)

        if anonymize_identifiable_data:
            return Response([])

        queryset = model_access.get_frequently_visited_listings(current_request_username, profile_pk)
        page = self.paginate_queryset(queryset)

        if page is not None:
            serializer = storefront_serializers.StorefrontListingSerializer(page,
                context={'request': request}, many=True)
            response = self.get_paginated_response(serializer.data)
            return response

        serializer = storefront_serializers.StorefrontListingSerializer(queryset,
            context={'request': request}, many=True)
        return Response(serializer.data)

    @list_route(methods=['post'])
    def increment(self, request, profile_pk=None):
        """
        Increments a listing visit for the given profile by 1
        """
        if 'listing' not in request.data and 'id' not in request.data['listing']:
            raise errors.InvalidInput('Missing required field listing')

        listing_pk = request.data['listing']['id']
        queryset = self.get_queryset(profile_pk, listing_pk)
        if queryset.exists():
            visit_count = queryset.first()
            request.data['count'] = visit_count.count + 1
            return self.update(request, visit_count.id, profile_pk)
        else:
            request.data['count'] = 1
            return self.create(request, profile_pk)

    @list_route(methods=['post'])
    def clear(self, request, profile_pk=None):
        """
        Clears the listing visit count for the given profile
        """
        if 'listing' not in request.data and 'id' not in request.data['listing']:
            raise errors.InvalidInput('Missing required field listing')

        listing_pk = request.data['listing']['id']
        queryset = self.get_queryset(profile_pk, listing_pk)
        request.data['count'] = 0
        if queryset.exists():
            visit_count = queryset.first()
            return self.update(request, visit_count.id, profile_pk)
        else:
            return self.create(request, profile_pk)

    def list(self, request, profile_pk=None):
        """
        Retrieves all listing visit counts for a specific profile
        """
        current_request_username = request.user.username
        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(current_request_username)

        if anonymize_identifiable_data:
            return Response([])

        queryset = self.get_queryset(profile_pk)
        page = self.paginate_queryset(queryset)

        if page is not None:
            serializer = listing_serializers.ListingVisitCountSerializer(page,
                context={'request': request}, many=True)
            response = self.get_paginated_response(serializer.data)
            return response

        serializer = listing_serializers.ListingVisitCountSerializer(queryset,
            context={'request': request}, many=True)
        return Response(serializer.data)

    def retrieve(self, request, pk, profile_pk=None):
        """
        Retrieves a specific listing visit count for a specific profile
        """
        current_request_username = request.user.username
        # Used to anonymize usernames
        anonymize_identifiable_data = system_anonymize_identifiable_data(current_request_username)

        if anonymize_identifiable_data:
            return Response({'detail': 'Permission Denied'}, status=status.HTTP_403_FORBIDDEN)

        # TODO: implement access control to listing visit data if needed
        visit_count = model_access.get_visit_count_by_id(pk)

        serializer = listing_serializers.ListingVisitCountSerializer(visit_count,
            context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    def create(self, request, profile_pk=None):
        """
        Create a listing visit count
        """
        if profile_pk == 'self':
            profile = model_access.get_self(request.user.username)
        else:
            profile = model_access.get_profile_by_id(profile_pk)
        if 'listing' in request.data and 'id' in request.data['listing']:
            listing = listing_model_access.get_listing_by_id(request.user.username, request.data['listing']['id'], True)
        else:
            listing = None

        serializer = listing_serializers.ListingVisitCountSerializer(data=request.data,
            context={'request': request, 'profile': profile, 'listing': listing}, partial=True)
        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors), extra={'request': request})
            raise errors.ValidationException('{0}'.format(serializer.errors))

        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def update(self, request, pk=None, profile_pk=None):
        """
        Update an existing listing visit count
        """
        if profile_pk == 'self':
            profile = model_access.get_self(request.user.username)
        else:
            profile = model_access.get_profile_by_id(profile_pk)
        if 'listing' in request.data and 'id' in request.data['listing']:
            listing = listing_model_access.get_listing_by_id(request.user.username, request.data['listing']['id'], True)
        else:
            listing = None

        visit_count = model_access.get_visit_count_by_id(pk)

        serializer = listing_serializers.ListingVisitCountSerializer(visit_count, data=request.data,
            context={'request': request, 'profile': profile, 'listing': listing}, partial=True)
        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors), extra={'request': request})
            raise errors.ValidationException('{0}'.format(serializer.errors))

        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)

    def partial_update(self, request, pk=None, profile_pk=None):
        """
        This method is not supported
        """
        raise errors.NotImplemented('HTTP Verb(PATCH) Not Supported')

    def destroy(self, request, pk=None, profile_pk=None):
        """
        Delete an existing listing visit count
        """
        # TODO: implement access control to listing visit data if needed
        visit_count = model_access.get_visit_count_by_id(pk)
        model_access.delete_listing_visit_count(visit_count)
        return Response(status=status.HTTP_204_NO_CONTENT)


class UserViewSet(viewsets.ModelViewSet):
    """
    ModelViewSet for getting all Users

    Access Control
    ===============
    - AppsMallSteward can view

    URIs
    ======
    GET /api/user/
    Summary:
        Get a list of all system-wide Users
    Response:
        200 - Successful operation - [UserSerializer]

    POST /api/user/
    Summary:
        Add a User
    Request:
        data: UserSerializer Schema
    Response:
        200 - Successful operation - UserSerializer

    GET /api/user/{pk}
    Summary:
        Find a User by ID
    Response:
        200 - Successful operation - UserSerializer

    PUT /api/user/{pk}
    Summary:
        Update a User by ID

    PATCH /api/user/{pk}
    Summary:
        Update (Partial) a User by ID

    DELETE /api/user/{pk}
    Summary:
        Delete a User by ID
    """

    permission_classes = (permissions.IsOrgSteward,)
    queryset = model_access.get_all_users()
    serializer_class = serializers.UserSerializer


class GroupViewSet(viewsets.ModelViewSet):
    """
    ModelViewSet for getting all groups

    Access Control
    ===============
    - All users can view

    URIs
    ======
    GET /api/group/
    Summary:
        Get a list of all system-wide Groups
    Response:
        200 - Successful operation - [GroupSerializer]

    POST /api/group/
    Summary:
        Add a Group
    Request:
        data: GroupSerializer Schema
    Response:
        200 - Successful operation - GroupSerializer

    GET /api/group/{pk}
    Summary:
        Find a Group by ID
    Response:
        200 - Successful operation - GroupSerializer

    PUT /api/group/{pk}
    Summary:
        Update a Group by ID

    PATCH /api/group/{pk}
    Summary:
        Update (Partial) a Group by ID

    DELETE /api/group/{pk}
    Summary:
        Delete a Group by ID
    """
    permission_classes = (permissions.IsOrgStewardOrReadOnly,)
    queryset = model_access.get_all_groups()
    serializer_class = serializers.GroupSerializer


class CurrentUserViewSet(viewsets.ViewSet):
    """
    A simple ViewSet for listing or retrieving users.

    Access Control
    ===============
    - All users can view

    URIs
    ======
    GET /api/self/profile/
    Summary:
        Find the Current User
    Response:
        200 - Successful operation - ProfileSerializer

    PUT /api/self/profile/
    Summary:
        Update the Current User

    PATCH /api/self/profile/
    Summary:
        Update (Partial) the Current User
    """

    permission_classes = (permissions.IsUser,)

    def retrieve(self, request):
        current_request_profile = model_access.get_self(request.user.username)
        serializer = serializers.ProfileSerializer(current_request_profile,
            context={'request': request, 'self': True})
        return Response(serializer.data)

    def update(self, request):
        current_request_profile = model_access.get_self(request.user.username)
        serializer = serializers.ProfileSerializer(current_request_profile,
            data=request.data, context={'request': request}, partial=True)
        if not serializer.is_valid():
            logger.error('{0!s}'.format(serializer.errors))
            raise errors.ValidationException('{0!s}'.format(serializer.errors))

        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
