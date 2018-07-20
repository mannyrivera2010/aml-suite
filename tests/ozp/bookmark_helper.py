import re


def shorthand_permissions(data):
    """
    Convert Bookmark Permission endpoint data to simple strings

    [{id": 6,
     "profile": { ...,"user": { "username": "bigbrother" },}, ...,
     "user_type": "OWNER" }]
    TO
    ['bigbrother(OWNER)']
    """
    output = []
    for record in data:
        username = record.get('profile', {}).get('user', {}).get('username')
        output.append('{}({})'.format(username, record.get('user_type')))
    return output


def _parse_legacy_bookmark(data):
    """
    parse library endpoint bookmarks

    Args:
        data:
            {
                "listing": {
                    "id": 169,
                    "title": "Tornado",...
                },
                "folder": "Weather",
                "id": 30,
                "position": 0
            }
    """
    root_folder = BookmarkFolder(None)
    root_folder.raw_data = data

    folder_mapping = {}

    for record in data:
        bookmark_folder = root_folder

        folder = record.get('folder')
        bookmark_id = record.get('id')
        listing_id = record.get('listing', {}).get('id')
        listing_title = record.get('listing', {}).get('title')

        if folder:
            if folder in folder_mapping:
                bookmark_folder = folder_mapping[folder]
            else:
                bookmark_folder = BookmarkFolder(folder)
                root_folder.add_bookmark_object(bookmark_folder)
                folder_mapping[folder] = bookmark_folder

        if listing_title:
            bookmark_listing = BookmarkListing(listing_title, id=bookmark_id, listing_id=listing_id)
            bookmark_folder.add_bookmark_object(bookmark_listing)
            bookmark_listing.set_parent(bookmark_folder)

    return root_folder


def _parse_bookmark_line(current_record):
    current_record_re = re.search('(^[ ]*)\(([\w]+)\)(.*$)', current_record)
    record_level = len(current_record_re.group(1))
    record_type = current_record_re.group(2)
    record_title = str(current_record_re.group(3)).strip()

    return {
        'record_level': record_level,
        'record_type': record_type,
        'record_title': record_title
    }


