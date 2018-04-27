"""
Client for AML Web Socket Service
http://docs.python-requests.org/en/master/

Usage:
    from ozpcenter.wsservice.wsclient import web_service_client

"""
import requests

from django.conf import settings

if hasattr(settings, 'WS_URL'):
    WS_URL = settings.WS_URL
else:
    WS_URL = 'http://127.0.0.1:4200'


if hasattr(settings, 'WS_ENABLE'):
    WS_ENABLED = settings.WS_ENABLE
else:
    WS_ENABLED = False


class WebServiceClient(object):
    """
    Client for WS Service
    https://github.com/aml-development/aml-ws-service
    """

    def send_bulk_message(self, bulk_notification_list):
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
            data_to_send.append(
                {
                    "target": "{}".format(notification_mail_box.target_profile.id),
                    "channel": "notification",
                    "payload": {
                        "message": notification_mail_box.notification.message
                    }
                }
            )

        try:
            # TODO: need to authentication to ws service (not everybody should be able to call this api)
            request = requests.post('{}/api/send/'.format(WS_URL), json=data_to_send)

            if request.status_code == 200:
                return request.json()
            else:
                return request.text
        except Exception:
            return "error"


web_service_client = WebServiceClient()
