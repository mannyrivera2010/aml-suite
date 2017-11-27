"""
Make sure that Pipe and Pipeline classes work

TODO: Make below code work
if not len_pipe.has_next():
    break
"""
from django.test import override_settings
from django.test import TestCase

from ozpcenter.recommend.graph_factory import GraphFactory
from ozpcenter.recommend import recommend_utils
from ozpcenter.pipe import pipes
from ozpcenter.pipe import pipeline
from ozpcenter.recommend.graph import Graph


@override_settings(ES_ENABLED=False)
class PipelineTest(TestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.graph_test_1 = Graph()
        self.graph_test_1.add_vertex('test_label', {'test_field': 1})
        self.graph_test_1.add_vertex('test_label', {'test_field': 2})

        self.graph_test_2 = Graph()
        self.graph_test_2.add_vertex('test_label', {'test_field': 8})
        self.graph_test_2.add_vertex('test_label', {'test_field': 10})
        self.graph_test_2.add_vertex('test_label', {'test_field': 12, 'time': 'now'})

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        pass

    def _iterate_pipeline(self, current_pipeline):
        list_out = []

        try:
            while current_pipeline.has_next():
                current_object = current_pipeline.next()
                list_out.append(current_object)
        except recommend_utils.FastNoSuchElementException:
            # Ignore FastNoSuchElementException
            pass
        return list_out

    def test_pipeline_limit(self):
        pipeline_test = pipeline.Pipeline(recommend_utils.ListIterator([1, 2, 3, 4, 5, 6, 7]),
                                          [pipes.LimitPipe(5)])

        self.assertEqual(pipeline_test.to_list(), [1, 2, 3, 4, 5])

        pipeline_test = pipeline.Pipeline(recommend_utils.ListIterator([1, 2, 3, 4, 5, 6, 7]),
                                          [pipes.LimitPipe(2)])

        self.assertEqual(pipeline_test.to_list(), [1, 2])

        pipeline_test = pipeline.Pipeline(recommend_utils.ListIterator([1, 2, 3]),
                                          [pipes.LimitPipe(5)])

        self.assertEqual(pipeline_test.to_list(), [1, 2, 3])

    def test_pipeline_exclude_limit(self):
        pipeline_test = pipeline.Pipeline(recommend_utils.ListIterator([1, 2, 3, 4, 5, 6, 7]),
                                          [pipes.ExcludePipe([1]),
                                           pipes.LimitPipe(5)])

        self.assertEqual(pipeline_test.to_list(), [2, 3, 4, 5, 6])

    def test_pipeline_capitalize(self):
        caps_pipe = pipes.CapitalizePipe()

        pipeline_test = pipeline.Pipeline()
        pipeline_test.add_pipe(caps_pipe)

        pipeline_test.set_starts(recommend_utils.ListIterator(['this', 'is', 'the', 'test']))

        list_out = self._iterate_pipeline(pipeline_test)
        self.assertEqual(list_out, ['THIS', 'IS', 'THE', 'TEST'])

    def test_pipeline_capitalize_len(self):
        pipeline_test = pipeline.Pipeline(recommend_utils.ListIterator(['this', 'is', 'the', 'test']),
                                          [pipes.CapitalizePipe(),
                                           pipes.LenPipe()])
        list_out = self._iterate_pipeline(pipeline_test)
        self.assertEqual(list_out, [4, 2, 3, 4])

    def test_pipeline_capitalize_len_list(self):
        pipeline_test = pipeline.Pipeline(recommend_utils.ListIterator(['this', 'is', 'the', 'test']),
                                          [pipes.CapitalizePipe(),
                                           pipes.LenPipe()])

        self.assertEqual(pipeline_test.to_list(), [4, 2, 3, 4])

    def test_pipeline_graph_vertex_while(self):
        pipeline_test = pipeline.Pipeline(self.graph_test_1.get_vertices_iterator(),
                                          [pipes.GraphVertexPipe()])

        list_out = self._iterate_pipeline(pipeline_test)
        self.assertEquals(str(list_out), '[Vertex(test_label), Vertex(test_label)]')
        # self.assertEqual(list_out, [1, 2])

    def test_pipeline_graph_vertex_chain_to_list(self):
        pipeline_test = pipeline.Pipeline(self.graph_test_1.get_vertices_iterator(),
                                          [pipes.GraphVertexPipe(),
                                           pipes.ElementIdPipe()])

        self.assertEqual(pipeline_test.to_list(), [1, 2])
        self.assertEqual(str(pipeline_test), '[GraphVertexPipe(), ElementIdPipe()]')

    def test_pipeline_graph_vertex_chain_dict_to_list(self):
        pipeline_test = pipeline.Pipeline(self.graph_test_2.get_vertices_iterator(),
                                          [pipes.GraphVertexPipe(),
                                           pipes.ElementPropertiesPipe()])
        expected_output = [
            {'test_field': 8},
            {'test_field': 10},
            {'test_field': 12, 'time': 'now'}
        ]
        self.assertEqual(pipeline_test.to_list(), expected_output)
        self.assertEqual(str(pipeline_test), '[GraphVertexPipe(), ElementPropertiesPipe(internal:False)]')

    def test_pipeline_graph_vertex_chain_dict_to_list_internal(self):
        pipeline_test = pipeline.Pipeline(self.graph_test_2 .get_vertices_iterator(),
                                          [pipes.GraphVertexPipe(),
                                           pipes.ElementPropertiesPipe(internal=True)])
        expected_output = [
            {'_id': 1, '_label': 'test_label', 'test_field': 8},
            {'_id': 2, '_label': 'test_label', 'test_field': 10},
            {'_id': 3, '_label': 'test_label', 'test_field': 12, 'time': 'now'}
        ]
        self.assertEqual(pipeline_test.to_list(), expected_output)
        self.assertEqual(str(pipeline_test), '[GraphVertexPipe(), ElementPropertiesPipe(internal:True)]')
