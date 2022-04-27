"""
Make sure that Pipe and Pipeline classes work
"""
from django.test import override_settings
from django.test import TestCase

from amlcenter.recommend.graph import Graph
from amlcenter.recommend.graph_factory import GraphFactory
from amlcenter.scripts import sample_data_generator as data_gen


@override_settings(ES_ENABLED=False)
class GraphQueryTest(TestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.graph = Graph()
        self.graph.add_vertex('test_label', {'test_field': 1})
        self.graph.add_vertex('test_label', {'test_field': 2})
        self.graph.add_vertex('test_label', {'test_field': 12, 'time': 'now'})

        self.graph2 = Graph()
        self.vertex1 = self.graph2.add_vertex('person', {'username': 'first last'}, current_id=10)
        self.vertex2 = self.graph2.add_vertex('listing', {'title': 'Skyzone1'}, current_id=20)
        self.vertex3 = self.graph2.add_vertex('listing', {'title': 'Skyzone2'}, current_id=30)
        self.vertex1.add_edge('personListing', self.vertex2)
        self.vertex1.add_edge('personListing', self.vertex3)

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def test_graph_query_builder(self):
        query = self.graph.query().V()
        self.assertEqual(str(query), '[DictKeyValueIterator(3), GraphVertexPipe()]')

    def test_graph_query_builder_chain(self):
        query = self.graph.query().V().to_dict()
        self.assertEqual(str(query), '[DictKeyValueIterator(3), GraphVertexPipe(), ElementPropertiesPipe(internal:False)]')

    def test_graph_query_V_dict(self):
        query = self.graph.query().V().to_dict()
        all_vertices = query.to_list()

        expected_results = [
            {'test_field': 1},
            {'test_field': 2},
            {'test_field': 12, 'time': 'now'}
        ]

        self.assertEqual(all_vertices, expected_results)

    def test_graph_query_V_id(self):
        query = self.graph.query().V().id()
        all_vertices = query.to_list()

        expected_results = [1, 2, 3]
        self.assertEqual(all_vertices, expected_results)

    def test_graph_query_v_to_list(self):
        query = self.graph2.query().v(10).id()
        all_vertices = query.to_list()
        expected_results = [10]
        self.assertEqual(all_vertices, expected_results)

        query = self.graph2.query().v(10, 20).id()
        all_vertices = query.to_list()
        expected_results = [10, 20]
        self.assertEqual(all_vertices, expected_results)

    def test_graph_query_v_out_to_list(self):
        query = self.graph2.query().v(10).out().id()
        all_vertices = query.to_list()
        expected_results = [20, 30]
        self.assertEqual(all_vertices, expected_results)

        query = self.graph2.query().v(20).out().id()
        all_vertices = query.to_list()
        expected_results = []
        self.assertEqual(all_vertices, expected_results)

    def test_graph_sample_profile_listing_in(self):
        graph = GraphFactory.load_sample_profile_listing_graph()
        self.assertEqual(str(graph), 'Graph(vertices: 15, edges: 23)')

        query_results = graph.query().v('l-1').id().to_list()
        expected_results = ['l-1']
        self.assertEqual(query_results, expected_results)

        query_results = graph.query().v('l-1').in_('bookmarked').id().to_list()
        expected_results = ['p-1', 'p-2', 'p-3']
        self.assertEqual(query_results, expected_results)

        query_results = graph.query().v('l-1', 'l-2', 'l-3').id().to_list()
        expected_results = ['l-1', 'l-2', 'l-3']
        self.assertEqual(query_results, expected_results)

    def test_graph_sample_profile_listing_categories(self):
        graph = GraphFactory.load_sample_profile_listing_graph()
        self.assertEqual(str(graph), 'Graph(vertices: 15, edges: 23)')

        query_results = (graph.query()
                         .v('p-1')  # Profile
                         .out('bookmarked')  # Listing
                         .out('listingCategory')
                         .id().to_list())  # Get listings of target profile ids

        expected_categories = ['c-1', 'c-2', 'c-1']

        self.assertEqual(query_results, expected_categories)

    def test_graph_sample_profile_listing_side_effect(self):
        graph = GraphFactory.load_sample_profile_listing_graph()
        self.assertEqual(str(graph), 'Graph(vertices: 15, edges: 23)')

        profile_listing_categories_ids = []
        query_results = (graph.query()
                              .v('p-1')
                              .out('bookmarked')
                              .side_effect(lambda current_vertex:
                                           [profile_listing_categories_ids.append(current) for current in
                                            current_vertex.query().out('listingCategory').id().to_list()])
                              .id().to_list())  # Get listings of target profile ids

        expected_categories = ['c-1', 'c-2', 'c-1']
        expected_listing = ['l-1', 'l-2', 'l-3']

        self.assertEqual(profile_listing_categories_ids, expected_categories)
        self.assertEqual(query_results, expected_listing)

    def test_graph_sample_profile_listing(self):
        graph = GraphFactory.load_sample_profile_listing_graph()
        self.assertEqual(str(graph), 'Graph(vertices: 15, edges: 23)')

        query_results = graph.query().v('p-1').id().to_list()
        expected_results = ['p-1']
        self.assertEqual(sorted(query_results), sorted(expected_results))

        query_results = graph.query().v('p-1').out('bookmarked').id().to_list()
        expected_results = ['l-1', 'l-2', 'l-3']
        self.assertEqual(sorted(query_results), sorted(expected_results))

        query_results = graph.query().v('p-1').out('bookmarked').in_('bookmarked').id().to_list()
        expected_results = ['p-1', 'p-2', 'p-3', 'p-3', 'p-1', 'p-4', 'p-5', 'p-1', 'p-5']
        self.assertEqual(sorted(query_results), sorted(expected_results))

        query_results = graph.query().v('p-1').out('bookmarked').in_('bookmarked').id().distinct().to_list()
        expected_results = ['p-1', 'p-2', 'p-3', 'p-4', 'p-5']
        self.assertEqual(sorted(query_results), sorted(expected_results))

        query_results = graph.query().v('p-1').out('bookmarked').in_('bookmarked').distinct().id().to_list()
        expected_results = ['p-1', 'p-2', 'p-3', 'p-4', 'p-5']
        self.assertEqual(sorted(query_results), sorted(expected_results))

        query_results = graph.query().v('p-1').out('bookmarked').in_('bookmarked').distinct().exclude_ids(['p-1']).id().to_list()
        expected_results = ['p-2', 'p-3', 'p-4', 'p-5']
        self.assertEqual(sorted(query_results), sorted(expected_results))