def _bookmark_node_parse_shorthand_commands(data):
    """
    Convert Shorthand Data into Commands

    Actions: (STACK ACTION)(Level Diff)(ACTION)(CLASS_TYPE)(STACK ACTION)
        CF_PU: (PEEK)(0)(CREATE)(FOLDER)(PUSH)
            0-F   0-None
            1-F   0-F
        CF_PO: (POP PEEK)(1)(CREATE)(FOLDER)(PUSH)
            0-F   1-L
            0-F   0-F
        CL_PE: (PEEK)(0)(CREATE)(LISTING)
            1-F   0-L    0-NONE
            2-L   0-L    0-L
        CL_PO: (POP PEEK)(1)(CREATE)(LISTING)
            1-L   1-F
            0-L   0-L

        Args:
            data:
                ['(F) heros',
                 ' (L) Iron Man',
                 ' (L) Jean Grey',
                 ' (L) Mallrats',
                 '(F) old',
                 ' (L) Air Mail',
                 ' (L) Bread Basket',
                 '(F) planets',
                 ' (L) Azeroth',
                 ' (L) Saturn',
                 '(L) Baltimore Ravens',
                 '(L) Diamond',
                 '(L) Grandfather clock']

            0 - F -  heros
            1 - L -  Iron Man
            1 - L -  Jean Grey
            1 - L -  Mallrats
            0 - F -  old
            1 - L -  Air Mail
            1 - L -  Bread Basket
            0 - F -  planets
            1 - L -  Azeroth
            1 - L -  Saturn
            0 - L -  Baltimore Ravens
            0 - L -  Diamond
            0 - L -  Grandfather clock

    Returns:
        [{'action': 'CREATE_FOLDER',
          'level_diff': 0,
          'record_title': 'bigbrother',
          'stack_action': 'PEEK_PUSH'},...]
    """
    commands = []

    previous_level = 0
    previous_is_folder = False

    for current_record in data:
        parsed_dict = _parse_bookmark_line(current_record)
        record_level = parsed_dict['record_level']
        record_type = parsed_dict['record_type']
        record_title = parsed_dict['record_title']

        record_type_mapping = {
            'F': {
                'class_type': 'FOLDER',
                'record_is_folder': True
            },
            'SF': {
                'class_type': 'SHARED_FOLDER',
                'record_is_folder': True
            },
            'L': {
                'class_type': 'LISTING',
                'record_is_folder': False
            },
            'SL': {
                'class_type': 'LISTING',
                'record_is_folder': False
            }
        }

        current_record_mapping = record_type_mapping.get(record_type)

        if not current_record_mapping:
            continue

        class_type = current_record_mapping['class_type']
        record_is_folder = current_record_mapping['record_is_folder']

        level_action = 'LEVEL_ERROR'
        level_diff = 0

        if record_level >= previous_level + 1:
            level_action = 'LEVEL_UP'
            level_diff = record_level - previous_level
        elif record_level <= previous_level - 1:
            level_action = 'LEVEL_DOWN'
            level_diff = previous_level - record_level
        elif record_level == previous_level:
            level_action = 'LEVEL_SAME'

        stack_action = None
        action = 'CREATE'

        if record_is_folder:
            post_stack_action = 'PUSH'
            stack_action = ''

            if level_action == 'LEVEL_SAME' and previous_is_folder is True:
                stack_action = 'POP'
                level_diff = 1 if level_diff == 0 else level_diff
                # level_diff = level_diff + 1
            elif level_action == 'LEVEL_SAME' and previous_is_folder is False:
                stack_action = ''
            elif level_action == 'LEVEL_DOWN' and previous_is_folder is True:
                stack_action = 'POP'
            elif level_action == 'LEVEL_DOWN' and previous_is_folder is False:
                stack_action = 'POP'

                # level_diff = 1 if level_diff == 0 else level_diff
                # level_diff = level_diff + 1
        else:
            post_stack_action = ''
            stack_action = ''

            if level_action == 'LEVEL_SAME' and previous_is_folder is True:
                stack_action = 'POP'
                level_diff = 1 if level_diff == 0 else level_diff
            elif level_action == 'LEVEL_DOWN':
                stack_action = 'POP'

        # print('level_action: {} - action: {}, level_diff:{}'.format(level_action, action, level_diff, record_level))
        commands.append({
            'action': action,
            'class_type': class_type,
            'record_title': record_title,
            'stack_action': stack_action,
            'post_stack_action': post_stack_action,
            'level_diff': level_diff,
            '_parsed_dict': parsed_dict})

        # '{}-{}-{}-{}'.format(action, record_title, stack_action, level_diff))
        # print("{}({}) {}".format(action, level_diff, record_title))
        # set previous level
        previous_level = record_level
        previous_is_folder = record_is_folder

    return commands


def _bookmark_node_parse_shorthand(data):
    """
    Convert Shorthand Data into BookmarkFolder

    Args:
        data:
            ['(F) heros',
             ' (L) Iron Man',
             ' (L) Jean Grey',
             ' (L) Mallrats',
             '(F) old',
             ' (L) Air Mail',
             ' (L) Bread Basket',
             '(F) planets',
             ' (L) Azeroth',
             ' (L) Saturn',
             '(L) Baltimore Ravens',
             '(L) Diamond',
             '(L) Grandfather clock']
            ...

    Return:
        BookmarkFolder
    """
    root_folder = BookmarkFolder(None)
    root_folder.raw_data = data

    folder_stack = [root_folder]
    commands = _bookmark_node_parse_shorthand_commands(data)
    # import pprint; pprint.pprint(commands)
    for command_dict in commands:
        action_raw = command_dict['action']
        class_type = command_dict['class_type']
        record_title = command_dict['record_title']
        stack_action = command_dict['stack_action']
        post_stack_action = command_dict['post_stack_action']
        level_diff = int(command_dict['level_diff'])

        action = '_'.join([x for x in [action_raw, class_type] if (x)])

        print('-----------')
        import pprint
        pprint.pprint(command_dict)

        if stack_action in ['POP']:
            for i in range(0, level_diff):
                if len(folder_stack) > 1:
                    folder_stack.pop()

        current_root_folder = folder_stack[-1]

        folder_type = False

        if action == 'CREATE_FOLDER':
            next_root_folder = BookmarkFolder(record_title)
            current_root_folder.add_bookmark_object(next_root_folder)
            folder_type = True
        elif action == 'CREATE_SHARED_FOLDER':
            next_root_folder = BookmarkSharedFolder(record_title)
            current_root_folder.add_bookmark_object(next_root_folder)
            folder_type = True
        elif action == 'CREATE_LISTING':
            current_root_folder.add_bookmark_object(BookmarkListing(record_title))

        if post_stack_action in ['PUSH'] and folder_type:
            folder_stack.append(next_root_folder)

    return root_folder


