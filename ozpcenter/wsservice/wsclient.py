"""
Client for AML Web Socket Service
http://docs.python-requests.org/en/master/

Usage:
    from ozpcenter.wsservice.wsclient import web_service_client

"""
import requests
from rest_framework_jwt.settings import api_settings

from rest_framework import serializers
from ozpcenter import models
from django.conf import settings

jwt_payload_handler = api_settings.JWT_PAYLOAD_HANDLER
jwt_encode_handler = api_settings.JWT_ENCODE_HANDLER


if hasattr(settings, 'WS_URL'):
    WS_URL = settings.WS_URL
else:
    WS_URL = 'http://127.0.0.1:4200'


if hasattr(settings, 'WS_ENABLE'):
    WS_ENABLED = settings.WS_ENABLE
else:
    WS_ENABLED = False


class DictField(serializers.ReadOnlyField):
    """
    Read Only Field
    """

    def from_native(self, obj):
        return None


class NotificationMailBoxSerializer(serializers.HyperlinkedModelSerializer):
    created_date = serializers.DateTimeField(required=False, source='notification.created_date')
    expires_date = serializers.DateTimeField(required=False, source='notification.expires_date')
    author = serializers.IntegerField(required=False, source='notification.author.id')
    message = serializers.CharField(required=False, source='notification.message')
    listing = serializers.IntegerField(required=False, source='notification.listing.id')
    agency = serializers.IntegerField(required=False, source='notification.agency.id')
    # peer = DictField(required=False, source='notification.peer')
    notification_type = serializers.CharField(required=False, source='notification.notification_type')
    notification_subtype = serializers.CharField(required=False, source='notification.notification_subtype')
    entity_id = serializers.IntegerField(required=False, source='notification.entity_id')
    notification_id = serializers.IntegerField(required=False, source='notification.id')

    class Meta:
        model = models.NotificationMailBox
        fields = ('id', 'notification_id', 'created_date', 'expires_date', 'author',
            'message', 'notification_type', 'notification_subtype', 'listing', 'agency', 'entity_id',  # 'peer',
            'read_status', 'acknowledged_status', )


class WebServiceClient(object):
    """
    Client for WS Service
    https://github.com/aml-development/aml-ws-service
    """

    def send_bulk_message(self, sender_profile, bulk_notification_list):
        """
        Call API for sending messages to users

        Args:
            bulk_notification_list:
                [notificationMailBox]

                Should Transform to
                [
                    {
                        "target":"1",
                        "channel": "notification",
                        "payload": {
                            "message" : "test notification"
                        }
                    }
                ]
        """
        if not WS_ENABLED:
            # Call to ws service not enabled
            pass

        if not bulk_notification_list:
            assert 'call is missing input data'

        data_to_send = []

        for notification_mail_box in bulk_notification_list:
            current_data = NotificationMailBoxSerializer(notification_mail_box).data

            data_to_send.append(
                {
                    "target": "{}".format(notification_mail_box.target_profile.user.id),
                    "channel": "notification",
                    "payload": current_data
                }
            )

        try:
            payload = jwt_payload_handler(sender_profile.user)
            token = jwt_encode_handler(payload)

            # TODO: need to authentication to ws service (not everybody should be able to call this api)
            url = '{}/api/send/'.format(WS_URL)
            headers = {
                'Authorization': token
            }
            request = requests.post(url, json=data_to_send, headers=headers)

            if request.status_code == 200:
                return request.json()
            else:
                return request.text
        except Exception as err:
            print(err)
            return "error"


web_service_client = WebServiceClient()
