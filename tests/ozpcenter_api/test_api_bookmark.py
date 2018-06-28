"""
Test bookmark

TEST_MODE=True pytest tests/ozpcenter_api/test_api_bookmark.py

[
    {
        "id": 3,
        "type": "FOLDER",
        "title": "Animals",
        "is_shared": False,
        "children":[
            {
                "id": 4,
                "type": "LISTING",
                "title": "Killer Whale"
            },
            {
                "id": 5,
                "type": "LISTING",
                "title": "Lion Finder"
            }
        ]
    },
    {
        "id": 6,
        "type": "LISTING",
        "title": "Parrotlet"
    }
]

Nodes()
    .parse(data)
    .move('/Animals/Killer Whale')
    .to('/')
    .search('/Killer Whale').id()
"""
from django.test import override_settings
from tests.ozp.cases import APITestCase

from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_dict
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


def find_first_shared_folder(data):
    is_dict_boolean = isinstance(data, dict)
    is_root_object = is_dict_boolean and 'folders' in data and 'listings' in data

    for record in data.get('folders', []):
        if record.get('type') == 'FOLDER' and record.get('is_shared') is True:
            return record
    return {}


def shorthand_permissions(data):
    """
    Convert Bookmark Permission endpoint data to simple strings

    [{id": 6,
     "profile": { ...,"user": { "username": "bigbrother" },}, ...,
     "user_type": "OWNER" }]
    TO
    ['bigbrother(OWNER)']
    """
    output = []
    for record in data:
        username = record.get('profile', {}).get('user', {}).get('username')
        output.append('{}({})'.format(username, record.get('user_type')))
    return output


