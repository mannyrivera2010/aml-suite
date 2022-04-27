"""
DataStore
"""
import json

import settings


class DataStore(object):

    def __init__(self):
        self.data_store = {}
        self.data_store['meta'] = {}
        self.data_store['meta']['repos'] = settings.REPOS
        self.data_store['meta']['release_directory'] = settings.GIT_BASE_DIR

        self.data_store['repo'] = {}

    def __str__(self):
        return json.dumps(self.data_store, indent=2)

    def repos(self):
        return self.data_store['meta']['repos']

    def update_meta(self, data):
        for key_item, value_item in data.items():
            self.data_store['meta'][key_item] = value_item
        return data

    def get_meta_key(self, key):
        return self.data_store['meta'][key]

    def update_repo(self, repo_name, data):
        """
        Update Repo
        """
        if self.data_store['repo'].get(repo_name) is None:
            self.data_store['repo'][repo_name] = {}

        for key_item, value_item in data.items():
            self.data_store['repo'][repo_name][key_item] = value_item
        return self.data_store['repo'][repo_name]

    def append_repo_errors(self, repo_name, error):
        self.data_store['repo'][self.repo_name]['errors'].append(error)

    def get_repo_key(self, repo_name, key):
        return self.data_store['repo'][repo_name][key]


datastore = DataStore()
