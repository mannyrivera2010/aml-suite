"""
Observers
"""
import logging
from amlcenter.pubsub import Observer

# import amlcenter.api.notification.model_access as notification_model_access

logger = logging.getLogger('aml-center.' + str(__name__))


class BookmarkObserver(Observer):

    def events_to_listen(self):
        return [
            'remove_bookmark_folder',
            'update_bookmark_entry'
        ]

    def execute(self, event_type, **kwargs):
        logger.debug('BookmarkObserver message: event_type:{}, kwards:{}'.format(event_type, kwargs))

    def remove_bookmark_folder(self, bookmark_entry, folder_queries):
        """
        if bookmark_entry is a shared folder then notify all the owners and viewers that folder was deleted

        Args:
            bookmark_entry:
                BookmarkEntry that will be delete
            folder_queries:
                All of bookmark_folder_entries and listing queries
        """
        print('remove_bookmark_folder')

    def update_bookmark_entry(self, bookmark_entry_instance, bookmark_parent_object, folder_title_changed, bookmark_entry_moved):
        """
        Event for when a BookmarkEntry changes
            * title if BookmarkEntry.type is FOLDER_TYPE
            * if BookmarkEntry moves to a different folder
        """
        print('update_bookmark_entry')