def shorthand_shared_folder(data, level=0):
    """
    Shorthand Shared Folder
    Helper Function to create shorten version of tree
    """
    is_dict_boolean = isinstance(data, dict)
    is_list_boolean = isinstance(data, list)
    is_root_object = is_dict_boolean and 'folders' in data and 'listings' in data

    if not data:
        return {}
    elif is_root_object:
        folders = data.get('folders', [])
        listings = data.get('listings', [])

        output = []

        for folders in folders:
            output.append(shorthand_shared_folder(folders, level))

        for listings in listings:
            output.append(shorthand_shared_folder(listings, level))

        return '\n'.join(output)
    elif is_list_boolean:
        output = []

        for record in data:
            output.append(shorthand_shared_folder(record, level))

        return '\n'.join(output)
    elif is_dict_boolean:
        output = []

        type = data['type']

        if type == 'FOLDER':
            if data['is_shared']:
                output.append('{}({}) {}'.format(' ' * level, 'SF', data['title']))
            else:
                output.append('{}({}) {}'.format(' ' * level, 'F', data['title']))

            if 'children' in data:
                output.append(shorthand_shared_folder(data['children'], level + 1))

        elif type == 'LISTING':
            output.append('{}({}) {}'.format(' ' * level, 'L', data['listing']['title']))

        return '\n'.join(output)


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
            '(L) Stop sign'
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

    def _get_bookmarks_and_check_for_user(self, username, expected_results):
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username=username, status_code=200)
        shorten_data = shorthand_shared_folder(response.data).split("\n")
        # sorted by type, created_date
        self.assertEqual(shorten_data, expected_results, 'username:{}'.format(username))
        return response.data

    def _get_folder_permission(self, username, folder_id, permission_shorthand_expected, status_code=200):
        # Check for permission
        url = '/api/bookmark/{}/permission/'.format(folder_id)
        response = APITestHelper.request(self, url, 'GET', username=username, status_code=status_code)

        if status_code == 200:
            permission_shorthand = shorthand_permissions(response.data)
            self.assertEqual(permission_shorthand, permission_shorthand_expected)
        elif status_code == 403:
            self.assertEqual(response.data.get('error_code'), 'permission_denied')

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_get_bookmark_list_admin_disable_listing(self):
        """
        Check for bookmarks when listing owner disables listing, it should not be visable
        """
        pass

    def test_get_bookmark_list_admin(self):
        self._get_bookmarks_and_check_for_user('bigbrother', self.bigbrother_expected_bookmarks)

    def test_get_bookmark_list_shared_folder_permissions(self):
        """
        Test getting permissions for a shared folder, test between owner, viewer, other
        """
        username = 'bigbrother2'
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username=username, status_code=200)
        bigbrother2_bookmarks = response.data
        # Getting the id of the first shared folder
        shared_folder_id = find_first_shared_folder(bigbrother2_bookmarks).get('id')

        bigbrother2_permission_shorthand_expected = [
            'bigbrother2(OWNER)',
            'julia(OWNER)',
            'johnson(VIEWER)'
        ]

        # Check OWNER permission
        self._get_folder_permission('bigbrother2', shared_folder_id, bigbrother2_permission_shorthand_expected)
        # Check OWNER permission
        self._get_folder_permission('julia', shared_folder_id, bigbrother2_permission_shorthand_expected)
        # Check VIEWER permission
        self._get_folder_permission('johnson', shared_folder_id, bigbrother2_permission_shorthand_expected, status_code=403)
        # Check OTHER permission
        self._get_folder_permission('bigbrother', shared_folder_id, bigbrother2_permission_shorthand_expected, status_code=403)

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

        bigbrother2_bookmarks = self._get_bookmarks_and_check_for_user('bigbrother2', bigbrother2_expected_bookmarks)  # OWNER
        julia_bookmarks = self._get_bookmarks_and_check_for_user('julia', julia_expected_bookmarks)  # OWNER
        johnson_bookmarks = self._get_bookmarks_and_check_for_user('johnson', johnson_expected_bookmarks)  # VIEWER

        # Getting the id of the first shared folder
        shared_folder_id = find_first_shared_folder(bigbrother2_bookmarks).get('id')

        # Create Listing bookmark under shared_folder_bookmark
        url = '/api/bookmark/'
        # TODO: How to elimate listing id from call
        data = {"type": "LISTING", "listing": {"id": 2}, "bookmark_parent": [{"id": shared_folder_id}]}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother2', status_code=201)
        shorten_data = shorthand_dict(response.data, include_keys=['is_shared', 'listing', 'listing.title', 'type'])
        shorten_shared_data = [' ' + record for record in shorthand_shared_folder(response.data).split("\n")]

        expected_results = "(is_shared:False,listing:(title:Air Mail),type:LISTING)"
        self.assertEqual(shorten_data, expected_results)

        # Add recently added bookmark to folder
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
        bigbrother2_bookmarks = self._get_bookmarks_and_check_for_user('bigbrother2', bigbrother2_expected_bookmarks)  # OWNER
        julia_bookmarks = self._get_bookmarks_and_check_for_user('julia', julia_expected_bookmarks)  # OWNER
        johnson_bookmarks = self._get_bookmarks_and_check_for_user('johnson', johnson_expected_bookmarks)  # VIEWER

        # TODO: Delete recently added bookmark

    def test_get_bookmark_list_steward(self):
        self._get_bookmarks_and_check_for_user('wsmith', self.wsmith_expected_bookmarks)

    def test_listing_bookmark_owner_create_delete(self):
        """
        Test for creating listing bookmark under a non-shared folder and deleting same bookmark

        Steps:
            1. Validate existing bookmarks for bigbrother
            2. Add a listing bookmark under root folder for bigbrother
            3. Validate existing
        """
        # Verify bookmarks
        self._get_bookmarks_and_check_for_user('bigbrother', self.bigbrother_expected_bookmarks)

        # Create Listing bookmark
        url = '/api/bookmark/'
        # TODO: How to elimate listing id from call
        data = {"type": "LISTING", "listing": {"id": 2}}
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)
        shorten_data = shorthand_dict(response.data, include_keys=['is_shared', 'listing', 'listing.title', 'type'])
        shorten_shared_data = shorthand_shared_folder(response.data).split("\n")

        expected_results = "(is_shared:False,listing:(title:Air Mail),type:LISTING)"
        self.assertEqual(shorten_data, expected_results)

        # Verify bookmarks
        expected_results = self.bigbrother_expected_bookmarks
        expected_results.extend(shorten_shared_data)

        self._get_bookmarks_and_check_for_user('bigbrother', expected_results)
