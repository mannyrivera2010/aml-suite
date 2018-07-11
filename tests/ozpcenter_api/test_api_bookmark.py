"""
Test bookmark

TEST_MODE=True pytest tests/ozpcenter_api/test_api_bookmark.py

Nodes()
    .parse(data)
    .move('/Animals/Killer Whale')
    .to('/')
    .search('/Killer Whale').id()
"""
from django.test import override_settings
from tests.ozp.cases import APITestCase

from tests.ozp.bookmark_helper import BookmarkFolder, BookmarkListing, shorthand_permissions
from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_dict
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


def _get_bookmarks_and_check_for_user(testcase_instance, username, expected_results):
    """
    Helper Function to get bookmarks for user and check bookmarks against expected_results
    """
    url = '/api/bookmark/'
    response = APITestHelper.request(testcase_instance, url, 'GET', username=username, status_code=200)
    bookmark_folder = BookmarkFolder.parse_endpoint(response.data)
    shorten_data = bookmark_folder.shorten_data()
    # sorted by type, created_date
    # import pprint
    # print('--shorten_data--:{}'.format(username))
    # pprint.pprint(shorten_data)
    # print('--expected_results--:{}'.format(username))
    # pprint.pprint(expected_results)
    # print('===========')
    testcase_instance.assertEqual(shorten_data, expected_results, 'username:{}'.format(username))
    return response.data


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


