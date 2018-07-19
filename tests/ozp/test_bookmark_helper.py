"""
Utils tests
"""
from django.test import TestCase
from django.conf import settings

from tests.ozp.bookmark_helper import BookmarkFolder, BookmarkListing, shorthand_permissions, _build_filesystem_structure


class BookmarkHelperTest(TestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None

    def test_bookmark_folder_parse_shorthand_bigbrother(self):
        """
        Testing parse_shorthand_list method
        """
        bigbrother_expected_bookmarks = [
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

        bookmark_folder = BookmarkFolder.parse_shorthand_list(bigbrother_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), bigbrother_expected_bookmarks)
        self.assertEqual(bookmark_folder.clone().shorten_data(), bigbrother_expected_bookmarks)

    def test_bookmark_folder_parse_shorthand_wsmith(self):
        """
        Testing parse_shorthand_list method
        """
        wsmith_expected_bookmarks = [
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

        bookmark_folder = BookmarkFolder.parse_shorthand_list(wsmith_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), wsmith_expected_bookmarks)
        self.assertEqual(bookmark_folder.clone().shorten_data(), wsmith_expected_bookmarks)

        stucture_list = [record[0] for record in _build_filesystem_structure(bookmark_folder)]
        expected_stucture_list = [
            '/',
            '/heros/',
            '/heros/Iron Man',
            '/heros/Jean Grey',
            '/heros/Mallrats',
            '/old/',
            '/old/Air Mail',
            '/old/Bread Basket',
            '/planets/',
            '/planets/Azeroth',
            '/planets/Saturn',
            '/Baltimore Ravens',
            '/Diamond',
            '/Grandfather clock'
        ]

        self.assertEqual(stucture_list, expected_stucture_list)
        bookmark_folder.search('/heros/').add_folder_bookmark('Test2')
        wsmith_expected_bookmarks.insert(1, ' (F) Test2')
        self.assertEqual(bookmark_folder.shorten_data(), wsmith_expected_bookmarks)

    def test_bookmark_folder_parse_shorthand_simple_listing(self):
        """
        Testing parse_shorthand_list method
        """
        one_listing_expected_bookmarks = [
            '(L) Hello'
        ]

        bookmark_folder = BookmarkFolder.parse_shorthand_list(one_listing_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), one_listing_expected_bookmarks)

    def test_bookmark_folder_parse_shorthand_complex(self):
        """
        Test parse_shorthand_list method for nested parsing
        """
        nested_expected_bookmarks = [
            '(F) Folder 1',
            ' (SF) Folder 1.1',
            '  (L) Listing 1.1.2',
            ' (F) Folder 1.2',
            ' (F) Folder 1.3',
            '  (L) Listing 1.3.1',
            ' (F) Folder 1.4',
            ' (L) Listing 1.1.1',
            '(F) Folder 2'
        ]
        bookmark_folder = BookmarkFolder.parse_shorthand_list(nested_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), nested_expected_bookmarks)
        self.assertEqual(bookmark_folder.clone().shorten_data(), nested_expected_bookmarks)

        stucture_list = [record[0] for record in _build_filesystem_structure(bookmark_folder)]
        expected_stucture_list = [
            '/',
            '/Folder 1/',
            '/Folder 1/Folder 1.1/',
            '/Folder 1/Folder 1.1/Listing 1.1.2',
            '/Folder 1/Folder 1.2/',
            '/Folder 1/Folder 1.3/',
            '/Folder 1/Folder 1.3/Listing 1.3.1',
            '/Folder 1/Folder 1.4/',
            '/Folder 1/Listing 1.1.1',
            '/Folder 2/'
        ]

        self.assertEqual(stucture_list, expected_stucture_list)

    def test_build_filesystem_structure(self):
        library = [
            '(F) bigbrother',  # 0
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
            '  (L) Tornado',  # 19
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

        bookmark_folder = BookmarkFolder.parse_shorthand_list(library)
        self.assertEqual(bookmark_folder.shorten_data(), library)
        self.assertEqual(bookmark_folder.clone().shorten_data(), library)

        stucture_list = [record[0] for record in _build_filesystem_structure(bookmark_folder)]
        expected_stucture_list = [
            '/',
            '/bigbrother/',
            '/bigbrother/Animals/',
            '/bigbrother/Animals/Killer Whale',
            '/bigbrother/Animals/Lion Finder',
            '/bigbrother/Animals/Monkey Finder',
            '/bigbrother/Animals/Parrotlet',
            '/bigbrother/Animals/White Horse',
            '/bigbrother/Animals/Wolf Finder',
            '/bigbrother/Instruments/',
            '/bigbrother/Instruments/Acoustic Guitar',
            '/bigbrother/Instruments/Electric Guitar',
            '/bigbrother/Instruments/Electric Piano',
            '/bigbrother/Instruments/Piano',
            '/bigbrother/Instruments/Sound Mixer',
            '/bigbrother/Instruments/Violin',
            '/bigbrother/Weather/',
            '/bigbrother/Weather/Lightning',
            '/bigbrother/Weather/Snow',
            '/bigbrother/Weather/Tornado',
            '/bigbrother/Bread Basket',
            '/bigbrother/Chain boat navigation',
            '/bigbrother/Chart Course',
            '/bigbrother/Gallery of Maps',
            '/bigbrother/Informational Book',
            '/bigbrother/Stop sign',
            '/bigbrother2/',
            '/bigbrother2/InstrumentSharing/',
            '/bigbrother2/InstrumentSharing/Acoustic Guitar',
            '/bigbrother2/Alingano Maisu',
            '/julia/',
            '/julia/InstrumentSharing/',
            '/julia/InstrumentSharing/Acoustic Guitar',
            '/julia/Astrology software',
            '/johnson/',
            '/johnson/InstrumentSharing/',
            '/johnson/InstrumentSharing/Acoustic Guitar',
            '/johnson/Applied Ethics Inc.',
            '/wsmith/',
            '/wsmith/heros/',
            '/wsmith/heros/Iron Man',
            '/wsmith/heros/Jean Grey',
            '/wsmith/heros/Mallrats',
            '/wsmith/old/',
            '/wsmith/old/Air Mail',
            '/wsmith/old/Bread Basket',
            '/wsmith/planets/',
            '/wsmith/planets/Azeroth',
            '/wsmith/planets/Saturn',
            '/wsmith/Baltimore Ravens',
            '/wsmith/Diamond',
            '/wsmith/Grandfather clock'
        ]

        self.assertEqual(stucture_list, expected_stucture_list)

        bookmark_folder.search('/bigbrother/').add_folder_bookmark('Test Folder 1')
        library.insert(19, ' (F) Test Folder 1')

        self.assertEqual(bookmark_folder.shorten_data(), library)
        self.assertEqual(bookmark_folder.clone().shorten_data(), library)