def _bookmark_node_parse(bookmark_folder, data):
    """
    Parse Endpoint data helper
    """
    folders = data.get('folders')
    listings = data.get('listings')

    if folders is not None and listings is not None:
        for folder in folders:
            bookmark_id = folder.get('id')
            folder_title = folder.get('title')
            folder_is_shared = folder.get('is_shared', False)
            folder_class = BookmarkFolder

            if folder_is_shared:
                folder_class = BookmarkSharedFolder

            if folder_title:
                bookmark_folder_nested = folder_class(folder_title, id=bookmark_id)
                bookmark_folder.add_bookmark_object(bookmark_folder_nested)
                bookmark_folder_nested.set_parent(bookmark_folder)
                _bookmark_node_parse(bookmark_folder_nested, folder.get('children', {}))

        for listing in listings:
            bookmark_id = listing.get('id')
            listing_title = listing.get('listing', {}).get('title')
            listing_id = listing.get('listing', {}).get('id')
            if listing_title:
                bookmark_listing = BookmarkListing(listing_title, id=bookmark_id, listing_id=listing_id)
                bookmark_folder.add_bookmark_object(bookmark_listing)
                bookmark_listing.set_parent(bookmark_folder)


def bookmark_node_string_helper(bookmark_node, level=0, order=False, show_root=True):
    if isinstance(bookmark_node, BookmarkFolder):
        bookmark_node_is_root = bookmark_node.title is None

        prefix = 'F'
        if isinstance(bookmark_node, BookmarkSharedFolder):
            prefix = 'SF'

        bookmarks = []

        if show_root is False:
            level = level - 1

        if not bookmark_node_is_root and show_root:
            bookmarks.append('{}({}) {}'.format(' ' * level, prefix, bookmark_node.title))

        # This is needed for order
        folders = []
        listings = []

        for bookmark in bookmark_node.bookmark_objects:
            if bookmark.is_hidden:
                continue

            if isinstance(bookmark, BookmarkFolder):
                folders.append(bookmark)
            elif isinstance(bookmark, BookmarkListing):
                listings.append(bookmark)

        if order is True:
            folders.sort(key=lambda x: x.title, reverse=False)
            listings.sort(key=lambda x: x.title, reverse=False)

        for bookmark in folders:
            if not bookmark_node_is_root:
                bookmarks.extend(bookmark_node_string_helper(bookmark, level + 1, order=order, show_root=True))
            else:
                bookmarks.extend(bookmark_node_string_helper(bookmark, level, order=order, show_root=True))

        for bookmark in listings:
            if not bookmark_node_is_root:
                bookmarks.extend(bookmark_node_string_helper(bookmark, level + 1, order=order, show_root=True))
            else:
                bookmarks.extend(bookmark_node_string_helper(bookmark, level, order=order, show_root=True))

        return bookmarks
    elif isinstance(bookmark_node, BookmarkListing):
        return ['{}(L) {}'.format(' ' * level, bookmark_node.title)]