def _create_bookmark_listing(testcase_instance, username, listing_id, listing_title, shared_folder_id=None):
    # Create Listing bookmark under shared_folder_bookmark
    url = '/api/bookmark/'
    # TODO: How to elimate listing id from call
    data = {"type": "LISTING", "listing": {"id": 2}}

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

        self.bigbrother_expected_bookmarks = [
            '(F) Animals',
            ' (L) Killer Whale',
            ' (L) Lion Finder',
            ' (L) Monkey Finder',
            ' (L) Parrotlet',
            ' (L) White Horse',
            ' (L) Wolf Finder',
            '(F) Instruments',
            ' (L) Acoustic Guitar',
            ' (L) Electric Guitar',
            ' (L) Electric Piano',
            ' (L) Piano',
            ' (L) Sound Mixer',
            ' (L) Violin',
            '(F) Weather',
            ' (L) Lightning',
            ' (L) Snow',
            ' (L) Tornado',
            '(L) Bread Basket',
            '(L) Chain boat navigation',
            '(L) Chart Course',
            '(L) Gallery of Maps',
            '(L) Informational Book',
            '(L) Stop sign',
            # '(L) Stop 1'
        ]

        self.wsmith_expected_bookmarks = [
            '(F) heros',
            ' (L) Iron Man',
            ' (L) Jean Grey',
            ' (L) Mallrats',
            '(F) old',
            ' (L) Air Mail',
            ' (L) Bread Basket',
            '(F) planets',
            ' (L) Azeroth',
            ' (L) Saturn',
            '(L) Baltimore Ravens',
            '(L) Diamond',
            '(L) Grandfather clock'
        ]

        self.one_listing_expected_bookmarks = [
            '(L) Hello'
        ]

        self.nested_expected_bookmarks = [
            '(F) Folder 1',
            ' (SF) Folder 1.1',
            ' (F) Folder 1.2',
            ' (F) Folder 1.3',
            '  (L) Listing 1.3.1',
            ' (L) Listing 1.1.1',
            '(F) Folder 2'
        ]

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_bookmark_folder_parse_shorthand(self):
        """
        Testing parse_shorthand_list method
        """
        bookmark_folder = BookmarkFolder.parse_shorthand_list(self.bigbrother_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), self.bigbrother_expected_bookmarks)

        bookmark_folder = BookmarkFolder.parse_shorthand_list(self.wsmith_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), self.wsmith_expected_bookmarks)

        bookmark_folder = BookmarkFolder.parse_shorthand_list(self.one_listing_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), self.one_listing_expected_bookmarks)

    def test_bookmark_folder_parse_shorthand_complex(self):
        bookmark_folder = BookmarkFolder.parse_shorthand_list(self.nested_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), self.nested_expected_bookmarks)

    def test_get_bookmark_list_admin_disable_listing(self):
        """
        Check for bookmarks when listing owner disables listing, it should not be visable
        """
        pass

    def test_bookmark_list_admin(self):
        """
        Check bookmarks for admin (bigbrother)
        """
        _get_bookmarks_and_check_for_user(self, 'bigbrother', self.bigbrother_expected_bookmarks)

    def test_bookmark_list_steward(self):
        """
        Test for checking bookmarks for wsmith user
        """
        _get_bookmarks_and_check_for_user(self, 'wsmith', self.wsmith_expected_bookmarks)

    def test_get_bookmark_list_shared_folder(self):
        """
        test_get_bookmark_list_shared_folder

        test checks for shared folders (InstrumentSharing)
        """
        shared_folder_bookmarks = [
            '(SF) InstrumentSharing',
            ' (L) Acoustic Guitar',
        ]

        bigbrother2_expected_bookmarks = shared_folder_bookmarks + [
            '(L) Alingano Maisu'
        ]

        julia_expected_bookmarks = shared_folder_bookmarks + [
            '(L) Astrology software'
        ]

        johnson_expected_bookmarks = shared_folder_bookmarks + [
            '(L) Applied Ethics Inc.'
        ]

        bigbrother2_bookmarks = _get_bookmarks_and_check_for_user(self, 'bigbrother2', bigbrother2_expected_bookmarks)  # OWNER
        julia_bookmarks = _get_bookmarks_and_check_for_user(self, 'julia', julia_expected_bookmarks)  # OWNER
        johnson_bookmarks = _get_bookmarks_and_check_for_user(self, 'johnson', johnson_expected_bookmarks)  # VIEWER

        # Getting the id of the first shared folder
        shared_folder_id = BookmarkFolder.parse_endpoint(bigbrother2_bookmarks).first_shared_folder().id

        response = _create_bookmark_listing(self, 'bigbrother2', 2, 'Air Mail', shared_folder_id)
        # Add recently added bookmark to folder
        shorten_shared_data = [' {}'.format(r) for r in BookmarkListing.parse_endpoint(response.data).shorten_data()]
        shared_folder_bookmarks.extend(shorten_shared_data)

        bigbrother2_expected_bookmarks = shared_folder_bookmarks + [
            '(L) Alingano Maisu'
        ]

        julia_expected_bookmarks = shared_folder_bookmarks + [
            '(L) Astrology software'
        ]

        johnson_expected_bookmarks = shared_folder_bookmarks + [
            '(L) Applied Ethics Inc.'
        ]

        # All users should be able to see the recently added bookmark under shared folder
        bigbrother2_bookmarks = _get_bookmarks_and_check_for_user(self, 'bigbrother2', bigbrother2_expected_bookmarks)  # OWNER
        julia_bookmarks = _get_bookmarks_and_check_for_user(self, 'julia', julia_expected_bookmarks)  # OWNER
        johnson_bookmarks = _get_bookmarks_and_check_for_user(self, 'johnson', johnson_expected_bookmarks)  # VIEWER

        # TODO: Delete recently added bookmark

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

    def test_listing_bookmark_owner_create_delete(self):
        """
        Test for creating listing bookmark under a non-shared folder and deleting same bookmark

        Steps:
            1. Validate existing bookmarks for bigbrother
            2. Add a listing bookmark under root folder for bigbrother
            3. Validate existing
        """
        # Verify bookmarks
        _get_bookmarks_and_check_for_user(self, 'bigbrother', self.bigbrother_expected_bookmarks)

        response = _create_bookmark_listing(self, 'bigbrother', 2, 'Air Mail')
        # Verify bookmarks
        shorten_shared_data = BookmarkListing.parse_endpoint(response.data).shorten_data()
        expected_results = self.bigbrother_expected_bookmarks + shorten_shared_data
        _get_bookmarks_and_check_for_user(self, 'bigbrother', expected_results)
