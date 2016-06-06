import constants


class Settings(object):

    def __init__(self):
        self.settings_dictionary = {}
        self._load_constants_file()

    def _load_constants_file(self):
        constants_variable = dir(constants)

        for variable in constants_variable:
            if '__' not in variable:
                self.settings_dictionary[variable.upper()] = getattr(constants, variable)

    def __getattr__(self, name):
        value = self.settings_dictionary.get(name.upper())
        if value:
            return lambda: value
        raise AttributeError('{0} does not exist'.format(name))

    def set(self, key, value):
        self.settings_dictionary[key.upper()] = value
        return value

    def get(self, key, default=None):
        return self.settings_dictionary.get(key.upper(), default)

    def __repr__(self):
        return self.settings_dictionary

    def __str__(self):
        return str(self.settings_dictionary)


settings_instance = Settings()


if __name__ == '__main__':
    print(settings_instance)
    print(settings_instance.repos())
    print(settings_instance.get('repos'))
