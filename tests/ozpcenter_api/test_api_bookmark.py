"""
Test bookmark

TEST_MODE=True pytest tests/ozpcenter_api/test_api_bookmark.py

Nodes()
    .parse(data)
    .move('/Animals/Killer Whale')
    .to('/')
    .search('/Killer Whale').id()
"""
import re

from django.test import override_settings
from tests.ozp.cases import APITestCase

from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_dict
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


def _bookmark_node_parse_shorthand(data):
    """
    Convert Shorthand Data into BookmarkFolder

    Actions: (BOOKMARK CLASS _ FOLDER STACK ACTION)
        CF_PU: CREATE_FOLDER_PUSH_PEEK
            0-F   0-None
            1-F   0-F
        CF_PO: CREATE_FOLDER_POP_PUSH_PEEK
            0-F   1-L
            0-F   0-F
        CL_PE: CREATE_LISTING_PEEK
            1-F   0-L    0-NONE
            2-L   0-L    0-L
        CL_PO: CREATE_LISTING_POP_PEEK
            1-L   1-F
            0-L   0-L

    Args:
        data:
            ['(F) heros',
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
             '(L) Grandfather clock']

            0 - F -  heros
            1 - L -  Iron Man
            1 - L -  Jean Grey
            1 - L -  Mallrats
            0 - F -  old
            1 - L -  Air Mail
            1 - L -  Bread Basket
            0 - F -  planets
            1 - L -  Azeroth
            1 - L -  Saturn
            0 - L -  Baltimore Ravens
            0 - L -  Diamond
            0 - L -  Grandfather clock

            CREATE_FOLDER_PUSH_PEEK (heros)
            CREATE_LISTING_PEEK (Iron Man)
            CREATE_LISTING_PEEK (Jean Grey)
            CREATE_LISTING_PEEK (Mallrats)
            CREATE_FOLDER_POP_PUSH_PEEK (old)
            ...

    Return:
        BookmarkFolder
    """
    root_folder = BookmarkFolder(None)
    root_folder.raw_data = data

    folder_stack = [root_folder]

    previous_level = 0
    previous_is_folder = False

    for current_record in data:
        current_record_re = re.search('(.*)\((.+)\)(.*)', current_record)

        record_level = len(current_record_re.group(1))
        record_type = current_record_re.group(2)
        record_title = str(current_record_re.group(3)).strip()
        record_is_folder = False

        if record_type == 'F' or record_type == 'SF':
            record_is_folder = True

        # print('-'*10)
        # print('previous_level: {} - previous_is_folder: {} - record_level: {} - record_type: {} - record_title: {}'.format(previous_level, previous_is_folder, record_level, record_type, record_title))

        bookmark_class = None

        if record_type == 'F':
            bookmark_class = BookmarkFolder
        elif record_type == 'SF':
            bookmark_class = BookmarkSharedFolder
        elif record_type == 'L' or record_type == 'SL':
            bookmark_class = BookmarkListing

        if not bookmark_class:
            previous_level = record_level
            previous_is_folder = record_is_folder
            continue

        level_action = 'LEVEL_ERROR'

        if record_level == previous_level + 1:
            level_action = 'LEVEL_UP'
        elif record_level == previous_level - 1:
            level_action = 'LEVEL_DOWN'
        elif record_level == previous_level:
            level_action = 'LEVEL_SAME'

        action = None

        if record_is_folder:
            if level_action == 'LEVEL_UP' and previous_is_folder is True:
                action = 'CREATE_FOLDER_PUSH_PEEK'
            elif level_action == 'LEVEL_SAME' and previous_is_folder is True:
                action = 'CREATE_FOLDER_POP_PUSH_PEEK'
            elif level_action == 'LEVEL_SAME' and previous_is_folder is False:
                action = 'CREATE_FOLDER_PUSH_PEEK'
            elif level_action == 'LEVEL_DOWN':
                action = 'CREATE_FOLDER_POP_PUSH_PEEK'
        else:
            if level_action == 'LEVEL_UP' and previous_is_folder is True:
                action = 'CREATE_LISTING_PEEK'
            elif level_action == 'LEVEL_SAME':
                action = 'CREATE_LISTING_PEEK'
            elif level_action == 'LEVEL_DOWN':
                action = 'CREATE_LISTING_POP_PEEK'

        # print('level_action: {} - action: {}'.format(level_action, action))
        if not action:
            previous_level = record_level
            previous_is_folder = record_is_folder
            continue

        if action == 'CREATE_FOLDER_PUSH_PEEK':
            current_root_folder = folder_stack[-1]
            next_root_folder = bookmark_class(record_title)
            current_root_folder.add_bookmark_object(next_root_folder)
            folder_stack.append(next_root_folder)

        elif action == 'CREATE_FOLDER_POP_PUSH_PEEK':
            if len(folder_stack) > 1:
                folder_stack.pop()
            current_root_folder = folder_stack[-1]
            next_root_folder = bookmark_class(record_title)
            current_root_folder.add_bookmark_object(next_root_folder)
            folder_stack.append(next_root_folder)

        elif action == 'CREATE_LISTING_PEEK':
            current_root_folder = folder_stack[-1]
            current_root_folder.add_bookmark_object(bookmark_class(record_title))
        elif action == 'CREATE_LISTING_POP_PEEK':
            if len(folder_stack) > 1:
                folder_stack.pop()
            current_root_folder = folder_stack[-1]
            current_root_folder.add_bookmark_object(bookmark_class(record_title))

        # set previous level
        previous_level = record_level
        previous_is_folder = record_is_folder

    return root_folder


