"""
Test bookmark

TEST_MODE=True pytest tests/ozpcenter_api/test_api_bookmark.py
"""
from django.test import override_settings
from tests.ozp.cases import APITestCase

from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_dict
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


def shorthand_shared_folder(data, level=0):
    """
    Shorthand Shared Folder
    Helper Function to create shorten version of tree
    """
    is_dict_boolean = isinstance(data, dict)
    is_list_boolean = isinstance(data, list)

    if not data:
        return ""
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
                output.append('{}+({}) {}'.format(' ' * level, 'SF', data['title']))
            else:
                output.append('{}+({}) {}'.format(' ' * level, 'F', data['title']))

            if 'children' in data:
                output.append(shorthand_shared_folder(data['children'], level + 1))

        elif type == 'LISTING':
            output.append('{}-({}) {}'.format(' ' * level, 'L', data['listing']['title']))

        return '\n'.join(output)


@override_settings(ES_ENABLED=False)
class BookmarkApiTest(APITestCase):
    """
    BookmarkApiTest
    Unit Tests for bookmark feature

    What to test:
    * Displaying all nested bookmarks for a user
    * Adding a new listing bookmark under a user root folder (level 1)
    * Adding a new listing bookmark under a user existing folder (level 2)
    * Delete Listing Bookmark from user bookmarks
    * Displaying all owners and viewers of a folder bookmark
    * An Owner adding new listing bookmark to folder bookmark
    * An Viewer adding new listing bookmark to folder bookmark and getting denied
    * Moving bookmark between two different folder bookmark
    """

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None

        self.bigbrother_bookmarks = [
            '+(F) Animals',
            ' -(L) Killer Whale',
            ' -(L) Lion Finder',
            ' -(L) Monkey Finder',
            ' -(L) Parrotlet',
            ' -(L) White Horse',
            ' -(L) Wolf Finder',
            '+(F) Instruments',
            ' -(L) Acoustic Guitar',
            ' -(L) Electric Guitar',
            ' -(L) Electric Piano',
            ' -(L) Piano',
            ' -(L) Sound Mixer',
            ' -(L) Violin',
            '+(F) Weather',
            ' -(L) Lightning',
            ' -(L) Snow',
            ' -(L) Tornado',
            '-(L) Bread Basket',
            '-(L) Chain boat navigation',
            '-(L) Chart Course',
            '-(L) Gallery of Maps',
            '-(L) Informational Book',
            '-(L) Stop sign'
        ]

        self.wsmith_bookmarks = [
            '+(F) heros',
            ' -(L) Iron Man',
            ' -(L) Jean Grey',
            ' -(L) Mallrats',
            '+(F) old',
            ' -(L) Air Mail',
            ' -(L) Bread Basket',
            '+(F) planets',
            ' -(L) Azeroth',
            ' -(L) Saturn',
            '-(L) Baltimore Ravens',
            '-(L) Diamond',
            '-(L) Grandfather clock'
        ]

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_get_bookmark_list_admin(self):
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        shorten_data = shorthand_shared_folder(response.data).split("\n")

        # sorted by type, created_date
        expected_results = self.bigbrother_bookmarks

        self.assertEqual(shorten_data, expected_results)

    def test_get_bookmark_list_steward(self):
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        shorten_data = shorthand_shared_folder(response.data).split("\n")

        # sorted by type, created_date
        expected_results = self.wsmith_bookmarks

        self.assertEqual(shorten_data, expected_results)

    def test_create_listing_bookmark_list_admin(self):
        # Verify bookmarks
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        shorten_data = shorthand_shared_folder(response.data).split("\n")

        # sorted by type, created_date
        expected_results = self.bigbrother_bookmarks

        self.assertEqual(shorten_data, expected_results)

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
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        shorten_data = shorthand_shared_folder(response.data).split("\n")

        # sorted by type, created_date
        expected_results = self.bigbrother_bookmarks
        expected_results.extend(shorten_shared_data)

        self.assertEqual(shorten_data, expected_results)
