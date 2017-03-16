"""
Creates test data

************************************WARNING************************************
Many of the unit tests depend on data set in this script. Always
run the unit tests (python manage.py test) after making any changes to this
data!!
************************************WARNING************************************
"""
from PIL import Image
import datetime
import json
import os
import pytz
import sys

sys.path.insert(0, os.path.realpath(os.path.join(os.path.dirname(__file__), '../../')))

from django.contrib import auth
from django.conf import settings

from ozpcenter import models
from ozpcenter import model_access
import ozpcenter.api.listing.model_access as listing_model_access

from ozpcenter.recommend.recommend import RecommenderDirectory


TEST_IMG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'test_images') + '/'

DEMO_APP_ROOT = settings.OZP['DEMO_APP_ROOT']


def create_listing_review_batch(*input_list):
    """
    Create Listing

    example:
        [
            listing,
            [charrington, 5, "This app is great - well designed and easy to use"],
            [tparsons, 3, "This app is great - well designed and easy to use"],
            [syme, 1, "This app is great - well designed and easy to use"]
        ]
    """
    current_listing = input_list[0]

    for input_set in input_list[1:]:
        profile_obj = input_set[0]
        current_rating = input_set[1]
        current_text = input_set[2]
        listing_model_access.create_listing_review(profile_obj.user.username, current_listing, current_rating,text=current_text)


def create_library_entries(*entries):
    """
    Create Bookmarks for users
    """
    for current_entry in entries:
        current_profile_string = current_entry[0]
        current_profile = models.Profile.objects.filter(user__username=current_profile_string).first()
        current_unique_name = current_entry[1]
        current_folder_name = current_entry[2]

        library_entry = models.ApplicationLibraryEntry(
            owner=current_profile,
            listing=models.Listing.objects.get(unique_name=current_unique_name),
            folder=current_folder_name)
        library_entry.save()


