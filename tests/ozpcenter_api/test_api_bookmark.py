"""
Test bookmark

TEST_MODE=True pytest tests/ozpcenter_api/test_api_bookmark.py
"""
from django.test import override_settings
from tests.ozp.cases import APITestCase

from ozpcenter.bookmark_helper import BookmarkFolder, BookmarkListing, shorthand_permissions
from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_dict
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


def _compare_bookmarks(test_case_instance, expected_library_object, params_tuples=None):
    """
    Compare Bookmarks Helper
    """
    usernames = [bookmark.title for bookmark in expected_library_object.bookmark_objects]
    params_tuples = params_tuples if params_tuples else []

    root_folder = BookmarkFolder(None)

    for username in usernames:
        user_folder_bookmark = root_folder.add_folder_bookmark(username)

        url = '/api/bookmark/'

        if params_tuples:
            params_string = '&'.join(['{}={}'.format(current_tuple[0], current_tuple[1]) for current_tuple in params_tuples])
            url = '{}?{}'.format(url, params_string)

        response = APITestHelper.request(test_case_instance, url, 'GET', username=username, status_code=200)
        actual_library = BookmarkFolder.parse_endpoint(response.data)
        user_folder_bookmark.add_bookmark_object(actual_library)

    actual_bookmarks = root_folder.shorten_data(order=False)
    expected_bookmarks = expected_library_object.shorten_data(order=False)

    test_case_instance.assertEqual(actual_bookmarks, expected_bookmarks)
    return root_folder


def _get_folder_permission(testcase_instance, username, folder_id, permission_shorthand_expected, status_code=200):
    """
    Helper Function to get folder permissions
    """
    # Check for permission
    url = '/api/bookmark/{}/permission/'.format(folder_id)
    response = APITestHelper.request(testcase_instance, url, 'GET', username=username, status_code=status_code)

    if status_code == 200:
        permission_shorthand = shorthand_permissions(response.data)
        testcase_instance.assertEqual(permission_shorthand, permission_shorthand_expected)
    elif status_code == 403:
        testcase_instance.assertEqual(response.data.get('error_code'), 'permission_denied')


def _create_bookmark_folder(testcase_instance, username, folder_title, listing_id=None, shared_folder_id=None):
    """
    Create Listing bookmark under shared_folder_bookmark

    CREATE [LISTING/FOLDER] BOOKMARK FOR USER {username} WHERE LISTING = {listing_id}
    """
    url = '/api/bookmark/'
    data = {"type": "FOLDER", "title": folder_title}

    if listing_id:
        data['listing'] = {}
        data['listing']['id'] = listing_id

    if shared_folder_id:
        data['bookmark_parent'] = [{"id": shared_folder_id}]

    response = APITestHelper.request(testcase_instance, url, 'POST', data=data, username=username, status_code=201)

    shorten_data = shorthand_dict(response.data, include_keys=['is_shared', 'type', 'title'])
    expected_results = "(is_shared:False,title:{},type:FOLDER)".format(folder_title)
    testcase_instance.assertEqual(shorten_data, expected_results)
    return response


def _create_bookmark_listing(testcase_instance, username, listing_id, listing_title, shared_folder_id=None):
    """
    Create Listing bookmark under shared_folder_bookmark

    CREATE [LISTING/FOLDER] BOOKMARK FOR USER {username} WHERE LISTING = {listing_id}
    """
    url = '/api/bookmark/'
    # TODO: How to elimate listing id from call
    data = {"type": "LISTING", "listing": {"id": listing_id}}

    if shared_folder_id:
        data['bookmark_parent'] = [{"id": shared_folder_id}]

    response = APITestHelper.request(testcase_instance, url, 'POST', data=data, username=username, status_code=201)

    shorten_data = shorthand_dict(response.data, include_keys=['is_shared', 'listing', 'listing.title', 'type'])
    expected_results = "(is_shared:False,listing:(title:{}),type:LISTING)".format(listing_title)
    testcase_instance.assertEqual(shorten_data, expected_results)
    return response


