"""
Tests for notification endpoints
"""
from unittest import skip
import copy
import datetime
import pytz

from django.test import override_settings
from rest_framework import status
from tests.ozp.cases import APITestCase
from ozpcenter.utils import shorthand_dict
from ozpcenter.utils import shorthand_types

from tests.ozpcenter.helper import ExceptionUnitTestHelper
from ozpcenter import model_access as generic_model_access
from ozpcenter.scripts import sample_data_generator as data_gen

from tests.ozpcenter.helper import APITestHelper

from ozpcenter.bookmark_helper import BookmarkFolder, BookmarkListing


def _compare_library(test_case_instance, expected_library_object):
    usernames = [bookmark.title for bookmark in expected_library_object.bookmark_objects]

    root_folder = BookmarkFolder(None)

    for username in usernames:
        user_folder_bookmark = root_folder.add_folder_bookmark(username)

        url = '/api/self/library/'
        response = APITestHelper.request(test_case_instance, url, 'GET', username=username, status_code=200)
        actual_library = BookmarkFolder.parse_legacy_bookmark(response.data)
        user_folder_bookmark.add_bookmark_object(actual_library)

    test_case_instance.assertEqual(root_folder.shorten_data(order=True), expected_library_object.shorten_data(order=True))

    return root_folder


def _parse_notification_to_bookmark_nodes(data):
    user_folder_bookmark = BookmarkFolder(None)

    for entry in data:
        notification_id = entry['id']
        notification_type = entry['notification_type']
        notification_author = entry['author']['user']['username']

        type_folder = user_folder_bookmark.search('/{}/'.format(notification_type))

        if type_folder is None:
            type_folder = user_folder_bookmark.add_folder_bookmark('{}'.format(notification_type))

        author_folder = user_folder_bookmark.search('/{}/{}/'.format(notification_type, notification_author))

        if author_folder is None:
            author_folder = user_folder_bookmark.search('/{}/'.format(notification_type)).add_folder_bookmark('{}'.format(notification_author))

        notification_message = ''.join(entry.get('message').split())
        author_folder.add_listing_bookmark(notification_message, notification_id)

    return user_folder_bookmark


def _compare_user_notification(test_case_instance, expected_notification_object):
    """
    Compare User Notification
    """
    usernames = [bookmark.title for bookmark in expected_notification_object.bookmark_objects]
    root_folder = BookmarkFolder(None)

    for username in usernames:
        user_folder_bookmark = root_folder.add_folder_bookmark(username)
        url = '/api/self/notification/'
        response = APITestHelper.request(test_case_instance, url, 'GET', username=username, status_code=200)
        response_folder = _parse_notification_to_bookmark_nodes(response.data)
        user_folder_bookmark.add_bookmark_object(response_folder)
    # import pprint; pprint.pprint(root_folder.shorten_data(order=True))
    test_case_instance.assertEqual(root_folder.shorten_data(order=True), expected_notification_object.shorten_data(order=True))
    return root_folder


def _create_bookmark_bulk(test_case_instance, username, folder_name, to_bookmark_listing_ids, user_library):
    """
    Create Bookmarks
    """
    for bookmark_listing_id in to_bookmark_listing_ids:
        response = APITestHelper.create_bookmark(test_case_instance, username, bookmark_listing_id, folder_name=folder_name, status_code=201)
        test_case_instance.assertEqual(response.data['listing']['id'], bookmark_listing_id)

        if user_library.search('/{}/{}/'.format(username, folder_name)) is None:
            user_library.search('/{}/'.format(username)).add_folder_bookmark('{}'.format(folder_name))

        user_library.search('/{}/{}/'.format(username, folder_name)).add_listing_bookmark(response.data['listing']['title'])

    _compare_library(test_case_instance, user_library)


def _create_peer_bookmark(test_case_instance, username, to_username, folder_name, notifications_object):
    now = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=5)
    data = {
        'expires_date': str(now),
        'message': 'A Simple Peer to Peer Notification',
        'peer': {
            'user': {
                'username': to_username,
            },
            'folder_name': folder_name
        }
    }

    url = '/api/notification/'

    user = generic_model_access.get_profile(username).user
    test_case_instance.client.force_authenticate(user=user)
    response = test_case_instance.client.post(url, data, format='json')
    test_case_instance.assertEqual(response.status_code, status.HTTP_201_CREATED)

    peer_data = {'user': {'username': to_username}, 'folder_name': folder_name}  # '_bookmark_listing_ids': [3, 4]}
    test_case_instance.assertEqual(response.data['message'], 'A Simple Peer to Peer Notification')
    test_case_instance.assertEqual(response.data['notification_type'], 'peer_bookmark')
    test_case_instance.assertEqual(response.data['agency'], None)
    test_case_instance.assertEqual(response.data['listing'], None)
    test_case_instance.assertEqual(response.data['peer'], peer_data)
    test_case_instance.assertTrue('expires_date' in data)

    notification_id = response.data['id']
    notification_type = response.data['notification_type']
    notification_author = response.data['author']['user']['username']
    notification_message = ''.join(response.data['message'].split())

    if notifications_object.search('/{}/{}/'.format(to_username, notification_type)) is None:
        notifications_object.search('/{}/'.format(to_username)).add_folder_bookmark('{}'.format(notification_type), prepend=True)

    if notifications_object.search('/{}/{}/{}/'.format(to_username, notification_type, notification_author)) is None:
        notifications_object.search('/{}/{}/'.format(to_username, notification_type)).add_folder_bookmark('{}'.format(notification_author), prepend=True)

    notifications_object.search('/{}/{}/{}/'.format(to_username, notification_type, notification_author)).add_listing_bookmark(notification_message, bookmark_id=notification_id)  # prepend=True)

    _compare_user_notification(test_case_instance, notifications_object)

    return response