def run():
    """
    Creates basic sample data
    """
    # Create Groups
    models.Profile.create_groups()

    ############################################################################
    #                           Security Markings
    ############################################################################
    unclass = 'UNCLASSIFIED'
    secret = 'SECRET'
    secret_n = 'SECRET//NOVEMBER'
    ts = 'TOP SECRET'
    ts_s = 'TOP SECRET//SIERRA'
    ts_st = 'TOP SECRET//SIERRA//TANGO'
    ts_stgh = 'TOP SECRET//SIERRA//TANGO//GOLF//HOTEL'

    ts_n = 'TOP SECRET//NOVEMBER'
    ts_sn = 'TOP SECRET//SIERRA//NOVEMBER'
    ts_stn = 'TOP SECRET//SIERRA//TANGO//NOVEMBER'
    ts_stghn = 'TOP SECRET//SIERRA//TANGO//GOLF//HOTEL//NOVEMBER'

    ############################################################################
    #                           Categories
    ############################################################################
    books_ref = models.Category(title="Books and Reference", description="Things made of paper")
    books_ref.save()

    business = models.Category(title="Business", description="For making money")
    business.save()

    communication = models.Category(title="Communication", description="Moving info between people and things")
    communication.save()

    education = models.Category(title="Education", description="Educational in nature")
    education.save()

    entertainment = models.Category(title="Entertainment", description="For fun")
    entertainment.save()

    finance = models.Category(title="Finance", description="For managing money")
    finance.save()

    health_fitness = models.Category(title="Health and Fitness", description="Be healthy, be fit")
    health_fitness.save()

    media_video = models.Category(title="Media and Video", description="Videos and media stuff")
    media_video.save()

    music_audio = models.Category(title="Music and Audio", description="Using your ears")
    music_audio.save()

    news = models.Category(title="News", description="What's happening where")
    news.save()

    productivity = models.Category(title="Productivity", description="Do more in less time")
    productivity.save()

    shopping = models.Category(title="Shopping", description="For spending your money")
    shopping.save()

    sports = models.Category(title="Sports", description="Score more points than your opponent")
    sports.save()

    tools = models.Category(title="Tools", description="Tools and Utilities")
    tools.save()

    weather = models.Category(title="Weather", description="Get the temperature")
    weather.save()

    ############################################################################
    #                           Contact Types
    ############################################################################
    civillian = models.ContactType(name='Civillian')
    civillian.save()

    government = models.ContactType(name='Government')
    government.save()

    military = models.ContactType(name='Military')
    military.save()

    ############################################################################
    #                           Listing Types
    ############################################################################
    web_app = models.ListingType(title='Web Application', description='web applications')
    web_app.save()

    widget = models.ListingType(title='Widget', description='widget things')
    widget.save()

    desktop_app = models.ListingType(title='Desktop App', description='desktop app')
    desktop_app.save()

    web_services = models.ListingType(title='Web Services', description='web services')
    web_services.save()

    code_library = models.ListingType(title='Code Library', description='code library')
    code_library.save()

    ############################################################################
    #                           Image Types
    ############################################################################
    # Note: these image sizes do not represent those that should be used in
    # production
    small_icon_type = models.ImageType(name='small_icon', max_size_bytes='4096')
    small_icon_type.save()

    large_icon_type = models.ImageType(name='large_icon', max_size_bytes='8192')
    large_icon_type.save()

    banner_icon_type = models.ImageType(name='banner_icon', max_size_bytes='2097152')
    banner_icon_type.save()

    large_banner_icon_type = models.ImageType(name='large_banner_icon', max_size_bytes='2097152')
    large_banner_icon_type.save()

    small_screenshot_type = models.ImageType(name='small_screenshot', max_size_bytes='1048576')
    small_screenshot_type.save()

    large_screenshot_type = models.ImageType(name='large_screenshot', max_size_bytes='1048576')
    large_screenshot_type.save()

    intent_icon_type = models.ImageType(name='intent_icon', max_size_bytes='2097152')
    intent_icon_type.save()

    agency_icon_type = models.ImageType(name='agency_icon', max_size_bytes='2097152')
    agency_icon_type.save()

    ############################################################################
    #                           Intents
    ############################################################################
    # TODO: more realistic data
    img = Image.open(TEST_IMG_PATH + 'android.png')
    icon = models.Image.create_image(img, file_extension='png',
        security_marking='UNCLASSIFIED', image_type=intent_icon_type.name)
    i = models.Intent(action='/application/json/view',
        media_type='vnd.ozp-intent-v1+json.json',
        label='view',
        icon=icon)
    i.save()

    i = models.Intent(action='/application/json/edit',
        media_type='vnd.ozp-intent-v1+json.json',
        label='edit',
        icon=icon)
    i.save()

    ############################################################################
    #                           Organizations
    ############################################################################

    # Minitrue - Ministry of Truth
    img = Image.open(TEST_IMG_PATH + 'ministry_of_truth.jpg')
    icon = models.Image.create_image(img, file_extension='jpg',
        security_marking='UNCLASSIFIED', image_type='agency_icon')
    minitrue = models.Agency(title='Ministry of Truth', short_name='Minitrue', icon=icon)
    minitrue.save()

    # Minipax - Ministry of Peace
    img = Image.open(TEST_IMG_PATH + 'ministry_of_peace.png')
    icon = models.Image.create_image(img, file_extension='png',
        security_marking='UNCLASSIFIED', image_type='agency_icon')
    minipax = models.Agency(title='Ministry of Peace', short_name='Minipax',
        icon=icon)
    minipax.save()

    # Miniluv - Ministry of Love
    img = Image.open(TEST_IMG_PATH + 'ministry_of_love.jpeg')
    icon = models.Image.create_image(img, file_extension='jpeg',
        security_marking='UNCLASSIFIED', image_type='agency_icon')
    miniluv = models.Agency(title='Ministry of Love', short_name='Miniluv', icon=icon)
    miniluv.save()

    # Miniplen - Ministry of Plenty
    img = Image.open(TEST_IMG_PATH + 'ministry_of_plenty.png')
    icon = models.Image.create_image(img, file_extension='png',
        security_marking='UNCLASSIFIED', image_type='agency_icon')
    miniplenty = models.Agency(title='Ministry of Plenty', short_name='Miniplen', icon=icon)
    miniplenty.save()

    ############################################################################
    #                               Tags
    ############################################################################
    demo = models.Tag(name='demo')
    demo.save()

    example = models.Tag(name='example')
    example.save()

    ############################################################################
    #                               Apps Mall Stewards
    ############################################################################

    # bigbrother
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA', 'TANGO', 'GOLF', 'HOTEL'],
        'visas': ['NOVEMBER']
    })
    big_brother = models.Profile.create_user('bigbrother',
        email='bigbrother@oceania.gov',
        display_name='Big Brother',
        bio='I make everyones life better',
        access_control=access_control,
        organizations=['Ministry of Peace'],
        groups=['APPS_MALL_STEWARD'],
        dn='Big Brother bigbrother'
    )

    # bigbrother2
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA', 'TANGO', 'GOLF', 'HOTEL'],
        'visas': ['NOVEMBER']
    })
    big_brother2 = models.Profile.create_user('bigbrother2',
        email='bigbrother2@oceania.gov',
        display_name='Big Brother2',
        bio='I also make everyones life better',
        access_control=access_control,
        organizations=['Ministry of Truth'],
        groups=['APPS_MALL_STEWARD'],
        dn='Big Brother 2 bigbrother2'
    )

    # khaleesi
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA', 'TANGO', 'GOLF', 'HOTEL'],
        'visas': ['DRS']
    })
    khaleesi = models.Profile.create_user('khaleesi',
        email='khaleesi@dragonborn.gov',
        display_name='Daenerys Targaryen',
        bio='I am Queen of Meereen, Queen of the Andals(, the Rhoynar) and the First Men, Lady Regnant of the Seven Kingdoms, Khaleesi of the Great Grass Sea, Mhysa, Breaker of Chains, the Unburnt, Mother of Dragons".',
        access_control=access_control,
        organizations=['Ministry of Plenty'],
        groups=['APPS_MALL_STEWARD'],
        dn='Daenerys Targaryen khaleesi'
    )

    ############################################################################
    #                               Org Stewards
    ############################################################################
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA', 'TANGO'],
        'visas': ['NOVEMBER']
    })
    winston = models.Profile.create_user('wsmith',
        email='wsmith@oceania.gov',
        display_name='Winston Smith',
        bio='I work at the Ministry of Truth',
        access_control=access_control,
        organizations=['Ministry of Truth'],
        stewarded_organizations=['Ministry of Truth'],
        groups=['ORG_STEWARD'],
        dn='Winston Smith wsmith'
    )

    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA'],
        'visas': []
    })
    julia = models.Profile.create_user('julia',
        email='julia@oceania.gov',
        display_name='Julia Dixon',
        bio='An especially zealous propagandist',
        access_control=access_control,
        organizations=['Ministry of Truth'],
        stewarded_organizations=['Ministry of Truth', 'Ministry of Love'],
        groups=['ORG_STEWARD'],
        dn='Julia Dixon jdixon'
    )

    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA', 'TANGO', 'GOLF', 'HOTEL'],
        'visas': ['NOVEMBER']
    })
    obrien = models.Profile.create_user('obrien',
        email='obrien@oceania.gov',
        display_name='O\'brien',
        bio='I will find you, winston and julia',
        access_control=access_control,
        organizations=['Ministry of Peace'],
        stewarded_organizations=['Ministry of Peace', 'Ministry of Plenty'],
        groups=['ORG_STEWARD'],
        dn='OBrien obrien'
    )

    ############################################################################
    #                               Regular user
    ############################################################################

    # USER - Ministry of Love
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET'],
        'formal_accesses': [],
        'visas': ['NOVEMBER']
    })
    aaronson = models.Profile.create_user('aaronson',
        email='aaronson@airstripone.com',
        display_name='Aaronson',
        bio='Nothing special',
        access_control=access_control,
        organizations=['Ministry of Love'],
        groups=['USER'],
        dn='Aaronson aaronson'
    )
    pmurt = models.Profile.create_user('pmurt',
        email='pmurt@airstripone.com',
        display_name='pmurt',
        bio='Nothing special',
        access_control=access_control,
        organizations=['Ministry of Love'],
        groups=['USER'],
        dn='dlanod pmurt'
    )

    # PKI USER - Ministry of Love
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET'],
        'formal_accesses': [],
        'visas': ['STE', 'RVR', 'PKI']
    })
    hodor = models.Profile.create_user('hodor',
        email='hodor@hodor.com',
        display_name='Hodor',
        bio='Hold the door',
        access_control=access_control,
        organizations=['Ministry of Love'],
        groups=['USER'],
        dn='Hodor hodor'
    )

    # USER - Ministry of Truth
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET'],
        'formal_accesses': [],
        'visas': ['NOVEMBER']
    })
    jones = models.Profile.create_user('jones',
        email='jones@airstripone.com',
        display_name='Jones',
        bio='I am a normal person',
        access_control=access_control,
        organizations=['Ministry of Truth'],
        groups=['USER'],
        dn='Jones jones'
    )

    # PKI USER - Ministry of Truth
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET'],
        'formal_accesses': [],
        'visas': ['NOVEMBER', 'PKI']
    })
    tammy = models.Profile.create_user('tammy',
        email='tammy@airstripone.com',
        display_name='Tammy',
        bio='I am a normal person also',
        access_control=access_control,
        organizations=['Ministry of Truth'],
        groups=['USER'],
        dn='Tammy tammy'
    )

    # USER - Ministry of Plenty
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET'],
        'formal_accesses': [],
        'visas': []
    })
    rutherford = models.Profile.create_user('rutherford',
        email='rutherford@airstripone.com',
        display_name='Rutherford',
        bio='I am a normal person',
        access_control=access_control,
        organizations=['Ministry of Plenty'],
        groups=['USER'],
        dn='Rutherford rutherford'
    )

    # PKI USER - Ministry of Plenty
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET'],
        'formal_accesses': [],
        'visas': ['PKI']
    })
    noah = models.Profile.create_user('noah',
        email='noah@airstripone.com',
        display_name='Noah',
        bio='I am a cool normal person',
        access_control=access_control,
        organizations=['Ministry of Plenty'],
        groups=['USER'],
        dn='Noah noah'
    )

    # USER - Ministry of Peace
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA'],
        'visas': []
    })
    syme = models.Profile.create_user('syme',
        email='syme@airstripone.com',
        display_name='Syme',
        bio='I am too smart for my own good',
        access_control=access_control,
        organizations=['Ministry of Peace'],
        groups=['USER'],
        dn='Syme syme'
    )

    # PKI USER - Ministry of Peace
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA'],
        'visas': ['PKI']
    })
    abe = models.Profile.create_user('abe',
        email='abe@airstripone.com',
        display_name='Abe',
        bio='I am too smart for my own good also',
        access_control=access_control,
        organizations=['Ministry of Peace'],
        groups=['USER'],
        dn='Abe abe'
    )

    # USER - Ministry of Peace, Ministry of Love
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED'],
        'formal_accesses': [],
        'visas': []
    })
    tparsons = models.Profile.create_user('tparsons',
        email='tparsons@airstripone.com',
        display_name='Tom Parsons',
        bio='I am uneducated and loyal',
        access_control=access_control,
        organizations=['Ministry of Peace', 'Ministry of Love'],
        groups=['USER'],
        dn='Tparsons tparsons'
    )

    # PKI USER - Ministry of Peace, Ministry of Love
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED'],
        'formal_accesses': [],
        'visas': ['TWN', 'PKI']
    })
    jsnow = models.Profile.create_user('jsnow',
        email='jsnow@forthewatch.com',
        display_name='Jon Snow',
        bio='I know nothing.',
        access_control=access_control,
        organizations=['Ministry of Peace', 'Ministry of Love'],
        groups=['USER'],
        dn='Jonsnow jsnow'
    )

    # USER - Ministry of Peace, Ministry of Love, Ministry of Truth
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA', 'TANGO', 'GOLF', 'HOTEL'],
        'visas': ['NOVEMBER']
    })
    charrington = models.Profile.create_user('charrington',
        email='charrington@airstripone.com',
        display_name='Charrington',
        bio='A member of the Thought Police',
        access_control=access_control,
        organizations=['Ministry of Peace', 'Ministry of Love', 'Ministry of Truth'],
        groups=['USER'],
        dn='Charrington charrington'
    )

    # PKI USER - Ministry of Peace, Ministry of Love, Ministry of Truth
    access_control = json.dumps({
        'clearances': ['UNCLASSIFIED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET'],
        'formal_accesses': ['SIERRA', 'TANGO', 'GOLF', 'HOTEL'],
        'visas': ['NOVEMBER', 'PKI']
    })
    johnson = models.Profile.create_user('johnson',
        email='johnson@airstripone.com',
        display_name='Johnson',
        bio='A member of the Thought Police also',
        access_control=access_control,
        organizations=['Ministry of Peace', 'Ministry of Love', 'Ministry of Truth'],
        groups=['USER'],
        dn='Johnson johnson'
    )

    #-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    ############################################################################
    #                           System Notifications
    ############################################################################
    # create some notifications that expire next week
    next_week = datetime.datetime.now() + datetime.timedelta(days=7)
    eastern = pytz.timezone('US/Eastern')
    next_week = eastern.localize(next_week)
    n1 = models.Notification(message='System will be going down for \
        approximately 30 minutes on X/Y at 1100Z',
        expires_date=next_week, author=winston)
    n1.save()

    n2 = models.Notification(message='System will be functioning in a \
        degredaded state between 1800Z-0400Z on A/B',
        expires_date=next_week, author=julia)
    n2.save()

    # create some expired notifications
    last_week = datetime.datetime.now() - datetime.timedelta(days=7)
    last_week = eastern.localize(last_week)
    n1 = models.Notification(message='System will be going down for \
        approximately 30 minutes on C/D at 1700Z',
        expires_date=last_week, author=winston)
    n1.save()

    n2 = models.Notification(message='System will be functioning in a \
        degredaded state between 2100Z-0430Z on F/G',
        expires_date=last_week, author=julia)
    n2.save()

    #-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    ############################################################################
    #                           Contacts
    ############################################################################
    osha = models.Contact(name='Osha', organization='House Stark',
        contact_type=models.ContactType.objects.get(name='Civillian'),
        email='osha@stark.com', unsecure_phone='321-123-7894')
    osha.save()

    rob_baratheon = models.Contact(name='Robert Baratheon',
        organization='House Baratheon',
        contact_type=models.ContactType.objects.get(name='Government'),
        email='rbaratheon@baratheon.com', unsecure_phone='123-456-7890')
    rob_baratheon.save()

    brienne = models.Contact(name='Brienne Tarth', organization='House Stark',
        contact_type=models.ContactType.objects.get(name='Military'),
        email='brienne@stark.com', unsecure_phone='222-324-3846')
    brienne.save()

    #-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    #===========================================================================
    #                           Listings
    #===========================================================================

    ############################################################################
    #                           Air Mail
    ############################################################################
    # Looping for more sample results
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'AirMail16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'AirMail32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'AirMail.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'AirMailFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='Air Mail{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Sends mail via air',
            launch_url='{0!s}/demo_apps/centerSampleListings/airMail/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.air_mail{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Sends airmail',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            security_marking=unclass
        )
        listing.save()
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Contacts
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing.contacts.add(osha)
        listing.contacts.add(brienne)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Owners
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing.owners.add(winston)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Categories
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing.categories.add(communication)
        listing.categories.add(productivity)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Tags
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        current_tag = models.Tag(name='tag_{0}'.format(i))
        current_tag.save()

        listing.tags.add(demo)
        listing.tags.add(example)
        listing.tags.add(current_tag)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Screenshots
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'screenshot_small.png')
        small_img = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_screenshot_type.name)
        img = Image.open(TEST_IMG_PATH + 'screenshot_large.png')
        large_img = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_screenshot_type.name)
        screenshot = models.Screenshot(small_image=small_img,
            large_image=large_img,
            listing=listing)
        screenshot.save()
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Notifications
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        notification1 = models.Notification(message='Air Mail update next week', expires_date=next_week, listing=listing, author=winston)
        notification1.save()

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Document URLs
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        wiki = models.DocUrl(name='wiki', url='http://www.google.com/wiki',
            listing=listing)
        wiki.save()
        guide = models.DocUrl(name='guide', url='http://www.google.com/guide',
            listing=listing)
        guide.save()

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Reviews
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        create_listing_review_batch(listing,
            [charrington, 5, "This app is great - well designed and easy to use"],
            [tparsons, 3, "Air mail is ok - does what it says and no more"],
            [syme, 1, "Air mail crashes all the time - it doesn't even support IE 6!"]
        )

    ############################################################################
    #                           Bread Basket
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'BreadBasket16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'BreadBasket32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'BreadBasket.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'BreadBasketFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='Bread Basket{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Carries delicious bread',
            launch_url='{0!s}/demo_apps/centerSampleListings/breadBasket/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.bread_basket{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Carries bread',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=True,
            security_marking=unclass
        )
        listing.save()

        listing.contacts.add(osha)
        listing.owners.add(julia)
        listing.categories.add(health_fitness)
        listing.categories.add(shopping)

        listing.tags.add(demo)
        listing.tags.add(example)

        listing_model_access.create_listing(julia, listing)
        listing_model_access.submit_listing(julia, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Reviews
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        create_listing_review_batch(listing,
            [jones, 2, "This bread is stale!"],
            [julia, 5, "Yum!"]
        )

    ############################################################################
    #                           Chart Course
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        # ChartCourse16
        img = Image.open(TEST_IMG_PATH + 'ChartCourse16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)

        # ChartCourse32
        img = Image.open(TEST_IMG_PATH + 'ChartCourse32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)

        # ChartCourse
        img = Image.open(TEST_IMG_PATH + 'ChartCourse.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)

        # ChartCourseFeatured
        img = Image.open(TEST_IMG_PATH + 'ChartCourseFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='Chart Course{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Chart your course',
            launch_url='{0!s}/demo_apps/centerSampleListings/chartCourse/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.chartcourse{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Chart your course',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Reviews
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        create_listing_review_batch(listing,
            [winston, 2, "This Chart is bad"],
            [big_brother, 5, "Good Chart!"]
        )

    ############################################################################
    #                           Chatter Box
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'ChatterBox16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'ChatterBox32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'ChatterBox.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'ChatterBoxFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='Chatter Box{0!s}'.format(postfix_space),
            agency=miniluv,
            listing_type=web_app,
            description='Chat with people',
            launch_url='{0!s}/demo_apps/centerSampleListings/chatterBox/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.chatterbox{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Chat in a box',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(julia)
        listing.categories.add(communication)
        listing.tags.add(demo)

        listing_model_access.create_listing(julia, listing)
        listing_model_access.submit_listing(julia, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

    ############################################################################
    #                           Clipboard
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'Clipboard16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'Clipboard32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'Clipboard.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'ClipboardFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='Clipboard{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Clip stuff on a board',
            launch_url='{0!s}/demo_apps/centerSampleListings/clipboard/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.clipboard{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Its a clipboard',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

    ############################################################################
    #                           FrameIt
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'FrameIt16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'FrameIt32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'FrameIt.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'FrameItFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='FrameIt{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Show things in an iframe',
            launch_url='{0!s}/demo_apps/frameit/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.frameit{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Its an iframe',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

    ############################################################################
    #                           Hatch Latch
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'HatchLatch16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'HatchLatch32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'HatchLatch.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'HatchLatchFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='Hatch Latch{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Hatch latches',
            launch_url='{0!s}/demo_apps/centerSampleListings/hatchLatch/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.hatchlatch{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Its a hatch latch',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.categories.add(health_fitness)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

        ############################################################################
        #                           Jot Spot
        ############################################################################
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'JotSpot16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'JotSpot32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'JotSpot.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'JotSpotFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        listing = models.Listing(
            title='JotSpot{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Jot things down',
            launch_url='{0!s}/demo_apps/centerSampleListings/jotSpot/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.jotspot{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Jot stuff down',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

        listing_model_access.create_listing_review(charrington.user.username, listing, 4, text="I really like it")

    ############################################################################
    #                           Location Lister
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'LocationLister16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationLister32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationLister.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationListerFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        listing = models.Listing(
            title='LocationLister{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='List locations',
            launch_url='{0!s}/demo_apps/locationLister/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.locationlister{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='List locations',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

        listing_model_access.create_listing_review(charrington.user.username, listing, 4, text="I really like it")

    ############################################################################
    #                           Location Viewer
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'LocationViewer16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationViewer32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationViewer.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationViewerFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='LocationViewer{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='View locations',
            launch_url='{0!s}/demo_apps/locationViewer/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.locationviewer{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='View locations',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

    ############################################################################
    #                           Location Analyzer
    ############################################################################
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'LocationAnalyzer16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationAnalyzer32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationAnalyzer.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'LocationAnalyzerFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='LocationAnalyzer{0!s}'.format(postfix_space),
            agency=minitrue,
            listing_type=web_app,
            description='Analyze locations',
            launch_url='{0!s}/demo_apps/locationAnalyzer/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.locationanalyzer{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new='Nothing really new here',
            description_short='Analyze locations',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(winston)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

    ############################################################################
    #                           Skybox
    ############################################################################
    #   Looping for more sample listings
    for i in range(0, 10):
        postfix_space = "" if (i == 0) else " " + str(i)
        postfix_dot = "" if (i == 0) else "." + str(i)
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Icons
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        img = Image.open(TEST_IMG_PATH + 'Skybox16.png')
        small_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=small_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'Skybox32.png')
        large_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'Skybox.png')
        banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=banner_icon_type.name)
        img = Image.open(TEST_IMG_PATH + 'SkyboxFeatured.png')
        large_banner_icon = models.Image.create_image(img, file_extension='png',
            security_marking=unclass, image_type=large_banner_icon_type.name)

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #                           Listing
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        listing = models.Listing(
            title='Skybox{0!s}'.format(postfix_space),
            agency=miniluv,
            listing_type=web_app,
            description='Sky Overlord',
            launch_url='{0!s}/demo_apps/Skybox/index.html'.format(DEMO_APP_ROOT),
            version_name='1.0.0',
            unique_name='ozp.test.skybox{0!s}'.format(postfix_dot),
            small_icon=small_icon,
            large_icon=large_icon,
            banner_icon=banner_icon,
            large_banner_icon=large_banner_icon,
            what_is_new="It's a box in the sky",
            description_short='Sky Overlord',
            requirements='None',
            is_enabled=True,
            is_featured=True,
            iframe_compatible=False,
            is_private=False,
            security_marking=unclass
        )
        listing.save()
        listing.contacts.add(rob_baratheon)
        listing.owners.add(pmurt)
        listing.categories.add(tools)
        listing.categories.add(education)
        listing.tags.add(demo)

        listing_model_access.create_listing(winston, listing)
        listing_model_access.submit_listing(winston, listing)
        listing_model_access.approve_listing_by_org_steward(winston, listing)
        listing_model_access.approve_listing(winston, listing)

    ############################################################################
    #                           Library
    ############################################################################
    # bookmark listings
    # [[entry.owner.user.username , entry.listing.unique_name, entry.folder] for entry in ApplicationLibraryEntry.objects.all()]
    create_library_entries(
        # wsmith
        ['wsmith', 'ozp.test.bread_basket', None],
        ['wsmith', 'ozp.test.air_mail', None],
        ['wsmith', 'ozp.test.skybox.1', None],
        ['wsmith', 'ozp.test.skybox.2', None],
        ['wsmith', 'ozp.test.skybox.3', None],

        # Hodor
        ['hodor', 'ozp.test.jotspot', None],
        ['hodor', 'ozp.test.locationlister', None],
        ['hodor', 'ozp.test.chartcourse', None],
        ['hodor', 'ozp.test.air_mail', None],
        ['hodor', 'ozp.test.skybox', None],
        ['hodor', 'ozp.test.skybox.1', None],

        ['bigbrother', 'ozp.test.bread_basket', None]
    )

    ############################################################################
    #                           Recommendations
    ############################################################################
    sample_data_recommender = RecommenderDirectory()
    sample_data_recommender.recommend('sample_data,custom')


if __name__ == "__main__":
    run()
