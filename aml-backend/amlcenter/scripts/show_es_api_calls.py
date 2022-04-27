"""
Show API Calls for ElasticSearch 6.x

python manage.py runscript show_es_api_calls > es.sh


https://www.elastic.co/guide/en/elasticsearch/reference/6.3/indices-create-index.html#mappings
"""
import sys
import os
import json

sys.path.insert(0, os.path.realpath(os.path.join(os.path.dirname(__file__), '../../')))

from amlcenter.api.listing import elasticsearch_util

URL_PATH = 'http://127.0.0.1:9200'
INDEX_NAME = 'aml_listing_data'


def run():
    """
    Reindex Data
    """
    mapping_object = elasticsearch_util.get_mapping_setting_obj()
    mapping_object_json = json.dumps(mapping_object, indent=2)

    commands = []

    commands.append('echo \'DELETE INDEX\'')
    commands.append('curl -X DELETE "{}/{}"'.format(URL_PATH, INDEX_NAME))
    commands.append('echo \'\'')

    commands.append('echo \'Creating Listing data INDEX\'')
    commands.append('curl -X PUT "{}/{}" -H \'Content-Type: application/json\' -d\'\n{}\n\''.format(URL_PATH, INDEX_NAME, mapping_object_json))
    commands.append('echo \'\'')
    commands.append('# -----------------------')

    print('\n'.join(commands))
