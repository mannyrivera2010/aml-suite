import hashlib
import os
import binascii

from blitzdb import Document
from blitzdb import FileBackend


class Profile(Document):
    pass


class Data(Document):
    pass


class DataStore(object):

    def __init__(self):
        self.backend = FileBackend("db")
        self._create_indexes()

    def _create_indexes(self):
        self.backend.create_index(Profile, 'username')

    def _get_sha224_hash(self, input_string):
        return hashlib.sha224(input_string.encode('utf-8')).hexdigest()

    def create_profile(self, username, password):
        search_profile = list(self.backend.filter(Profile, {'username' : username}))

        if len(search_profile) >= 1:
            raise Exception('Profile [{0}] already exist'.format(username))

        salt = binascii.hexlify(os.urandom(16)).decode('utf-8')
        current_profile = Profile({'username': username,
                                   'salt': salt,
                                   'password': self._get_sha224_hash('{0}{1}'.format(password,salt))})
        current_profile.save(self.backend)
        self.backend.commit()
        return current_profile

    def get_profile(self, username):
        search_profile = dict(self.backend.get(Profile,{'username' : username}))
        return search_profile

    def verify_profile(self, username, password):
        current_profile = None
        try:
            current_profile = self.get_profile(username)
        except:
            return False

        current_profile_password = current_profile.get('password')
        current_profile_salt = current_profile.get('salt')
        current_input_password = self._get_sha224_hash('{0}{1}'.format(password, current_profile_salt))

        if current_profile_password == current_input_password:
            return True
        else:
            return False


db = DataStore()

if __name__ == '__main__':
    try:
        db.create_profile('user1','password')
    except:
        print('user already created')

    a = db.get_profile('user')
    print(a)

    print(db.verify_profile('user1','password'))
