"""
Make sure that Pipe and Pipeline classes work
"""
from django.test import override_settings
from django.test import TestCase

from amlcenter.recommend.graph_factory import GraphFactory
from amlcenter.scripts import sample_data_generator as data_gen
# from tests.amlcenter.data_util import FileQuery


@override_settings(ES_ENABLED=False)
class GraphTest(TestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        pass

    @classmethod
    def setUpTestData(cls):
        """
        Set up test database for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_load_db_into_graph(self):
        graph = GraphFactory.load_db_into_graph()
        self.assertEqual(str(graph), 'Graph(vertices: 223, edges: 536)')

        bigbrother_dict = graph.query().v('p-1').to_dict().next()
        expected_dict = {'highest_role': 'APPS_MALL_STEWARD', 'username': 'bigbrother'}
        self.assertEqual(bigbrother_dict, expected_dict)

        # More meaningful to know title of listings bookmarked than just ids
        bigbrother_bookmarks = graph.query().v('p-1').out('bookmarked').to_dict().key('title').to_list()

        # all_file_bookmarks_list = (FileQuery()
        #                 .load_yaml_file('listings.yaml')
        #                 .each_key('library_entries')
        #                 .to_list())
        #
        # print(all_file_bookmarks_list)

        expected_bookmarks = [
            'Acoustic Guitar',
            'Bread Basket',
            'Chain boat navigation',
            'Chart Course',
            'Electric Guitar',
            'Electric Piano',
            'Gallery of Maps',
            'Informational Book',
            'Killer Whale',
            'Lightning',
            'Lion Finder',
            'Monkey Finder',
            'Parrotlet',
            'Piano',
            'Snow',
            'Sound Mixer',
            'Stop sign',
            'Tornado',
            'Violin',
            'White Horse',
            'Wolf Finder'
        ]
        self.assertEqual(sorted(bigbrother_bookmarks), sorted(expected_bookmarks))
