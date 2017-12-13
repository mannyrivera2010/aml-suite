"""
Utils tests
"""
from unittest.mock import patch
from django.test import override_settings
from django.test import TestCase

from tests.ozpcenter.helper import patch_environ
from ozpcenter import utils as utils
from ozpcenter.scripts import sample_data_generator as data_gen


@override_settings(ES_ENABLED=False)
class UtilsTest(TestCase):

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
        # data_gen.run()
        pass

    def test_make_keysafe_unwanted(self):
        name = 'Test @string\'s !'
        key_name = utils.make_keysafe(name)
        self.assertEqual(key_name, 'teststrings')

    def test_make_keysafe_period(self):
        name = 'Test User Jr.'
        key_name = utils.make_keysafe(name)
        self.assertEqual(key_name, 'testuserjr.')

    def test_make_keysafe_doublequote(self):
        name = 'Robert "Bob" User'
        key_name = utils.make_keysafe(name)
        self.assertEqual(key_name, 'robert"bob"user')

    def test_make_keysafe_backtick(self):
        name = 'Unexpected`Name'
        key_name = utils.make_keysafe(name)
        self.assertEqual(key_name, 'unexpected`name')

    def test_get_now_utc(self):
        result = utils.get_now_utc()
        self.assertIsNotNone(result)

    def test_find_between(self):
        result = utils.find_between('a*str-a', '*', '-')
        self.assertEqual(result, 'str')

    @patch_environ({'TEST_MODE': 'False'})
    @patch('builtins.input', lambda arg: 'y')
    def test_interactive_migration(self):
        utils.interactive_migration()

    @patch_environ({'TEST_MODE': 'False'})
    @patch('builtins.input', lambda arg: 'n')
    def test_interactive_migration_exception(self):
        with self.assertRaisesRegex(Exception, 'You need to run command first') as err:
            utils.interactive_migration()