def _bookmark_node_parse(bookmark_folder, data):
    """
    Parse Endpoint data helper
    """
    folders = data.get('folders')
    listings = data.get('listings')

    if folders is not None and listings is not None:
        for folder in folders:
            bookmark_id = folder.get('id')
            folder_title = folder.get('title')
            folder_is_shared = folder.get('is_shared', False)
            folder_class = BookmarkFolder

            if folder_is_shared:
                folder_class = BookmarkSharedFolder

            if folder_title:
                bookmark_folder_nested = folder_class(folder_title, id=bookmark_id)
                bookmark_folder.add_bookmark_object(bookmark_folder_nested)
                bookmark_folder_nested.set_parent(bookmark_folder)
                _bookmark_node_parse(bookmark_folder_nested, folder.get('children', {}))

        for listing in listings:
            bookmark_id = listing.get('id')
            listing_title = listing.get('listing', {}).get('title')
            if listing_title:
                bookmark_listing = BookmarkListing(listing_title, id=bookmark_id)
                bookmark_folder.add_bookmark_object(bookmark_listing)
                bookmark_listing.set_parent(bookmark_folder)


def bookmark_node_string_helper(bookmark_node, level=0):
    if isinstance(bookmark_node, BookmarkFolder):
        bookmark_node_is_root = bookmark_node.title is None

        prefix = 'F'
        if isinstance(bookmark_node, BookmarkSharedFolder):
            prefix = 'SF'

        bookmarks = []

        if not bookmark_node_is_root:
            bookmarks.append('{}({}) {}'.format(' ' * level, prefix, bookmark_node.title))

        for bookmark in bookmark_node.bookmark_objects:
            if not bookmark_node_is_root:
                bookmarks.extend(bookmark_node_string_helper(bookmark, level + 1))
            else:
                bookmarks.extend(bookmark_node_string_helper(bookmark, level))

        return bookmarks
    elif isinstance(bookmark_node, BookmarkListing):
        return ['{}(L) {}'.format(' ' * level, bookmark_node.title)]


class BookmarkNode(object):

    def __init__(self, id=None, title=None, type=None, is_shared=None, listing_id=None):
        self.id = id
        self.title = title
        self.type = type
        self.is_shared = is_shared
        self.parent = None
        self.bookmark_objects = []
        self.level = 0
        self.raw_data = None
        self.listing_id = None

    def set_parent(self, bookmark_node):
        self.parent = bookmark_node

    def __str__(self):
        return '\n'.join(bookmark_node_string_helper(self))

    def shorten_data(self, include_root=True):
        return bookmark_node_string_helper(self)


class BookmarkFolder(BookmarkNode):

    def __init__(self, title, id=None, is_shared=False):
        super().__init__(id, title, 'FOLDER', is_shared)

    def add_bookmark_object(self, bookmark_object):
        self.bookmark_objects.append(bookmark_object)

    def first_shared_folder(self):
        for bookmark in self.bookmark_objects:
            if isinstance(bookmark, BookmarkSharedFolder):
                return bookmark
        return None

    @staticmethod
    def parse_endpoint(data):
        """
        Convert Endpoint Data into BookmarkFolder

        Args:
            data:
                {
                "folders": [{"id": 1, "type": "FOLDER", "title": "Instruments", "is_shared": false,
                    "children": { "folders":[{...}], "listings":[{...}] },
                "listings": [{"id": 2, "type": "LISTING", "listing": {"id":3, "title":"title"} }]
        Return:
            BookmarkFolder
        """
        root_folder = BookmarkFolder(None)
        _bookmark_node_parse(root_folder, data)
        return root_folder

    @staticmethod
    def parse_shorthand_list(data):
        return _bookmark_node_parse_shorthand(data)

    def __repr__(self):
        bookmark_objects = self.bookmark_objects
        id = self.id
        title = self.title
        prefix = ''

        if self.is_shared:
            prefix = 'SF'
        else:
            prefix = 'F'

        return '{}({}, {}, {}){}'.format(prefix, id, title, self.parent.title if self.parent else 'None', bookmark_objects)


class BookmarkSharedFolder(BookmarkFolder):
    def __init__(self, title, id=None):
        super().__init__(title, id=id, is_shared=True)


class BookmarkListing(BookmarkNode):

    def __init__(self, title, id=None, listing_id=None):
        super().__init__(id, title, 'LISTING', False, listing_id=None)

    def __repr__(self):
        if self.is_shared:
            prefix = 'SL'
        else:
            prefix = 'L'

        return '{}({}, {}, {})'.format(prefix, self.id, self.title, self.parent.title if self.parent else 'None')

    @staticmethod
    def parse_endpoint(data):
        """
        Convert Endpoint Data into BookmarkFolder

        Args:
            data:
                {"id": 2, "type": "LISTING",
                    "listing": {"id":3, "title":"title"} }
        Return:
            BookmarkFolder
        """
        bookmark_id = data.get('id')
        listing_title = data.get('listing', {}).get('title')
        listing_id = data.get('listing', {}).get('id')
        if listing_title:
            bookmark_listing = BookmarkListing(listing_title, id=bookmark_id, listing_id=listing_id)
            bookmark_listing.raw_data = data
            return bookmark_listing
        return None


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
