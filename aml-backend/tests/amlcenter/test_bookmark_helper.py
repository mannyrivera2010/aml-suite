"""
Bookmark Helper tests
"""
from django.test import TestCase
from django.conf import settings

from amlcenter import bookmark_helper


def shorthand_commands(data):
    output = []

    for record in data:

        if not record['stack_action']:
            record['level_diff'] = ''

        record['record_title'] = record['record_title'].replace('"', '/"')

        output.append('{} {} {} {} "{}"'.format(
            record['stack_action'],
            record['level_diff'],
            record['action'],
            record['class_type'],
            record['record_title'],
            # record['post_stack_action']
            ).strip())
    return output


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
        ]

        bookmark_folder = bookmark_helper.BookmarkFolder.parse_shorthand_list(bigbrother_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), bigbrother_expected_bookmarks)
        self.assertEqual(bookmark_folder.clone().shorten_data(), bigbrother_expected_bookmarks)

        actual_commands = shorthand_commands(bookmark_helper._bookmark_node_parse_shorthand_commands(bigbrother_expected_bookmarks))
        expected_commands = [
            'CREATE FOLDER "Animals"',
            'CREATE LISTING "Killer Whale"',
            'CREATE LISTING "Lion Finder"',
            'CREATE LISTING "Monkey Finder"',
            'CREATE LISTING "Parrotlet"',
            'CREATE LISTING "White Horse"',
            'CREATE LISTING "Wolf Finder"',
            'POP 1 CREATE FOLDER "Instruments"',
            'CREATE LISTING "Acoustic Guitar"',
            'CREATE LISTING "Electric Guitar"',
            'CREATE LISTING "Electric Piano"',
            'CREATE LISTING "Piano"',
            'CREATE LISTING "Sound Mixer"',
            'CREATE LISTING "Violin"',
            'POP 1 CREATE FOLDER "Weather"',
            'CREATE LISTING "Lightning"',
            'CREATE LISTING "Snow"',
            'CREATE LISTING "Tornado"',
            'POP 1 CREATE LISTING "Bread Basket"',
            'CREATE LISTING "Chain boat navigation"',
            'CREATE LISTING "Chart Course"',
            'CREATE LISTING "Gallery of Maps"',
            'CREATE LISTING "Informational Book"',
            'CREATE LISTING "Stop sign"'
        ]
        self.assertEqual(actual_commands, expected_commands)

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

        bookmark_folder = bookmark_helper.BookmarkFolder.parse_shorthand_list(wsmith_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), wsmith_expected_bookmarks)
        self.assertEqual(bookmark_folder.clone().shorten_data(), wsmith_expected_bookmarks)

        stucture_list = [record[0] for record in bookmark_helper._build_filesystem_structure(bookmark_folder)]
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

        bookmark_folder = bookmark_helper.BookmarkFolder.parse_shorthand_list(one_listing_expected_bookmarks)
        self.assertEqual(bookmark_folder.shorten_data(), one_listing_expected_bookmarks)

    def test_bookmark_folder_parse_shorthand_complex_multi_level(self):
        """
        Test parse_shorthand_list method for nested parsing
        """
        nested_expected_bookmarks = [
            '(F) 1',
            ' (SF) 1.1',
            '  (L) 1.1-1',
            ' (F) 1.2',
            '  (F) 1.2.1',
            '   (F) 1.2.1.1',
            '    (L) X',
            '   (L) 1.2.1-1',
            ' (F) 1.3',
            '  (L) 1.3.1',
            ' (F) 1.4',
            ' (L) 1-1',
            '(F) 2',
            ' (F) 2.1',
            '  (F) 2.1.1',
            '   (F) 2.1.1.1',
            '    (F) 2.1.1.1.1',
            '     (L) 2.1.1.1.1-1',  # Make it work without this line
            '(F) 3'
        ]

        actual_commands = shorthand_commands(bookmark_helper._bookmark_node_parse_shorthand_commands(nested_expected_bookmarks))
        import pprint
        pprint.pprint(actual_commands)
        expected_commands = [
            'CREATE FOLDER "1"',
            'CREATE SHARED_FOLDER "1.1"',
            'CREATE LISTING "1.1-1"',
            'POP 1 CREATE FOLDER "1.2"',
            'CREATE FOLDER "1.2.1"',
            'CREATE FOLDER "1.2.1.1"',
            'CREATE LISTING "X"',
            'POP 1 CREATE LISTING "1.2.1-1"',
            'POP 2 CREATE FOLDER "1.3"',
            'CREATE LISTING "1.3.1"',
            'POP 1 CREATE FOLDER "1.4"',
            'POP 1 CREATE LISTING "1-1"',
            'POP 1 CREATE FOLDER "2"',
            'CREATE FOLDER "2.1"',
            'CREATE FOLDER "2.1.1"',
            'CREATE FOLDER "2.1.1.1"',
            'CREATE FOLDER "2.1.1.1.1"',
            'CREATE LISTING "2.1.1.1.1-1"',  # TODO: Make it work without this line
            'POP 5 CREATE FOLDER "3"'
        ]
        self.assertEqual(actual_commands, expected_commands)

        bookmark_folder = bookmark_helper.BookmarkFolder.parse_shorthand_list(nested_expected_bookmarks)
        # import pprint;pprint.pprint(bookmark_folder.shorten_data())
        self.assertEqual(bookmark_folder.shorten_data(), nested_expected_bookmarks)
        self.assertEqual(bookmark_folder.clone().shorten_data(), nested_expected_bookmarks)

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
            ' (F) Folder "1.4"',
            ' (L) Listing 1.1.1',
            '(F) Folder 2'
        ]

        bookmark_folder = bookmark_helper.BookmarkFolder.parse_shorthand_list(nested_expected_bookmarks)
        # import pprint;pprint.pprint(bookmark_folder.shorten_data())
        self.assertEqual(bookmark_folder.shorten_data(), nested_expected_bookmarks)
        self.assertEqual(bookmark_folder.clone().shorten_data(), nested_expected_bookmarks)

        actual_commands = shorthand_commands(bookmark_helper._bookmark_node_parse_shorthand_commands(nested_expected_bookmarks))
        expected_commands = [
            'CREATE FOLDER "Folder 1"',
            'CREATE SHARED_FOLDER "Folder 1.1"',
            'CREATE LISTING "Listing 1.1.2"',
            'POP 1 CREATE FOLDER "Folder 1.2"',
            'POP 1 CREATE FOLDER "Folder 1.3"',
            'CREATE LISTING "Listing 1.3.1"',
            'POP 1 CREATE FOLDER "Folder /"1.4/""',
            'POP 1 CREATE LISTING "Listing 1.1.1"',
            'POP 1 CREATE FOLDER "Folder 2"'
        ]

        self.assertEqual(actual_commands, expected_commands)

        stucture_list = [record[0] for record in bookmark_helper._build_filesystem_structure(bookmark_folder)]
        expected_stucture_list = [
            '/',
            '/Folder 1/',
            '/Folder 1/Folder 1.1/',
            '/Folder 1/Folder 1.1/Listing 1.1.2',
            '/Folder 1/Folder 1.2/',
            '/Folder 1/Folder 1.3/',
            '/Folder 1/Folder 1.3/Listing 1.3.1',
            '/Folder 1/Folder "1.4"/',
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

        bookmark_folder = bookmark_helper.BookmarkFolder.parse_shorthand_list(library)
        self.assertEqual(bookmark_folder.shorten_data(), library)
        self.assertEqual(bookmark_folder.clone().shorten_data(), library)

        actual_commands = shorthand_commands(bookmark_helper._bookmark_node_parse_shorthand_commands(library))
        # import pprint;pprint.pprint(actual_commands)
        expected_commands = [
            'CREATE FOLDER "bigbrother"',
            'CREATE FOLDER "Animals"',
            'CREATE LISTING "Killer Whale"',
            'CREATE LISTING "Lion Finder"',
            'CREATE LISTING "Monkey Finder"',
            'CREATE LISTING "Parrotlet"',
            'CREATE LISTING "White Horse"',
            'CREATE LISTING "Wolf Finder"',
            'POP 1 CREATE FOLDER "Instruments"',
            'CREATE LISTING "Acoustic Guitar"',
            'CREATE LISTING "Electric Guitar"',
            'CREATE LISTING "Electric Piano"',
            'CREATE LISTING "Piano"',
            'CREATE LISTING "Sound Mixer"',
            'CREATE LISTING "Violin"',
            'POP 1 CREATE FOLDER "Weather"',
            'CREATE LISTING "Lightning"',
            'CREATE LISTING "Snow"',
            'CREATE LISTING "Tornado"',
            'POP 1 CREATE LISTING "Bread Basket"',
            'CREATE LISTING "Chain boat navigation"',
            'CREATE LISTING "Chart Course"',
            'CREATE LISTING "Gallery of Maps"',
            'CREATE LISTING "Informational Book"',
            'CREATE LISTING "Stop sign"',
            'POP 1 CREATE FOLDER "bigbrother2"',
            'CREATE SHARED_FOLDER "InstrumentSharing"',
            'CREATE LISTING "Acoustic Guitar"',
            'POP 1 CREATE LISTING "Alingano Maisu"',
            'POP 1 CREATE FOLDER "julia"',
            'CREATE SHARED_FOLDER "InstrumentSharing"',
            'CREATE LISTING "Acoustic Guitar"',
            'POP 1 CREATE LISTING "Astrology software"',
            'POP 1 CREATE FOLDER "johnson"',
            'CREATE SHARED_FOLDER "InstrumentSharing"',
            'CREATE LISTING "Acoustic Guitar"',
            'POP 1 CREATE LISTING "Applied Ethics Inc."',
            'POP 1 CREATE FOLDER "wsmith"',
            'CREATE FOLDER "heros"',
            'CREATE LISTING "Iron Man"',
            'CREATE LISTING "Jean Grey"',
            'CREATE LISTING "Mallrats"',
            'POP 1 CREATE FOLDER "old"',
            'CREATE LISTING "Air Mail"',
            'CREATE LISTING "Bread Basket"',
            'POP 1 CREATE FOLDER "planets"',
            'CREATE LISTING "Azeroth"',
            'CREATE LISTING "Saturn"',
            'POP 1 CREATE LISTING "Baltimore Ravens"',
            'CREATE LISTING "Diamond"',
            'CREATE LISTING "Grandfather clock"'
        ]
        self.assertEqual(actual_commands, expected_commands)

        stucture_list = [record[0] for record in bookmark_helper._build_filesystem_structure(bookmark_folder)]
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