@override_settings(ES_ENABLED=False)
class BookmarkApiTest(APITestCase):
    """
    BookmarkApiTest
    Unit Tests for bookmark feature

    What to test:
        look at the top of ozpcenter.api.bookmark.model_access
    """

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None

        self.library = [
            '(F) bigbrother',
            ' (F) Animals',
            '  (L) Killer Whale',
            '  (L) Lion Finder',
            '  (L) Monkey Finder',
            '  (L) Parrotlet',
            '  (L) White Horse',
            '  (L) Wolf Finder',
            ' (F) Instruments',
            '  (L) Acoustic Guitar',
            '  (L) Electric Guitar',
            '  (L) Electric Piano',
            '  (L) Piano',
            '  (L) Sound Mixer',
            '  (L) Violin',
            ' (F) Weather',
            '  (L) Lightning',
            '  (L) Snow',
            '  (L) Tornado',
            ' (L) Bread Basket',
            ' (L) Chain boat navigation',
            ' (L) Chart Course',
            ' (L) Gallery of Maps',
            ' (L) Informational Book',
            ' (L) Stop sign',
            '(F) bigbrother2',
            ' (SF) InstrumentSharing',
            '  (L) Acoustic Guitar',
            ' (L) Alingano Maisu',
            '(F) julia',
            ' (SF) InstrumentSharing',
            '  (L) Acoustic Guitar',
            ' (L) Astrology software',
            '(F) johnson',
            ' (SF) InstrumentSharing',
            '  (L) Acoustic Guitar',
            ' (L) Applied Ethics Inc.',
            '(F) wsmith',
            ' (F) heros',
            '  (L) Iron Man',
            '  (L) Jean Grey',
            '  (L) Mallrats',
            ' (F) old',
            '  (L) Air Mail',
            '  (L) Bread Basket',
            ' (F) planets',
            '  (L) Azeroth',
            '  (L) Saturn',
            ' (L) Baltimore Ravens',
            ' (L) Diamond',
            ' (L) Grandfather clock'
        ]
        self.library_object = BookmarkFolder.parse_shorthand_list(self.library)

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_bookmark_list_all_users(self):
        """
        Check bookmarks for all users under library_object
        """
        _compare_bookmarks(self, self.library_object)

    def test_bookmark_list_all_users_filter_shared_none(self):
        """
        Check bookmarks for all users under library_object filter for shared and non shared
        """
        new_library_object = _compare_bookmarks(self, self.library_object)
        new_library_object = _compare_bookmarks(self, new_library_object, [('is_shared', 'none')])

    def test_bookmark_list_all_users_filter_shared_false(self):
        """
        Check bookmarks for all users under library_object filter for non shared
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        new_library_object.search('/bigbrother2/InstrumentSharing/').hidden(True)
        new_library_object.search('/julia/InstrumentSharing/').hidden(True)
        new_library_object.search('/johnson/InstrumentSharing/').hidden(True)

        new_library_object = _compare_bookmarks(self, new_library_object, [('is_shared', 'false')])

    def test_bookmark_list_all_users_filter_shared_true(self):
        """
        Check bookmarks for all users under library_object filter for non shared
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        new_library_object.search('/bigbrother/Animals/').hidden(True)
        new_library_object.search('/bigbrother/Instruments/').hidden(True)
        new_library_object.search('/bigbrother/Weather/').hidden(True)
        new_library_object.search('/bigbrother/Bread Basket').hidden(True)
        new_library_object.search('/bigbrother/Chain boat navigation').hidden(True)
        new_library_object.search('/bigbrother/Chart Course').hidden(True)
        new_library_object.search('/bigbrother/Gallery of Maps').hidden(True)
        new_library_object.search('/bigbrother/Informational Book').hidden(True)
        new_library_object.search('/bigbrother/Stop sign').hidden(True)

        new_library_object.search('/bigbrother2/InstrumentSharing/').hidden(False)
        new_library_object.search('/bigbrother2/Alingano Maisu').hidden(True)

        new_library_object.search('/julia/InstrumentSharing/').hidden(False)
        new_library_object.search('/julia/Astrology software').hidden(True)

        new_library_object.search('/johnson/InstrumentSharing/').hidden(False)
        new_library_object.search('/johnson/Applied Ethics Inc.').hidden(True)

        new_library_object.search('/wsmith/heros/').hidden(True)
        new_library_object.search('/wsmith/old/').hidden(True)
        new_library_object.search('/wsmith/planets/').hidden(True)
        new_library_object.search('/wsmith/Baltimore Ravens').hidden(True)
        new_library_object.search('/wsmith/Diamond').hidden(True)
        new_library_object.search('/wsmith/Grandfather clock').hidden(True)

        new_library_object = _compare_bookmarks(self, new_library_object, [('is_shared', 'true')])

    def test_get_bookmark_list_admin_disable_listing(self):
        """
        Check for bookmarks when listing owner disables listing, it should not be visable
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        bigbrother_listing = new_library_object.search('/bigbrother/').first_listing_bookmark()
        # Disable Listing
        APITestHelper.edit_listing(self, bigbrother_listing.listing_id, {'is_enabled': False}, 'bigbrother')

        bigbrother_listing.hidden(True)

        _compare_bookmarks(self, new_library_object)

        APITestHelper.edit_listing(self, bigbrother_listing.listing_id, {'is_enabled': True}, 'bigbrother')

        bigbrother_listing.hidden(False)

        _compare_bookmarks(self, new_library_object)

    def test_get_bookmark_list_copy_folder(self):
        """
        Check for bookmarks when copying
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        bigbrother_listing = new_library_object.search('/bigbrother/').first_folder_bookmark()

        username = 'bigbrother'
        url = '/api/bookmark/{}/copy/'.format(bigbrother_listing.id)
        response = APITestHelper.request(self, url, 'POST', data={}, username=username, status_code=200)
        # TODO: check response

        new_library_object.copy(
            '/bigbrother/{}/'.format(bigbrother_listing.title),
            '/bigbrother/',
            '{}(COPY)'.format(bigbrother_listing.title)
        )

        _compare_bookmarks(self, new_library_object)

    def test_get_bookmark_list_copy_listing(self):
        """
        Check for bookmarks when copying
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        bigbrother_listing = new_library_object.search('/bigbrother/').first_listing_bookmark()

        username = 'bigbrother'
        url = '/api/bookmark/{}/copy/'.format(bigbrother_listing.id)
        response = APITestHelper.request(self, url, 'POST', data={}, username=username, status_code=200)
        # TODO: check response

        # TODO: Get PWD / bigbrother_listing.pwd() = '/bigbrother/Animals/{}'.format(bigbrother_listing.title)
        new_library_object.copy(
            '/bigbrother/Animals/{}'.format(bigbrother_listing.title),
            '/bigbrother/')

        _compare_bookmarks(self, new_library_object)

    def test_listing_bookmark_owner_create_delete(self):
        """
        Test for creating listing bookmark under a non-shared folder and deleting same bookmark

        Steps:
            1. Validate existing bookmarks for bigbrother
            2. Add a listing bookmark under root folder for bigbrother
            3. Validate existing
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        response = _create_bookmark_listing(self, 'bigbrother', 2, 'Air Mail')
        # Verify bookmarks
        new_library_object.search('/bigbrother/').add_listing_bookmark('Air Mail')

        new_library_object = _compare_bookmarks(self, new_library_object)

        username = 'bigbrother'
        url = '/api/bookmark/{}/'.format(response.data['id'])
        response = APITestHelper.request(self, url, 'DELETE', username=username, status_code=204)

        new_library_object.search_delete('/bigbrother/Air Mail')

        new_library_object = _compare_bookmarks(self, new_library_object)

    def test_folder_bookmark_owner_create_delete(self):
        """
        Test for creating listing bookmark under a non-shared folder and deleting same bookmark

        Steps:
            1. Validate existing bookmarks for bigbrother
            2. Add a listing bookmark under root folder for bigbrother
            3. Validate existing
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        response = _create_bookmark_folder(self, 'bigbrother', 'Test Folder 1')
        # Verify bookmarks
        new_library_object.search('/bigbrother/').add_folder_bookmark('Test Folder 1')

        new_library_object = _compare_bookmarks(self, new_library_object)

        username = 'bigbrother'
        url = '/api/bookmark/{}/'.format(response.data['id'])
        response = APITestHelper.request(self, url, 'DELETE', username=username, status_code=204)

        new_library_object.search_delete('/bigbrother/Test Folder 1/')

        new_library_object = _compare_bookmarks(self, new_library_object)

    def test_folder_bookmark_listing_owner_create_delete(self):
        """
        Test for creating listing bookmark under a non-shared folder and deleting same bookmark

        Steps:
            1. Validate existing bookmarks for bigbrother
            2. Add a listing bookmark under root folder for bigbrother
            3. Validate existing
        """
        new_library_object = _compare_bookmarks(self, self.library_object)

        response = _create_bookmark_folder(self, 'bigbrother', 'Test Folder 2', listing_id=2)
        # Verify bookmarks
        new_library_object.search('/bigbrother/').add_folder_bookmark('Test Folder 2')
        new_library_object.search('/bigbrother/Test Folder 2/').add_listing_bookmark('Air Mail')

        new_library_object = _compare_bookmarks(self, new_library_object)

        username = 'bigbrother'
        url = '/api/bookmark/{}/'.format(response.data['id'])
        response = APITestHelper.request(self, url, 'DELETE', username=username, status_code=204)

        new_library_object.search_delete('/bigbrother/Test Folder 2/')

        new_library_object = _compare_bookmarks(self, new_library_object)

    def test_get_shared_folder_list_create_delete(self):
        """
        test_get_bookmark_list_shared_folder

        test checks for shared folders (InstrumentSharing)
        """
        new_library_object = _compare_bookmarks(self, self.library_object)
        shared_folder_id = new_library_object.search('/bigbrother2/').first_shared_folder().id

        response = _create_bookmark_listing(self, 'bigbrother2', 2, 'Air Mail', shared_folder_id)

        new_library_object.search('/bigbrother2/').first_shared_folder().add_listing_bookmark('Air Mail')
        new_library_object.search('/julia/').first_shared_folder().add_listing_bookmark('Air Mail')
        new_library_object.search('/johnson/').first_shared_folder().add_listing_bookmark('Air Mail')

        new_library_object = _compare_bookmarks(self, new_library_object)

        username = 'bigbrother2'
        url = '/api/bookmark/{}/'.format(response.data['id'])
        response = APITestHelper.request(self, url, 'DELETE', username=username, status_code=204)

        new_library_object.search_delete('/bigbrother2/InstrumentSharing/Air Mail')
        new_library_object.search_delete('/julia/InstrumentSharing/Air Mail')
        new_library_object.search_delete('/johnson/InstrumentSharing/Air Mail')

        _compare_bookmarks(self, new_library_object)

    def test_get_bookmark_list_shared_folder_permissions(self):
        """
        Test getting permissions for a shared folder, test between owner, viewer, other
        """
        username = 'bigbrother2'
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username=username, status_code=200)
        bookmark_folder = BookmarkFolder.parse_endpoint(response.data)
        # Getting the id of the first shared folder
        shared_folder_id = bookmark_folder.first_shared_folder().id

        bigbrother2_permission_shorthand_expected = [
            'bigbrother2(OWNER)',
            'julia(OWNER)',
            'johnson(VIEWER)'
        ]

        # Check OWNER permission
        _get_folder_permission(self, 'bigbrother2', shared_folder_id, bigbrother2_permission_shorthand_expected)
        # Check OWNER permission
        _get_folder_permission(self, 'julia', shared_folder_id, bigbrother2_permission_shorthand_expected)
        # Check VIEWER permission
        _get_folder_permission(self, 'johnson', shared_folder_id, bigbrother2_permission_shorthand_expected, status_code=403)
        # Check OTHER permission
        _get_folder_permission(self, 'bigbrother', shared_folder_id, bigbrother2_permission_shorthand_expected, status_code=403)