def _build_filesystem_structure(bookmark_node, level=None):
    """
    Args:
        bookmark_node:
        level:
    Return:
        List of tuples
            [('/', F(None, None, None, 8)),
             ('/Weather/', F(None, Weather, None, 4)),
             ('/Weather/Tornado', L(30, Tornado, Weather)),...]
    """
    if isinstance(bookmark_node, BookmarkNode):
        bookmark_title = bookmark_node.title
        bookmark_node_is_root = bookmark_title is None
        bookmark_is_hidden = bookmark_node.hidden()
        level = list(level) if level else []
    else:
        return []

    if isinstance(bookmark_node, BookmarkFolder):
        bookmarks = []

        if not bookmark_node_is_root:
            level.append(bookmark_title)

        if bookmark_node_is_root:
            title = '/'
        else:
            title = '/{}/'.format('/'.join(level))
        bookmarks.append((title, bookmark_node))

        # This is needed for order
        for bookmark in bookmark_node.bookmark_objects:
            if bookmark.is_hidden:
                continue
            current_result = _build_filesystem_structure(bookmark_node=bookmark, level=level)
            bookmarks = bookmarks + (current_result)

        return bookmarks
    elif isinstance(bookmark_node, BookmarkListing):
        level.append(bookmark_title)
        title = '/{}'.format('/'.join(level))
        return [(title, bookmark_node)]


class BookmarkNode(object):

    def __init__(self, id=None, title=None, type=None, is_shared=None, listing_id=None):
        self.id = id
        self.title = title
        self.type = type
        self.is_shared = is_shared
        self.listing_id = listing_id
        self.parent = None
        self.bookmark_objects = []
        self.level = 0
        self.raw_data = None
        self.is_hidden = False

    def set_parent(self, bookmark_node):
        self.parent = bookmark_node

    def clone(self, show_root=True):
        # TODO: True Clone of objects.  should include id, listing_id
        shorten_data = self.shorten_data(show_root=show_root)
        return _bookmark_node_parse_shorthand(shorten_data)

    def __str__(self):
        return '\n'.join(bookmark_node_string_helper(self))

    def shorten_data(self, include_root=True, order=False, show_root=True):
        return bookmark_node_string_helper(self, order=order, show_root=show_root)

    def hidden(self, is_hidden=False):
        self.is_hidden = is_hidden

    def delete(self):
        if self.parent:
            id_to_delete = self.parent.bookmark_objects.index(self)
            del self.parent.bookmark_objects[id_to_delete]
            self.parent = None
            return True
        return False


