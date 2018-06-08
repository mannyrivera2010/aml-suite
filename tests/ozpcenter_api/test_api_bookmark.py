"""
Tests for agency endpoints
"""
from django.test import override_settings
from tests.ozp.cases import APITestCase

from tests.ozpcenter.helper import APITestHelper
from ozpcenter.utils import shorthand_dict
from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter.scripts import sample_data_generator as data_gen


def shorthand_shared_folder(data, level=0):
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

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        pass

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_get_bookmark_list(self):
        url = '/api/bookmark/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        shorten_data = shorthand_shared_folder(response.data).split("\n")

        expected_results = [
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

        self.assertEqual(shorten_data, expected_results)