@override_settings(ES_ENABLED=False)
class NotificationApiTest(APITestCase):

    def setUp(self):
        """
        setUp is invoked before each test method
        """
        self.maxDiff = None
        self.library = [
            '(F) bigbrother',
            ' (F) Weather',
            '  (L) Tornado',
            '  (L) Lightning',
            '  (L) Snow',
            ' (F) Animals',
            '  (L) Wolf Finder',
            '  (L) Killer Whale',
            '  (L) Lion Finder',
            '  (L) Monkey Finder',
            '  (L) Parrotlet',
            '  (L) White Horse',
            ' (F) Instruments',
            '  (L) Electric Guitar',
            '  (L) Acoustic Guitar',
            '  (L) Sound Mixer',
            '  (L) Electric Piano',
            '  (L) Piano',
            '  (L) Violin',
            ' (L) Bread Basket',
            ' (L) Informational Book',
            ' (L) Stop sign',
            ' (L) Chain boat navigation',
            ' (L) Gallery of Maps',
            ' (L) Chart Course',
            '(F) jones',
            ' (L) Bass Fishing',
            ' (L) Killer Whale',
            ' (L) Lager',
            '(F) julia',
            ' (L) Astrology software',
            '(F) wsmith',
            ' (F) old',
            '  (L) Air Mail',
            '  (L) Bread Basket',
            ' (F) heros',
            '  (L) Iron Man',
            '  (L) Jean Grey',
            '  (L) Mallrats',
            ' (F) planets',
            '  (L) Azeroth',
            '  (L) Saturn',
            ' (L) Diamond',
            ' (L) Grandfather clock',
            ' (L) Baltimore Ravens'
        ]
        self.library_object = BookmarkFolder.parse_shorthand_list(self.library)

        self.notifications = [
            '(F) bigbrother',
            ' (F) listing',
            '  (F) aaronson',
            '   (L) Snowupdatenextweek',
            '  (F) betaraybill',
            '   (L) Auserhasratedlisting<b>HouseStark</b>1star',
            '  (F) bettafish',
            '   (L) Auserhasratedlisting<b>Tornado</b>1star',
            '   (L) Stopsignupdatenextweek',
            '  (F) bigbrother',
            '   (L) AcousticGuitarupdatenextweek',
            '   (L) AcousticGuitarupdatenextweek',
            '   (L) Auserhasratedlisting<b>AcousticGuitar</b>3stars',
            '   (L) Auserhasratedlisting<b>NetworkSwitch</b>4stars',
            '   (L) Auserhasratedlisting<b>Tornado</b>1star',
            '   (L) ElectricGuitarupdatenextweek',
            '   (L) ElectricPianoupdatenextweek',
            '   (L) InformationalBookupdatenextweek',
            '   (L) KillerWhaleupdatenextweek',
            '   (L) KillerWhaleupdatenextweek',
            '   (L) Lightningupdatenextweek',
            '   (L) LionFinderupdatenextweek',
            '   (L) MonkeyFinderupdatenextweek',
            '   (L) Pianoupdatenextweek',
            '   (L) SoundMixerupdatenextweek',
            '   (L) Tornadoupdatenextweek',
            '   (L) Violinupdatenextweek',
            '   (L) WhiteHorseupdatenextweek',
            '   (L) WolfFinderupdatenextweek',
            '   (L) WolfFinderupdatenextweek',
            '  (F) charrington',
            '   (L) Auserhasratedlisting<b>AcousticGuitar</b>3stars',
            '  (F) jones',
            '   (L) Auserhasratedlisting<b>KillerWhale</b>4stars',
            '   (L) Auserhasratedlisting<b>MonkeyFinder</b>1star',
            '   (L) Parrotletupdatenextweek',
            '  (F) julia',
            '   (L) BreadBasketupdatenextweek',
            '   (L) BreadBasketupdatenextweek',
            '  (F) khaleesi',
            '   (L) Auserhasratedlisting<b>HouseLannister</b>1star',
            '   (L) Auserhasratedlisting<b>HouseStark</b>4stars',
            '   (L) Auserhasratedlisting<b>LionFinder</b>1star',
            '   (L) Auserhasratedlisting<b>MonkeyFinder</b>1star',
            '   (L) Auserhasratedlisting<b>Tornado</b>1star',
            '   (L) Auserhasratedlisting<b>WhiteHorse</b>4stars',
            '   (L) Auserhasratedlisting<b>WolfFinder</b>4stars',
            '  (F) rutherford',
            '   (L) Auserhasratedlisting<b>Greatwhiteshark</b>3stars',
            '   (L) Auserhasratedlisting<b>JarofFlies</b>3stars',
            '   (L) Auserhasratedlisting<b>KillerWhale</b>3stars',
            '   (L) Auserhasratedlisting<b>WolfFinder</b>5stars',
            '   (L) Chainboatnavigationupdatenextweek',
            '   (L) GalleryofMapsupdatenextweek',
            '  (F) syme',
            '   (L) Auserhasratedlisting<b>AcousticGuitar</b>5stars',
            '   (L) Auserhasratedlisting<b>Greatwhiteshark</b>5stars',
            '   (L) Auserhasratedlisting<b>InformationalBook</b>5stars',
            '  (F) wsmith',
            '   (L) Auserhasratedlisting<b>AcousticGuitar</b>1star',
            '   (L) Auserhasratedlisting<b>SailboatRacing</b>3stars',
            '   (L) ChartCourseupdatenextweek',
            '   (L) ChartCourseupdatenextweek',
            ' (F) system',
            '  (F) julia',
            '   (L) Systemwillbefunctioninginadegredadedstatebetween1800Z-0400ZonA/B',
            '  (F) wsmith',
            '   (L) Systemwillbegoingdownforapproximately30minutesonX/Yat1100Z',
            '(F) jones',
            ' (F) listing',
            '  (F) bettafish',
            '   (L) Auserhasratedlisting<b>ProjectManagement</b>1star',
            '   (L) BassFishingupdatenextweek',
            '   (L) Lagerupdatenextweek',
            '  (F) bigbrother',
            '   (L) KillerWhaleupdatenextweek',
            '   (L) KillerWhaleupdatenextweek',
            '  (F) jones',
            '   (L) Auserhasratedlisting<b>BassFishing</b>4stars',
            '  (F) khaleesi',
            '   (L) Auserhasratedlisting<b>Barbecue</b>5stars',
            '   (L) Auserhasratedlisting<b>Moonshine</b>5stars',
            '   (L) Auserhasratedlisting<b>ProjectManagement</b>2stars',
            '  (F) rutherford',
            '   (L) Auserhasratedlisting<b>Moonshine</b>2stars',
            '  (F) wsmith',
            '   (L) Auserhasratedlisting<b>Harley-DavidsonCVO</b>3stars',
            '   (L) Auserhasratedlisting<b>Strokeplay</b>3stars',
            ' (F) system',
            '  (F) julia',
            '   (L) Systemwillbefunctioninginadegredadedstatebetween1800Z-0400ZonA/B',
            '  (F) wsmith',
            '   (L) Systemwillbegoingdownforapproximately30minutesonX/Yat1100Z',
            '(F) julia',
            ' (F) listing',
            '  (F) aaronson',
            '   (L) Auserhasratedlisting<b>Basketball</b>2stars',
            '   (L) Auserhasratedlisting<b>LITRANCH</b>1star',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>5stars',
            '  (F) betaraybill',
            '   (L) Auserhasratedlisting<b>Azeroth</b>5stars',
            '   (L) Auserhasratedlisting<b>Barsoom</b>5stars',
            '   (L) Auserhasratedlisting<b>HouseStark</b>1star',
            '   (L) Auserhasratedlisting<b>Jasoom</b>5stars',
            '   (L) Auserhasratedlisting<b>Jupiter</b>5stars',
            '   (L) Auserhasratedlisting<b>Neptune</b>5stars',
            '   (L) Auserhasratedlisting<b>Pluto(Notaplanet)</b>1star',
            '   (L) Auserhasratedlisting<b>Saturn</b>3stars',
            '   (L) Auserhasratedlisting<b>Sun</b>5stars',
            '   (L) Auserhasratedlisting<b>Venus</b>4stars',
            '  (F) bettafish',
            '   (L) Astrologysoftwareupdatenextweek',
            '   (L) Auserhasratedlisting<b>Azeroth</b>5stars',
            '   (L) Auserhasratedlisting<b>BaltimoreRavens</b>5stars',
            '   (L) Auserhasratedlisting<b>Barsoom</b>5stars',
            '   (L) Auserhasratedlisting<b>BusinessManagementSystem</b>4stars',
            '   (L) Auserhasratedlisting<b>FightClub</b>3stars',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '   (L) Auserhasratedlisting<b>ProjectManagement</b>1star',
            '  (F) bigbrother',
            '   (L) AcousticGuitarupdatenextweek',
            '   (L) AcousticGuitarupdatenextweek',
            '   (L) Auserhasratedlisting<b>BusinessManagementSystem</b>3stars',
            '   (L) Auserhasratedlisting<b>ChartCourse</b>5stars',
            '   (L) Auserhasratedlisting<b>KomodoDragon</b>1star',
            '   (L) Auserhasratedlisting<b>Minesweeper</b>5stars',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>5stars',
            '   (L) Auserhasratedlisting<b>MixingConsole</b>1star',
            '   (L) Auserhasratedlisting<b>MotorcycleHelmet</b>5stars',
            '   (L) Auserhasratedlisting<b>Stopsign</b>5stars',
            '   (L) Auserhasratedlisting<b>Ten</b>5stars',
            '  (F) bigbrother2',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '  (F) charrington',
            '   (L) Auserhasratedlisting<b>AirMail</b>5stars',
            '   (L) Auserhasratedlisting<b>JotSpot</b>4stars',
            '   (L) Auserhasratedlisting<b>LocationLister</b>4stars',
            '  (F) david',
            '   (L) Auserhasratedlisting<b>LITRANCH</b>5stars',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '   (L) Auserhasratedlisting<b>Ten</b>3stars',
            '  (F) jones',
            '   (L) Auserhasratedlisting<b>BassFishing</b>4stars',
            '   (L) Auserhasratedlisting<b>BreadBasket</b>2stars',
            '   (L) Auserhasratedlisting<b>Lager</b>5stars',
            '   (L) Auserhasratedlisting<b>Uranus</b>2stars',
            '  (F) julia',
            '   (L) Auserhasratedlisting<b>BreadBasket</b>5stars',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '  (F) khaleesi',
            '   (L) Auserhasratedlisting<b>AirMail</b>4stars',
            '   (L) Auserhasratedlisting<b>Azeroth</b>3stars',
            '   (L) Auserhasratedlisting<b>Barbecue</b>5stars',
            '   (L) Auserhasratedlisting<b>HouseStark</b>4stars',
            '   (L) Auserhasratedlisting<b>HouseTargaryen</b>5stars',
            '   (L) Auserhasratedlisting<b>LITRANCH</b>5stars',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '   (L) Auserhasratedlisting<b>Moonshine</b>5stars',
            '   (L) Auserhasratedlisting<b>ProjectManagement</b>2stars',
            '   (L) Auserhasratedlisting<b>Ruby</b>5stars',
            '  (F) obrien',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '  (F) rutherford',
            '   (L) Auserhasratedlisting<b>Bleach</b>4stars',
            '   (L) Auserhasratedlisting<b>Clerks</b>3stars',
            '   (L) Auserhasratedlisting<b>ClerksII</b>3stars',
            '   (L) Auserhasratedlisting<b>Greatwhiteshark</b>3stars',
            '   (L) Auserhasratedlisting<b>JarofFlies</b>3stars',
            '   (L) Auserhasratedlisting<b>Minesweeper</b>2stars',
            '   (L) Auserhasratedlisting<b>Moonshine</b>2stars',
            '   (L) Auserhasratedlisting<b>Stopsign</b>5stars',
            '   (L) Auserhasratedlisting<b>Ten</b>4stars',
            '  (F) syme',
            '   (L) Auserhasratedlisting<b>AirMail</b>1star',
            '   (L) Auserhasratedlisting<b>Azeroth</b>5stars',
            '   (L) Auserhasratedlisting<b>Barsoom</b>3stars',
            '   (L) Auserhasratedlisting<b>Basketball</b>5stars',
            '   (L) Auserhasratedlisting<b>Bleach</b>5stars',
            '   (L) Auserhasratedlisting<b>BusinessManagementSystem</b>2stars',
            '   (L) Auserhasratedlisting<b>Greatwhiteshark</b>5stars',
            '   (L) Auserhasratedlisting<b>Jasoom</b>2stars',
            '   (L) Auserhasratedlisting<b>Jupiter</b>3stars',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '   (L) Auserhasratedlisting<b>Neptune</b>1star',
            '   (L) Auserhasratedlisting<b>Pluto(Notaplanet)</b>5stars',
            '   (L) Auserhasratedlisting<b>Saturn</b>5stars',
            '   (L) Auserhasratedlisting<b>Sun</b>5stars',
            '   (L) Auserhasratedlisting<b>Uranus</b>5stars',
            '   (L) Auserhasratedlisting<b>Venus</b>1star',
            '  (F) tparsons',
            '   (L) Auserhasratedlisting<b>AirMail</b>3stars',
            '  (F) wsmith',
            '   (L) Auserhasratedlisting<b>Azeroth</b>3stars',
            '   (L) Auserhasratedlisting<b>ChartCourse</b>2stars',
            '   (L) Auserhasratedlisting<b>Harley-DavidsonCVO</b>3stars',
            '   (L) Auserhasratedlisting<b>Lager</b>2stars',
            '   (L) Auserhasratedlisting<b>MiniDachshund</b>1star',
            '   (L) Auserhasratedlisting<b>Strokeplay</b>3stars',
            ' (F) system',
            '  (F) julia',
            '   (L) Systemwillbefunctioninginadegredadedstatebetween1800Z-0400ZonA/B',
            '  (F) wsmith',
            '   (L) Systemwillbegoingdownforapproximately30minutesonX/Yat1100Z',
            '(F) wsmith',
            ' (F) listing',
            '  (F) betaraybill',
            '   (L) Auserhasratedlisting<b>HouseStark</b>1star',
            '   (L) Azerothupdatenextweek',
            '   (L) Azerothupdatenextweek',
            '   (L) Saturnupdatenextweek',
            '  (F) bettafish',
            '   (L) Auserhasratedlisting<b>BusinessManagementSystem</b>4stars',
            '   (L) Auserhasratedlisting<b>ProjectManagement</b>1star',
            '   (L) BaltimoreRavensupdatenextweek',
            '   (L) BaltimoreRavensupdatenextweek',
            '   (L) Grandfatherclockupdatenextweek',
            '   (L) Mallratsupdatenextweek',
            '   (L) Mallratsupdatenextweek',
            '  (F) bigbrother',
            '   (L) Auserhasratedlisting<b>BusinessManagementSystem</b>3stars',
            '   (L) Auserhasratedlisting<b>ChartCourse</b>5stars',
            '   (L) Auserhasratedlisting<b>KomodoDragon</b>1star',
            '  (F) charrington',
            '   (L) Auserhasratedlisting<b>AirMail</b>5stars',
            '   (L) Auserhasratedlisting<b>JotSpot</b>4stars',
            '   (L) Auserhasratedlisting<b>LocationLister</b>4stars',
            '  (F) jones',
            '   (L) Auserhasratedlisting<b>BassFishing</b>4stars',
            '   (L) Auserhasratedlisting<b>BreadBasket</b>2stars',
            '   (L) Auserhasratedlisting<b>Lager</b>5stars',
            '  (F) julia',
            '   (L) Auserhasratedlisting<b>BreadBasket</b>5stars',
            '   (L) BreadBasketupdatenextweek',
            '   (L) BreadBasketupdatenextweek',
            '  (F) khaleesi',
            '   (L) Auserhasratedlisting<b>AirMail</b>4stars',
            '   (L) Auserhasratedlisting<b>Barbecue</b>5stars',
            '   (L) Auserhasratedlisting<b>HouseStark</b>4stars',
            '   (L) Auserhasratedlisting<b>HouseTargaryen</b>5stars',
            '   (L) Auserhasratedlisting<b>Moonshine</b>5stars',
            '   (L) Auserhasratedlisting<b>ProjectManagement</b>2stars',
            '   (L) Auserhasratedlisting<b>Ruby</b>5stars',
            '  (F) rutherford',
            '   (L) Auserhasratedlisting<b>Bleach</b>4stars',
            '   (L) Auserhasratedlisting<b>Moonshine</b>2stars',
            '  (F) syme',
            '   (L) Auserhasratedlisting<b>AirMail</b>1star',
            '   (L) Auserhasratedlisting<b>Bleach</b>5stars',
            '   (L) Auserhasratedlisting<b>BusinessManagementSystem</b>2stars',
            '   (L) IronManupdatenextweek',
            '   (L) JeanGreyupdatenextweek',
            '  (F) tparsons',
            '   (L) Auserhasratedlisting<b>AirMail</b>3stars',
            '  (F) wsmith',
            '   (L) AirMailupdatenextweek',
            '   (L) AirMailupdatenextweek',
            '   (L) Auserhasratedlisting<b>ChartCourse</b>2stars',
            '   (L) Auserhasratedlisting<b>Harley-DavidsonCVO</b>3stars',
            '   (L) Auserhasratedlisting<b>Lager</b>2stars',
            '   (L) Auserhasratedlisting<b>Strokeplay</b>3stars',
            '   (L) Diamondupdatenextweek',
            ' (F) system',
            '  (F) julia',
            '   (L) Systemwillbefunctioninginadegredadedstatebetween1800Z-0400ZonA/B',
            '  (F) wsmith',
            '   (L) Systemwillbegoingdownforapproximately30minutesonX/Yat1100Z'
        ]

        self.notifications_object = BookmarkFolder.parse_shorthand_list(self.notifications)

        self.self_notifications_wsmith = [
            "(message:Saturn update next week,notification_type:listing)",
            "(message:Mallrats update next week,notification_type:listing)",
            "(message:Mallrats update next week,notification_type:listing)",
            "(message:Jean Grey update next week,notification_type:listing)",
            "(message:Iron Man update next week,notification_type:listing)",
            "(message:Grandfather clock update next week,notification_type:listing)",
            "(message:Diamond update next week,notification_type:listing)",
            "(message:Bread Basket update next week,notification_type:listing)",
            "(message:Bread Basket update next week,notification_type:listing)",
            "(message:Baltimore Ravens update next week,notification_type:listing)",
            "(message:Baltimore Ravens update next week,notification_type:listing)",
            "(message:Azeroth update next week,notification_type:listing)",
            "(message:Azeroth update next week,notification_type:listing)",
            "(message:Air Mail update next week,notification_type:listing)",
            "(message:Air Mail update next week,notification_type:listing)",
            "(message:A user has rated listing <b>Stroke play</b> 3 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Ruby</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Project Management</b> 1 star,notification_type:listing)",
            "(message:A user has rated listing <b>Project Management</b> 2 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Moonshine</b> 2 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Moonshine</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>LocationLister</b> 4 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Lager</b> 2 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Lager</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Komodo Dragon</b> 1 star,notification_type:listing)",
            "(message:A user has rated listing <b>JotSpot</b> 4 stars,notification_type:listing)",
            "(message:A user has rated listing <b>House Targaryen</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>House Stark</b> 4 stars,notification_type:listing)",
            "(message:A user has rated listing <b>House Stark</b> 1 star,notification_type:listing)",
            "(message:A user has rated listing <b>Harley-Davidson CVO</b> 3 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Chart Course</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Chart Course</b> 2 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Business Management System</b> 2 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Business Management System</b> 4 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Business Management System</b> 3 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Bread Basket</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Bread Basket</b> 2 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Bleach</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Bleach</b> 4 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Bass Fishing</b> 4 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Barbecue</b> 5 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Air Mail</b> 4 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Air Mail</b> 1 star,notification_type:listing)",
            "(message:A user has rated listing <b>Air Mail</b> 3 stars,notification_type:listing)",
            "(message:A user has rated listing <b>Air Mail</b> 5 stars,notification_type:listing)",
            "(message:System will be functioning in a degredaded state between 1800Z-0400Z on A/B,notification_type:system)",
            "(message:System will be going down for approximately 30 minutes on X/Y at 1100Z,notification_type:system)"
        ]

    @classmethod
    def setUpTestData(cls):
        """
        Set up test data for the whole TestCase (only run once for the TestCase)
        """
        data_gen.run()

    def _format_notification_response(self, response):
        return ['{}-{}-{}'.format(entry['entity_id'], entry['notification_type'], ''.join(entry['message'].split())) for entry in response.data]

    def test_get_self_notification(self):
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        for current_notification in response.data:
            valid_keys = ['id', 'created_date', 'expires_date', 'message', 'author',
                          'listing', 'agency', 'notification_type', 'peer',
                          'notification_id', 'read_status', 'acknowledged_status']

            for key in valid_keys:
                self.assertIn(key, current_notification)

    def test_get_self_notification_unauthorized(self):
        url = '/api/self/notification/'
        response = self.client.get(url, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_get_self_notification_ordering(self):
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        notification_list = shorthand_dict(response.data, include_keys=['notification_type', 'message'])

        self.assertListEqual(notification_list, self.self_notifications_wsmith)

        # Get reversed order
        url = '/api/self/notification/?ordering=-notification__created_date'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        notification_list = shorthand_dict(response.data, include_keys=['notification_type', 'message'])

        self.assertEqual(notification_list, self.self_notifications_wsmith)

        # Get ascending order
        url = '/api/self/notification/?ordering=notification__created_date'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        notification_list = shorthand_dict(response.data, include_keys=['notification_type', 'message'])

        self.assertEqual(notification_list, list(reversed(self.self_notifications_wsmith)))

    def test_dismiss_self_notification(self):
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        actual_notifications = _parse_notification_to_bookmark_nodes(response.data)
        expected_notifications = self.notifications_object.search('/wsmith/').clone(show_root=False)

        self.assertListEqual(actual_notifications.shorten_data(order=True), expected_notifications.shorten_data(order=True))
        expected_notifications = actual_notifications

        dismiss_notification_object = expected_notifications.first_listing_bookmark()

        # now dismiss the first notification
        url = '{}{}/'.format(url, dismiss_notification_object.id)
        response = APITestHelper.request(self, url, 'DELETE', username='wsmith', status_code=204)

        # now get our notifications again, make sure the one was removed
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        actual_notifications = _parse_notification_to_bookmark_nodes(response.data)

        dismiss_notification_object.hidden(True)

        self.assertListEqual(actual_notifications.shorten_data(order=True), expected_notifications.shorten_data(order=True))

    def test_get_pending_notifications(self):
        url = '/api/notifications/pending/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        expires_at = [i['expires_date'] for i in response.data]
        self.assertTrue(len(expires_at) > 1)
        now = datetime.datetime.now(pytz.utc)
        for i in expires_at:
            test_time = datetime.datetime.strptime(i, "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=pytz.utc)
            self.assertTrue(test_time > now)

    def test_get_pending_notifications_user_unauthorized(self):
        url = '/api/notifications/pending/'
        APITestHelper.request(self, url, 'GET', username='jones', status_code=403)

    def test_all_pending_notifications_listing_filter(self):
        url = '/api/notifications/pending/?listing=1'  # ID 1 belongs to AcousticGuitar
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        notification_list = shorthand_dict(response.data, include_keys=['notification_type', 'message', 'author', 'author.user', 'author.user.username'])

        expected = [
            '(author:(user:(username:bigbrother)),message:Acoustic Guitar update next week,notification_type:listing)',
            '(author:(user:(username:bigbrother)),message:Acoustic Guitar update next week,notification_type:listing)',  # TODO: Figure out why this is here
            '(author:(user:(username:charrington)),message:A user has rated listing <b>Acoustic Guitar</b> 3 stars,notification_type:listing)',
            '(author:(user:(username:syme)),message:A user has rated listing <b>Acoustic Guitar</b> 5 stars,notification_type:listing)',
            '(author:(user:(username:wsmith)),message:A user has rated listing <b>Acoustic Guitar</b> 1 star,notification_type:listing)',
            '(author:(user:(username:bigbrother)),message:A user has rated listing <b>Acoustic Guitar</b> 3 stars,notification_type:listing)'
        ]

        self.assertEqual(expected, notification_list)

        notification_expires_date_list = [entry['expires_date'] for entry in response.data]

        now = datetime.datetime.now(pytz.utc)
        for i in notification_expires_date_list:
            test_time = datetime.datetime.strptime(i, "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=pytz.utc)
            self.assertTrue(test_time > now)

    def test_all_pending_notifications_listing_filter_user_authorized(self):
        url = '/api/notifications/pending/?listing=160'  # ID 160 belongs to Stroke play
        response = APITestHelper.request(self, url, 'GET', username='jones', status_code=200)
        notification_list = shorthand_dict(response.data, include_keys=['notification_type', 'message', 'author', 'author.user', 'author.user.username'])

        expected = [
            '(author:(user:(username:wsmith)),message:A user has rated listing <b>Stroke play</b> 3 stars,notification_type:listing)'
        ]

        self.assertEqual(expected, notification_list)

        notification_expires_date_list = [entry['expires_date'] for entry in response.data]

        now = datetime.datetime.now(pytz.utc)
        for i in notification_expires_date_list:
            test_time = datetime.datetime.strptime(i, "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=pytz.utc)
            self.assertTrue(test_time > now)

    def test_all_pending_notifications_listing_filter_user_unauthorized(self):
        url = '/api/notifications/pending/?listing=1'
        APITestHelper.request(self, url, 'GET', username='jones', status_code=403)
        # TODO Check response

    def test_get_expired_notifications(self):
        url = '/api/notifications/expired/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)

        expires_at = [i['expires_date'] for i in response.data]
        self.assertTrue(len(expires_at) > 1)
        now = datetime.datetime.now(pytz.utc)
        for i in expires_at:
            test_time = datetime.datetime.strptime(i,
                "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=pytz.utc)
            self.assertTrue(test_time < now)

    def test_get_expired_notifications_user_unauthorized(self):
        url = '/api/notifications/expired/'
        APITestHelper.request(self, url, 'GET', username='jones', status_code=403)
        # TODO Check response

    # TODO should work when data script gets refactored (rivera 20160620)
    @skip("should work when data script gets refactored (rivera 20160620)")
    def test_all_expired_notifications_listing_filter(self):
        url = '/api/notifications/expired/?listing=1'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)

        ids = [i['id'] for i in response.data]
        expires_at = [i['expires_date'] for i in response.data]
        self.assertTrue(ids, [1])
        self.assertTrue(len(expires_at) == 1)
        now = datetime.datetime.now(pytz.utc)
        for i in expires_at:
            test_time = datetime.datetime.strptime(i,
                "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=pytz.utc)
            self.assertTrue(test_time < now)

    def test_all_expired_notifications_listing_filter_user_authorized(self):
        # Create new listing notification with listing id 160
        now = datetime.datetime.now() - datetime.timedelta(days=7)
        data = {'expires_date': str(now),
                'message': 'a simple listing test',
                'listing': {
            'id': 160
            }}
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='jones', status_code=201)

        # Verify that listing was created and expired
        url = '/api/notifications/expired/?listing=160'  # ID 160 belongs to Stroke play
        response = APITestHelper.request(self, url, 'GET', username='jones', status_code=200)

        notification_list = self._format_notification_response(response)
        expected = ['160-listing-asimplelistingtest']
        self.assertEqual(expected, notification_list)

    def test_all_expired_notifications_listing_filter_user_unauthorized(self):
        url = '/api/notifications/expired/?listing=1'
        APITestHelper.request(self, url, 'GET', username='jones', status_code=403)

    # TODO: test_all_notifications_listing_filter (rivera 20160617)

    def test_create_system_notification(self):
        data = {'expires_date': '2016-09-01T15:45:55.322421Z',
                'message': 'a simple test'}
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['message'], data['message'])
        self.assertEqual(response.data['notification_type'], 'system')

    def test_create_system_notification_unauthorized_user(self):
        # test_create_system_notification_unauthorized_user
        # test unauthorized user - only org stewards and above can create
        data = {'expires_date': '2016-09-01T15:45:55.322421Z',
                'message': 'a simple test'}
        url = '/api/notification/'

        APITestHelper.request(self, url, 'POST', data=data, username='jones', status_code=403)

    def test_update_system_notification(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now)}
        url = '/api/notification/1/'

        APITestHelper.request(self, url, 'PUT', data=data, username='wsmith', status_code=200)
        # TODO: Verify expires_date

    def test_update_system_notification_unauthorized_user(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now)}
        url = '/api/notification/1/'

        APITestHelper.request(self, url, 'PUT', data=data, username='jones', status_code=403)

    # TODO below test should work when permission gets refactored (rivera 20160620)
    @skip("should work permissions gets refactored (rivera 20160620)")
    def test_update_system_notification_unauthorized_org_steward(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now)}
        url = '/api/notification/1/'

        APITestHelper.request(self, url, 'PUT', data=data, username='wsmith', status_code=403)

    def test_create_listing_notification_app_mall_steward(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'a simple listing test',
                'listing': {
            'id': 1
            }}
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['message'], 'a simple listing test')
        self.assertEqual(response.data['notification_type'], 'listing')
        self.assertEqual(response.data['listing']['id'], 1)
        self.assertEqual(response.data['agency'], None)
        self.assertTrue('expires_date' in data)

    def test_create_listing_notification_invalid_format_all_groups(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'a simple listing test',
                'listing': {'invalid': 1}
                }
        url = '/api/notification/'
        usernames = ['bigbrother', 'wsmith', 'jones']

        for username in usernames:
            response = APITestHelper.request(self, url, 'POST', data=data, username=username, status_code=400)
            self.assertEqual(response.data, ExceptionUnitTestHelper.validation_error("{'non_field_errors': ['Valid Listing ID is required']}"))

    def test_create_listing_notification_invalid_id_all_groups(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'a simple listing test',
                'listing': {'id': -1}
                }
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=400)
        usernames = ['bigbrother', 'wsmith', 'jones']

        for username in usernames:
            response = APITestHelper.request(self, url, 'POST', data=data, username=username, status_code=400)
            self.assertEqual(response.data, ExceptionUnitTestHelper.validation_error("{'non_field_errors': ['Could not find listing']}"))

    def test_create_listing_agency_notification_app_mall_steward_invalid(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'a simple listing test',
                'listing': {'id': 1},
                'agency': {'id': 1}
               }

        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=400)

        self.assertEqual(response.data, ExceptionUnitTestHelper.validation_error('{\'non_field_errors\': ["Notifications can only be one type. ''Input: [\'listing\', \'agency\']"]}'))

    def test_create_listing_notification_org_steward(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'a simple listing test',
                'listing': {'id': 1}
                }

        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='wsmith', status_code=201)

        self.assertEqual(response.data['message'], 'a simple listing test')
        self.assertEqual(response.data['notification_type'], 'listing')
        self.assertEqual(response.data['listing']['id'], 1)
        self.assertEqual(response.data['agency'], None)
        self.assertTrue('expires_date' in data)

    def test_create_agency_notification_app_mall_steward(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'A Simple Agency Test',
                'agency': {'id': 1}}
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['message'], 'A Simple Agency Test')
        self.assertEqual(response.data['notification_type'], 'agency')
        self.assertEqual(response.data['agency']['id'], 1)
        self.assertEqual(response.data['listing'], None)
        self.assertTrue('expires_date' in data)

    def test_create_agency_notification_app_mall_steward_invalid_format(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'a simple agency test',
                'agency': {'invalid': 1}
                }
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=400)

        self.assertEqual(response.data, ExceptionUnitTestHelper.validation_error("{'non_field_errors': ['Valid Agency ID is required']}"))

    def test_create_agency_notification_app_mall_steward_invalid_id(self):
        now = datetime.datetime.now(pytz.utc)
        data = {'expires_date': str(now),
                'message': 'a simple agency test',
                'agency': {'id': -1}
                }
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=400)

        self.assertEqual(response.data, ExceptionUnitTestHelper.validation_error("{'non_field_errors': ['Could not find agency']}"))

    # TODO: test_create_agency_notification_org_steward (rivera 20160617)
    # TODO: test_create_agency_notification_org_steward_invalid (rivera 20160617)
    # TODO: test_create_agency_notification_user_unauthorized (rivera 20160617)

    def test_create_peer_notification_app_mall_steward(self):
        now = datetime.datetime.now(pytz.utc)
        data = {"expires_date": str(now),
                "message": "A Simple Peer to Peer Notification",
                "peer": {
                    "user": {
                      "username": "jones"
                    }}
                }

        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['message'], 'A Simple Peer to Peer Notification')
        self.assertEqual(response.data['notification_type'], 'peer')
        self.assertEqual(response.data['agency'], None)
        self.assertEqual(response.data['listing'], None)
        self.assertEqual(response.data['peer'], {'user': {'username': 'jones'}})
        self.assertTrue('expires_date' in data)

    def test_create_review_request_notification_app_mall_steward(self):
        now = datetime.datetime.now(pytz.utc)
        data = {
            "expires_date": str(now),
            "message": "Please review your agency's apps and make sure their information is up to date",
            "notification_type": "StewardAppNotification"
        }

        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['message'], "Please review your agency's apps and make sure their information is up to date")
        self.assertEqual(response.data['notification_type'], 'system')
        self.assertEqual(response.data['notification_subtype'], 'review_request')
        self.assertEqual(response.data['agency'], None)
        self.assertEqual(response.data['listing'], None)
        self.assertEqual(response.data['peer'], None)
        self.assertTrue('expires_date' in data)

    @skip("should work when data script gets refactored so org stewards cant create system notifications (semesky 20171102)")
    def test_create_review_request_notification_unauthorized_org_steward(self):
        now = datetime.datetime.now(pytz.utc)
        data = {
            "expires_date": str(now),
            "message": "Please review your agency's apps and make sure their information is up to date",
            "notification_type": "StewardAppNotification"
        }

        url = '/api/notification/'
        APITestHelper.request(self, url, 'POST', data=data, username='wsmith', status_code=403)

    def test_create_review_request_notification_unauthorized_user(self):
        now = datetime.datetime.now(pytz.utc)
        data = {
            "expires_date": str(now),
            "message": "Please review your agency's apps and make sure their information is up to date",
            "notification_type": "StewardAppNotification"
        }

        url = '/api/notification/'
        APITestHelper.request(self, url, 'POST', data=data, username='jones', status_code=403)

    @skip("should work when data script gets refactored (rivera 20160620)")
    def test_create_peer_bookmark_notification_app_mall_steward(self):

        now = datetime.datetime.now(pytz.utc)
        data = {
            "expires_date": str(now),
            "message": "A Simple Peer to Peer Notification",
            "peer": {
                "user": {
                  "username": "jones"
                },
                "folder_name": "folder"
            }
        }
        url = '/api/notification/'
        response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

        self.assertEqual(response.data['message'], 'A Simple Peer to Peer Notification')
        self.assertEqual(response.data['notification_type'], 'peer_bookmark')
        self.assertEqual(response.data['agency'], None)
        self.assertEqual(response.data['listing'], None)
        self.assertTrue('expires_date' in data)

    def test_create_review_notification(self):
        # Check notifications for new review notification
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        notification_count = len(response.data)

        # Review for Lamprey listing owned by bigbrother
        review_data = {
            "listing": 91,
            "rate": 5,
            "text": "This is a review for the listing"
        }
        url = '/api/listing/91/review/'
        response = APITestHelper.request(self, url, 'POST', data=review_data, username='jones', status_code=201)

        # Check notifications for new review notification
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)

        self.assertEqual(len(response.data), notification_count + 1)
        self.assertEqual(response.data[0]['entity_id'], review_data['listing'])
        self.assertEqual(response.data[0]['author']['user']['username'], 'jones')
        self.assertEqual(response.data[0]['listing']['title'], 'Lamprey')
        self.assertEqual(response.data[0]['message'], 'A user has rated listing <b>Lamprey</b> 5 stars')

    def test_create_review_response(self):
        # Review for Lamprey listing owned by bigbrother
        review_data = {
            "listing": 91,
            "rate": 5,
            "text": "This is a review for the listing"
        }
        url = '/api/listing/91/review/'
        response = APITestHelper.request(self, url, 'POST', data=review_data, username='jones', status_code=201)

        # Create response to the review created
        review_response_data = {
            "listing": 91,
            "rate": 1,
            "text": "This is a response to a review",
            "review_parent": response.data['id']
        }
        url = '/api/listing/91/review/'
        APITestHelper.request(self, url, 'POST', data=review_response_data, username='jones', status_code=201)

        # Verify no notifications has been created for creating a review response
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)

        self.assertEqual(response.data[0]['entity_id'], review_data['listing'])
        self.assertEqual(response.data[0]['author']['user']['username'], 'jones')
        self.assertEqual(response.data[0]['listing']['title'], 'Lamprey')
        self.assertEqual(response.data[0]['message'], 'A user has rated listing <b>Lamprey</b> 5 stars')

    # TODO test_create_peer_notification_invalid (rivera 20160617)
    # TODO test_create_peer_bookmark_notification (rivera 20160617)
    @skip("TODO: Make this work")
    def test_create_restore_bookmark_notification_integration(self):
        """
        test_create_restore_bookmark_notification_integration

        Setup initial bookmark / folders for bigbrother
        Create notification that folder Instruments has been deleted
        Delete Instruments folder
        Restore Instruments folder
        """
        # Library for user
        user_library = {}
        user_library['bigbrother'] = self.user_library_bigbrother
        # Compare Notifications for user
        user_notifications_list = {}
        user_notifications_list['bigbrother'] = self.self_notifications_bigbrother

        usernames_list_main = user_notifications_list
        usernames_list_actual = {}
        for username, ids_list in user_notifications_list.items():
            url = '/api/self/notification/'
            response = APITestHelper.request(self, url, 'GET', username=username, status_code=200)

            before_notification_ids = ['{}-{}'.format(entry.get('notification_type'), ''.join(entry.get('message').split())) for entry in response.data]
            usernames_list_actual[username] = before_notification_ids

        for username, ids_list in user_notifications_list.items():
            before_notification_ids = usernames_list_actual[username]
            self.assertEqual(ids_list, before_notification_ids, 'Checking for {}'.format(username))

        self._compare_user_notification(usernames_list_main)

        _compare_library(self, user_library)

        # Create Bookmark Notification
        bookmark_notification_ids = []
        bookmark_notification_ids_raw = []

        for i in range(3):
            now = datetime.datetime.now(pytz.utc) + datetime.timedelta(days=5)
            data = {
                'expires_date': str(now),
                'message': 'restore folder Instruments',
                'peer': {
                    'user': {
                        'username': 'bigbrother',
                    },
                    'folder_name': 'Instruments',
                    'deleted_folder': True
                }
            }

            url = '/api/notification/'
            response = APITestHelper.request(self, url, 'POST', data=data, username='bigbrother', status_code=201)

            self.assertEqual(response.data['message'], 'restore folder Instruments')
            self.assertEqual(response.data['notification_type'], 'restore_bookmark')
            self.assertEqual(response.data['agency'], None)
            self.assertEqual(response.data['listing'], None)
            peer_data = {'user': {'username': 'bigbrother'}, 'folder_name': 'Instruments', 'deleted_folder': True}  # '_bookmark_listing_ids': [3, 4]}
            self.assertEqual(response.data['peer'], peer_data)
            self.assertTrue('expires_date' in data)

            bookmark_notification_ids.append('{}-{}'.format(response.data['notification_type'], ''.join(response.data['message'].split())))
            bookmark_notification_ids_raw.append(response.data['id'])

            # Compare Notifications for users
            user_notifications_list = copy.deepcopy(usernames_list_main)
            user_notifications_list['bigbrother'] = bookmark_notification_ids[::-1] + usernames_list_main['bigbrother']

            usernames_list_actual = {}
            for username, ids_list in user_notifications_list.items():
                url = '/api/self/notification/'
                response = APITestHelper.request(self, url, 'GET', username=username, status_code=200)

                before_notification_ids = ['{}-{}'.format(entry.get('notification_type'), ''.join(entry.get('message').split())) for entry in response.data]
                usernames_list_actual[username] = before_notification_ids

            for username, ids_list in user_notifications_list.items():
                before_notification_ids = usernames_list_actual[username]
                self.assertEqual(response.status_code, status.HTTP_200_OK)
                self.assertEqual(ids_list, before_notification_ids, 'Checking for {}'.format(username))

        bookmark_notification1_id = bookmark_notification_ids_raw[0]

        # Delete Bookmark Folder - 18 is the folder Instruments
        APITestHelper._delete_bookmark_folder(self, 'bigbrother', 18, status_code=204)

        # Compare Library for users
        user_library = {}
        user_library['bigbrother'] = [
            'Tornado-Weather',
            'Lightning-Weather',
            'Snow-Weather',
            'Wolf Finder-Animals',
            'Killer Whale-Animals',
            'Lion Finder-Animals',
            'Monkey Finder-Animals',
            'Parrotlet-Animals',
            'White Horse-Animals',
            'Bread Basket-None',
            'Informational Book-None',
            'Stop sign-None',
            'Chain boat navigation-None',
            'Gallery of Maps-None',
            'Chart Course-None'
        ]

        _compare_library(self, user_library)

        # Import Bookmarks
        APITestHelper._import_bookmarks(self, 'bigbrother', bookmark_notification1_id, status_code=201)

        imported_bookmarks = ['Electric Guitar-Instruments',
                              'Acoustic Guitar-Instruments',
                              'Sound Mixer-Instruments',
                              'Electric Piano-Instruments',
                              'Piano-Instruments',
                              'Violin-Instruments']
        user_library['bigbrother'] = user_library['bigbrother'] + imported_bookmarks

        _compare_library(self, user_library)

        # Compare Notifications for users
        user_notifications_list = copy.deepcopy(usernames_list_main)
        user_notifications_list['bigbrother'] = bookmark_notification_ids[::-1] + usernames_list_main['bigbrother']

        _compare_user_notification(self, user_notifications_list)

    def test_create_peer_bookmark_notification_integration(self):
        """
        test_create_peer_bookmark_notification_integration

        TODO: refactor to make easier to understand and read code

        Listing ID: 1, 2, 3, 4
        wsmith (minitrue, stewarded_orgs: minitrue)
        julia (minitrue, stewarded_orgs: minitrue, miniluv)
        bigbrother2 - minitrue
        """
        # Library for users
        user_library = self.library_object
        _compare_library(self, user_library)
        _create_bookmark_bulk(self, 'wsmith', 'foldername1', [3, 4], user_library)

        _compare_user_notification(self, self.notifications_object)

        _compare_library(self, user_library)
        # Create Bookmark
        _create_bookmark_bulk(self, 'bigbrother', 'foldername2', [4], user_library)

        user_library_endpoint = _compare_library(self, user_library)

        # Create Bookmark Notification
        for i in range(3):
            response = _create_peer_bookmark(self, 'wsmith', 'julia', 'foldername1', self.notifications_object)

        bookmark_notification1_id = self.notifications_object.search('/{}/{}/'.format('julia', 'peer_bookmark')).first_listing_bookmark().id

        # Import Bookmarks
        APITestHelper._import_bookmarks(self, 'julia', bookmark_notification1_id, status_code=201)

        user_library.copy('/wsmith/foldername1/', '/julia/')

        _compare_library(self, user_library)
        _compare_user_notification(self, self.notifications_object)

    def test_delete_system_notification_apps_mall_steward(self):
        url = '/api/notification/1/'
        APITestHelper.request(self, url, 'DELETE', username='bigbrother', status_code=204)

    # TODO below test should work when permission gets refactored (rivera 20160620)
    @skip("should work when permission gets refactored (rivera 20160620)")
    def test_delete_system_notification_org_steward(self):
        url = '/api/notification/1/'
        response = APITestHelper.request(self, url, 'DELETE', username='wsmith', status_code=403)
        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied())

    def test_delete_system_notification_user_unauthorized(self):
        url = '/api/notification/1/'
        response = APITestHelper.request(self, url, 'DELETE', username='jones', status_code=403)
        self.assertEqual(response.data, ExceptionUnitTestHelper.permission_denied('Only Stewards can delete notifications'))

    # AMLNG-378 - As a user, I want to receive notification about changes on Listings I've bookmarked
    def test_receive_notification_bookmarked_listing_changes(self):
        # Have wsmith bookmark the listing
        response = APITestHelper.create_bookmark(self, 'wsmith', 1, folder_name='', status_code=201)

        # Make changes to the listing
        url = '/api/listing/1/'
        title = 'julias app 2'
        data = {
            "title": title,
            "description": "description of app",
            "launch_url": "http://www.google.com/launch",
            "version_name": "2.1.8",
            "unique_name": "org.apps.julia-one",
            "what_is_new": "nothing is new",
            "description_short": "a shorter description",
            "usage_requirements": "Many new things",
            "system_requirements": "Good System",
            "is_private": "true",
            "is_enabled": "false",
            "is_featured": "false",
            "feedback_score": 0,
            "contacts": [
                {"email": "a@a.com", "secure_phone": "111-222-3434",
                    "unsecure_phone": "444-555-4545", "name": "me",
                    "contact_type": {"name": "Government"}
                },
                {"email": "b@b.com", "secure_phone": "222-222-3333",
                    "unsecure_phone": "555-555-5555", "name": "you",
                    "contact_type": {"name": "Military"}
                }
            ],
            "security_marking": "SECRET",
            "listing_type": {"title": "Widget"},
            "small_icon": {"id": 1},
            "large_icon": {"id": 2},
            "banner_icon": {"id": 3},
            "large_banner_icon": {"id": 4},
            "categories": [
                {"title": "Business"},
                {"title": "Education"}
            ],
            "owners": [
                {"user": {"username": "wsmith"}},
                {"user": {"username": "julia"}}
            ],
            "agency": {"title": "Ministry of Love", "short_name": "Miniluv"},
            "tags": [
                {"name": "demo"},
                {"name": "map"}
            ],
            "intents": [
                {"action": "/application/json/view"},
                {"action": "/application/json/edit"}
            ],
            "doc_urls": [
                {"name": "wiki", "url": "http://www.google.com/wiki2"},
                {"name": "guide", "url": "http://www.google.com/guide2"}
            ],
            "screenshots": [
                {"small_image": {"id": 1}, "large_image": {"id": 2}, "description": "Test Description"},
                {"small_image": {"id": 3}, "large_image": {"id": 4}, "description": "Test Description"}
            ]
        }

        # for checking Activity status later on
        response = APITestHelper.request(self, url, 'GET', username='julia', status_code=200)
        old_listing_data = response.data

        response = APITestHelper.edit_listing(self, 1, data, 'julia')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # get wsmith's notifications
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='wsmith', status_code=200)
        notification_list = self._format_notification_response(response)

        # Check if notification contains correct changes
        expected_data = '1-listing-The<b>juliasapp2</b>listingwasupdated.Thefollowingfieldshavechanged:Title,Description,DescriptionShort,LaunchUrl,VersionName,UsageRequirements,SystemRequirements,UniqueName,WhatIsNew,ListingType,Intents,Agency'
        self.assertEqual(notification_list[0], expected_data)

    # AMLNG-173 - As Org Content Steward, I want notification if an owner has cancelled an app that was pending deletion
    # AMLOS-490 - "Pend for deletion" request should launch notification to org steward.
    def test_receive_notification_pending_delete_changes(self):
        # Change agency of 1 to minitrue and owner of 122 and 123 to jones
        APITestHelper.edit_listing(self, 122, {"agency": {"short_name": "Minitrue", "title": "Ministry of Truth"}}, 'bigbrother')
        APITestHelper.edit_listing(self, 122, {"owners": [{"user": {"username": "jones"}}]}, 'bigbrother')
        APITestHelper.edit_listing(self, 123, {"agency": {"short_name": "Minitrue", "title": "Ministry of Truth"}}, 'bigbrother')
        APITestHelper.edit_listing(self, 123, {"owners": [{"user": {"username": "jones"}}]}, 'bigbrother')

        # PENDING_DELETION will send notificaiton to julia and big brother
        # Jones Pending will send message to julia and bigbrother
        APITestHelper.edit_listing(self, 122, {'approval_status': "PENDING_DELETION"}, 'jones')
        APITestHelper.edit_listing(self, 122, {'approval_status': "PENDING"}, 'jones')

        # Bigbrother and julia pending will send message to Jones
        APITestHelper.edit_listing(self, 122, {'approval_status': "PENDING_DELETION"}, 'jones')
        APITestHelper.edit_listing(self, 122, {'approval_status': "PENDING"}, 'bigbrother')
        APITestHelper.edit_listing(self, 122, {'approval_status': "PENDING_DELETION"}, 'jones')
        APITestHelper.edit_listing(self, 122, {'approval_status': "PENDING"}, 'julia')

        # Deleting will send message to Jones, bigbrother, and julia, independent of who deletes it.
        APITestHelper.edit_listing(self, 122, {'approval_status': "PENDING_DELETION"}, 'jones')
        url = '/api/listing/122/'
        data = {'description': 'delete listing'}
        user = generic_model_access.get_profile('bigbrother').user
        self.client.force_authenticate(user=user)
        response = self.client.delete(url, data=data, format='json')

        APITestHelper.edit_listing(self, 123, {'approval_status': "PENDING_DELETION"}, 'jones')
        url = '/api/listing/123/'
        data = {'description': 'delete listing'}
        user = generic_model_access.get_profile('julia').user
        self.client.force_authenticate(user=user)
        response = self.client.delete(url, data=data, format='json')

        # test jones' notifications
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='jones', status_code=200)
        notification_list = self._format_notification_response(response)
        expected_data = ['123-listing-The<b>Pencil</b>listingwasapprovedfordeletionbyanOrganizationSteward',
            '122-listing-The<b>Parrotlet</b>listingwasapprovedfordeletionbyanOrganizationSteward',
            '122-listing-The<b>Parrotlet</b>listingwasundeletedbyanOrganizationSteward',
            '122-listing-The<b>Parrotlet</b>listingwasundeletedbyanOrganizationSteward']
        self.assertEqual(notification_list[:4], expected_data)

        # test julia's notifications
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='julia', status_code=200)
        notification_list = self._format_notification_response(response)
        expected_data = ['123-listing-The<b>Pencil</b>listingwasapprovedfordeletionbyanOrganizationSteward',
            '123-listing-The<b>Pencil</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-The<b>Parrotlet</b>listingwasapprovedfordeletionbyanOrganizationSteward',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-AListingOwnercancelledthedeletionofthe<b>Parrotlet</b>listing.Thislistingisnowawaitingorganizationalapproval',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner']
        # TODO: fix unit test
        # self.assertEqual(notification_list[:8], expected_data)

        # test bigbrother's notifications
        url = '/api/self/notification/'
        response = APITestHelper.request(self, url, 'GET', username='bigbrother', status_code=200)
        notification_list = self._format_notification_response(response)
        expected_data = ['123-listing-The<b>Pencil</b>listingwasapprovedfordeletionbyanOrganizationSteward',
            '123-listing-The<b>Pencil</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-The<b>Parrotlet</b>listingwasapprovedfordeletionbyanOrganizationSteward',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner',
            '122-listing-AListingOwnercancelledthedeletionofthe<b>Parrotlet</b>listing.Thislistingisnowawaitingorganizationalapproval',
            '122-listing-The<b>Parrotlet</b>listingwassubmittedfordeletionbyitsowner']
        # TODO: fix unit test
        # self.assertEqual(notification_list[:8], expected_data)

    # TODO: Unittest for below
    # AMLNG-377 - As an owner or ORG CS, I want to receive notification of user rating and reviews
    # AMLNG-376 - As a ORG CS, I want to receive notification of Listings submitted for my organization
    # AMLNG-170 - As an Owner I want to receive notice of whether my deletion request has been approved or rejected
    # AMLNG-461 - As Developer, I want to refactor code to make it modular and easier way to add Notification Types