class BookmarkFolder(BookmarkNode):
    prefix = 'F'

    def __init__(self, title, id=None, is_shared=False):
        super().__init__(id, title, 'FOLDER', is_shared)

    def add_folder_bookmark(self, folder_title, bookmark_id=None, prepend=False):
        bookmark_listing = BookmarkFolder(folder_title, id=bookmark_id)
        self.add_bookmark_object(bookmark_listing, prepend=prepend)
        return bookmark_listing

    def add_listing_bookmark(self, listing_title, bookmark_id=None, prepend=False):
        bookmark_listing = BookmarkListing(listing_title, id=bookmark_id)
        self.add_bookmark_object(bookmark_listing, prepend=prepend)
        return bookmark_listing

    def add_bookmark_object(self, bookmark_object, prepend=False):
        bookmarks = []
        if bookmark_object.title is None:
            bookmarks = bookmark_object.bookmark_objects
        else:
            bookmarks = [bookmark_object]

        for current_bookmark_object in bookmarks:
            if prepend:
                self.bookmark_objects.insert(0, current_bookmark_object)
            else:
                self.bookmark_objects.append(current_bookmark_object)
            current_bookmark_object.parent = self
        return True

    def first_shared_folder(self, current_level=None):
        current_level = current_level if current_level else self

        for bookmark in current_level.bookmark_objects:
            if isinstance(bookmark, BookmarkSharedFolder):
                return bookmark

            if isinstance(bookmark, BookmarkFolder):
                return self.first_shared_folder(bookmark)

        return None

    def first_listing_bookmark(self, current_level=None):
        current_level = current_level if current_level else self

        for bookmark in current_level.bookmark_objects:
            if isinstance(bookmark, BookmarkFolder):
                return self.first_listing_bookmark(bookmark)

            if isinstance(bookmark, BookmarkListing):
                return bookmark

        return None

    def search(self, name, directory_tuples=None):
        """
        Search function
        """
        directory_tuples = directory_tuples if directory_tuples else _build_filesystem_structure(self)
        directory = dict(directory_tuples)
        return directory.get(name)

    def search_delete(self, name, directory_tuples=None):
        """
        Search function
        """
        directory_tuples = directory_tuples if directory_tuples else _build_filesystem_structure(self)
        directory = dict(directory_tuples)
        bookmark_object = directory.get(name)
        if bookmark_object is not None:
            return bookmark_object.delete()
        return False

    def move(self, src_name, dest_name):
        directory_tuples = _build_filesystem_structure(self)

        src_bookmark = self.search(src_name, directory_tuples)
        dest_bookmark = self.search(dest_name, directory_tuples)

        if src_bookmark is None or dest_bookmark is None:
            return False

        if src_bookmark == dest_bookmark:
            return False

        if isinstance(dest_bookmark, BookmarkListing):
            return False

        src_bookmark.delete()
        dest_bookmark.add_bookmark_object(src_bookmark)

        return True

    def copy(self, src_name, dest_name):
        directory_tuples = _build_filesystem_structure(self)

        src_bookmark = self.search(src_name, directory_tuples)
        dest_bookmark = self.search(dest_name, directory_tuples)

        if src_bookmark is None or dest_bookmark is None:
            return False

        if src_bookmark == dest_bookmark:
            return False

        if isinstance(dest_bookmark, BookmarkListing):
            return False

        # src_bookmark.delete()
        src_bookmark_clone = src_bookmark.clone()
        dest_bookmark.add_bookmark_object(src_bookmark_clone)
        return True

    @staticmethod
    def parse_endpoint(data):
        """
        Convert Endpoint Data into BookmarkFolder

        Args:
            data:
                {
                "folders": [{"id": 1, "type": "FOLDER", "title": "Instruments", "is_shared": false,
                    "children": { "folders":[{...}], "listings":[{...}] },
                "listings": [{"id": 2, "type": "LISTING", "listing": {"id":3, "title":"title"} }]
        Return:
            BookmarkFolder
        """
        root_folder = BookmarkFolder(None)
        _bookmark_node_parse(root_folder, data)
        return root_folder

    @staticmethod
    def parse_shorthand_list(data):
        return _bookmark_node_parse_shorthand(data)

    @staticmethod
    def parse_legacy_bookmark(data):
        return _parse_legacy_bookmark(data)

    def __repr__(self):
        bookmark_objects = self.bookmark_objects
        id = self.id
        title = self.title

        return '{}({}, {}, {}, {})'.format(self.prefix, id, title, self.parent.title if self.parent else 'None', len(bookmark_objects))


class BookmarkSharedFolder(BookmarkFolder):
    prefix = 'SF'

    def __init__(self, title, id=None):
        super().__init__(title, id=id, is_shared=True)


class BookmarkListing(BookmarkNode):

    def __init__(self, title, id=None, listing_id=None):
        super().__init__(id, title, 'LISTING', False, listing_id=listing_id)

    def __repr__(self):
        if self.is_shared:
            prefix = 'SL'
        else:
            prefix = 'L'

        return '{}({}, {}, {})'.format(prefix, self.id, self.title, self.parent.title if self.parent else 'None')

    @staticmethod
    def parse_endpoint(data):
        """
        Convert Endpoint Data into BookmarkFolder

        Args:
            data:
                {"id": 2, "type": "LISTING",
                    "listing": {"id":3, "title":"title"} }
        Return:
            BookmarkFolder
        """
        bookmark_id = data.get('id')
        listing_title = data.get('listing', {}).get('title')
        listing_id = data.get('listing', {}).get('id')
        if listing_title:
            bookmark_listing = BookmarkListing(listing_title, id=bookmark_id, listing_id=listing_id)
            bookmark_listing.raw_data = data
            return bookmark_listing
        return None
