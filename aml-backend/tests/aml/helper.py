import re
import inspect
import os
import sys

from plugins.plugin_manager import plugin_manager_instance

# from plugins import plugin_manager
# plugin_manager_instance = plugin_manager.plugin_manager_instance

TEST_BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


class Route(object):

    def __init__(self, url, view, method):
        self.url = url
        self.view = view
        self.method = method


class MockResponse:
    """
    Mock Response for requests module
    """

    def __init__(self, json_data, status_code):
        self.json_data = json_data
        self.status_code = status_code
        self.text = 'Message: {0!s} - Status: {1!s}'.format(self.json_data.get('message', 'N/A'), status_code)

    def json(self):
        return self.json_data


class Router(object):

    def __init__(self, urls=None):
        if urls:
            self.urls = urls
        else:
            self.urls = []

    def add_urls(self, url_list):
        for url in url_list:
            self.urls.append(url)

    def execute(self, url):
        p = '(?P<protocol>http[s]?://)(?P<host>[^/ ]+)(?P<path>.*)'
        m = re.search(p, url)
        protocol = m.group('protocol')
        host = m.group('host')
        path = m.group('path')

        try:
            for route in self.urls:
                found = re.match(route.url, path)
                if found:
                    current_view = route.view()

                    if hasattr(current_view, route.method):
                        current_method = getattr(current_view, route.method)
                    else:
                        raise RuntimeError('Method [{0!s}] does not exist on the view [{1!s}]'.format(route.method, current_view.__class__.__name__))

                    params = inspect.getargspec(current_method)

                    args = params.args[1::]

                    kargs = {}
                    for arg_key in args:
                        try:
                            kargs[arg_key] = found.group(arg_key)
                        except IndexError:
                            pass
                    return current_method(**kargs)

            return MockResponse({'message': 'Mock Service - URL Not found - {}'.format(sys.argv),
                                 'protocol': protocol,
                                 'host': host, 'URL': url}, 404)
        except RuntimeError as e:
            return MockResponse({'message': 'Mock Service - {0!s}'.format(str(e)),
                                 'protocol': protocol,
                                 'host': host,
                                 'URL': url}, 404)


router = Router()

load_mock_service = False

if len(sys.argv) >= 1:
    first_item = sys.argv[0]
    if 'pytest' in first_item or '-c' in first_item:
        load_mock_service = True

# Detect if test is in the arguement, ex) manage.py
# If doing test then load the mock services
if 'test' in sys.argv:
    load_mock_service = True

if load_mock_service:
    plugin_manager_instance.load_mock_services(router)


def mocked_requests_get(*args, **kwargs):
    url = args[0]
    return router.execute(url)
