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


def _bookmark_node_parse_shorthand(data):
    """
    Convert Shorthand Data into BookmarkFolder

    Actions: (BOOKMARK CLASS _ FOLDER STACK ACTION)
        CF_PU: CREATE_FOLDER_PUSH_PEEK
            0-F   0-None
            1-F   0-F
        CF_PO: CREATE_FOLDER_POP_PUSH_PEEK
            0-F   1-L
            0-F   0-F
        CL_PE: CREATE_LISTING_PEEK
            1-F   0-L    0-NONE
            2-L   0-L    0-L
        CL_PO: CREATE_LISTING_POP_PEEK
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

            CREATE_FOLDER_PUSH_PEEK (heros)
            CREATE_LISTING_PEEK (Iron Man)
            CREATE_LISTING_PEEK (Jean Grey)
            CREATE_LISTING_PEEK (Mallrats)
            CREATE_FOLDER_POP_PUSH_PEEK (old)
            ...

    Return:
        BookmarkFolder
    """
    root_folder = BookmarkFolder(None)
    root_folder.raw_data = data

    folder_stack = [root_folder]

    previous_level = 0
    previous_is_folder = False

    for current_record in data:
        current_record_re = re.search('(^[ ]*)\(([\w]+)\)(.*$)', current_record)

        record_level = len(current_record_re.group(1))
        record_type = current_record_re.group(2)
        record_title = str(current_record_re.group(3)).strip()
        record_is_folder = False

        if record_type == 'F' or record_type == 'SF':
            record_is_folder = True

        # print('-'*10)
        # print('previous_level: {} - previous_is_folder: {} - record_level: {} - record_type: {} - record_title: {}'.format(previous_level, previous_is_folder, record_level, record_type, record_title))

        bookmark_class = None

        if record_type == 'F':
            bookmark_class = BookmarkFolder
        elif record_type == 'SF':
            bookmark_class = BookmarkSharedFolder
        elif record_type == 'L' or record_type == 'SL':
            bookmark_class = BookmarkListing

        if not bookmark_class:
            previous_level = record_level
            previous_is_folder = record_is_folder
            continue

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

        action = None

        if record_is_folder:
            if level_action == 'LEVEL_UP' and previous_is_folder is True:
                action = 'CREATE_FOLDER_PUSH_PEEK'
            elif level_action == 'LEVEL_SAME' and previous_is_folder is True:
                action = 'CREATE_FOLDER_POP_PUSH_PEEK'
            elif level_action == 'LEVEL_SAME' and previous_is_folder is False:
                action = 'CREATE_FOLDER_PUSH_PEEK'
            elif level_action == 'LEVEL_DOWN':
                action = 'CREATE_FOLDER_POP_PUSH_PEEK'
        else:
            if level_action == 'LEVEL_UP' and previous_is_folder is True:
                action = 'CREATE_LISTING_PEEK'
            elif level_action == 'LEVEL_SAME':
                action = 'CREATE_LISTING_PEEK'
            elif level_action == 'LEVEL_DOWN':
                action = 'CREATE_LISTING_POP_PEEK'

        # print('level_action: {} - action: {}, level_diff:{}'.format(level_action, action, level_diff, record_level))

        if not action:
            previous_level = record_level
            previous_is_folder = record_is_folder
            continue

        if action == 'CREATE_FOLDER_PUSH_PEEK':
            current_root_folder = folder_stack[-1]
            next_root_folder = bookmark_class(record_title)
            current_root_folder.add_bookmark_object(next_root_folder)
            folder_stack.append(next_root_folder)

        elif action == 'CREATE_FOLDER_POP_PUSH_PEEK':
            level_diff = 1 if level_diff == 0 else level_diff
            for i in range(0, level_diff):
                if len(folder_stack) > 1:
                    folder_stack.pop()

            current_root_folder = folder_stack[-1]
            next_root_folder = bookmark_class(record_title)
            current_root_folder.add_bookmark_object(next_root_folder)
            folder_stack.append(next_root_folder)

        elif action == 'CREATE_LISTING_PEEK':
            current_root_folder = folder_stack[-1]
            current_root_folder.add_bookmark_object(bookmark_class(record_title))

        elif action == 'CREATE_LISTING_POP_PEEK':
            for i in range(0, level_diff):
                if len(folder_stack) > 1:
                    folder_stack.pop()
            current_root_folder = folder_stack[-1]
            current_root_folder.add_bookmark_object(bookmark_class(record_title))

        # print("{}({}) {}".format(action, level_diff, record_title))
        # set previous level
        previous_level = record_level
        previous_is_folder = record_is_folder

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
            if listing_title:
                bookmark_listing = BookmarkListing(listing_title, id=bookmark_id)
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

    def clone(self):
        # TODO: True Clone of objects.  should include id, listing_id
        shorten_data = bookmark_node_string_helper(self)
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
        if prepend:
            self.bookmark_objects.insert(0, bookmark_object)
        else:
            self.bookmark_objects.append(bookmark_object)
        bookmark_object.parent = self
        return True

    def first_shared_folder(self):
        for bookmark in self.bookmark_objects:
            if isinstance(bookmark, BookmarkSharedFolder):
                return bookmark
        return None

    def first_listing_bookmark(self, current_level=None):
        current_level = current_level if current_level else self

        for bookmark in current_level.bookmark_objects:
            if isinstance(bookmark, BookmarkFolder):
                return self.first_listing_bookmark(bookmark)

            if isinstance(bookmark, BookmarkListing):
                return bookmark

        return None

    def _build_filesystem_structure(self, bookmark_node=None, level=None):
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
        bookmark_node = bookmark_node if bookmark_node else self
        bookmark_title = bookmark_node.title
        bookmark_node_is_root = bookmark_title is None
        bookmark_is_hidden = bookmark_node.hidden

        if isinstance(bookmark_node, BookmarkFolder):
            bookmarks = []

            if not bookmark_node_is_root:
                title = None
                if level:
                    title = '/{}/{}/'.format(level, bookmark_node.title)
                else:
                    title = '/{}/'.format(bookmark_node.title)

                bookmarks.append((title, bookmark_node))
            else:
                bookmarks.append(('/', bookmark_node))

            for bookmark in bookmark_node.bookmark_objects:
                if bookmark.is_hidden:
                    continue

                current_result = self._build_filesystem_structure(bookmark_node=bookmark, level=bookmark_title)

                if isinstance(current_result, tuple):
                    bookmarks.append(current_result)
                elif isinstance(current_result, list):
                    bookmarks = bookmarks + (current_result)
            return bookmarks
        elif isinstance(bookmark_node, BookmarkListing):
            title = None
            if level:
                title = '/{}/{}'.format(level, bookmark_node.title)
            else:
                title = '/{}'.format(bookmark_node.title)
            return (title, bookmark_node)

    def search(self, name, directory_tuples=None):
        """
        Search function
        """
        directory_tuples = directory_tuples if directory_tuples else self._build_filesystem_structure()
        directory = dict(directory_tuples)
        return directory.get(name)

    def search_delete(self, name, directory_tuples=None):
        """
        Search function
        """
        directory_tuples = directory_tuples if directory_tuples else self._build_filesystem_structure()
        directory = dict(directory_tuples)
        bookmark_object = directory.get(name)
        if bookmark_object is not None:
            return bookmark_object.delete()
        return False

    def move(self, src_name, dest_name):
        directory_tuples = self._build_filesystem_structure()

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
        directory_tuples = self._build_filesystem_structure()

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
        for current_bookmark_object in src_bookmark_clone.bookmark_objects:
            dest_bookmark.add_bookmark_object(current_bookmark_object)
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
        prefix = ''

        if self.is_shared:
            prefix = 'SF'
        else:
            prefix = 'F'

        return '{}({}, {}, {}, {})'.format(prefix, id, title, self.parent.title if self.parent else 'None', len(bookmark_objects))


class BookmarkSharedFolder(BookmarkFolder):
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
