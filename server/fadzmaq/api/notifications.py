## @file
# @brief Handles Firebase Cloud Messaging Notification Functions
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.

from firebase_admin import messaging
import fadzmaq.database.connection as db


## @brief Sends a notification to the last device used by a user.
# Using Google firebase device registration tokens and FCM a notification will be sent to the last connected device.
# This is stored and updated via the `/account/ping` route.
#
# @param id     The user id to notify.
# @warning      No indication is returned as to the success of this function. If a user does not have a registered
# device they will not receive the notification.
def notify_match(id):
    row = db.get_db().execute(
        '''
        SELECT device_id
        FROM location_data
        WHERE user_id = %s
        ORDER BY ping_time DESC
        LIMIT 1;
        ''', id
    ).first()

    # This registration token comes from the client FCM SDKs.
    registration_token = row['device_id']
    if registration_token is None:
        print('Message not sent: No device token')
        return

    if registration_token == "":
        print('Message not sent: No device token')
        return

    notification = messaging.Notification(title='You have a new match!')
    # See documentation on defining a message payload.
    message = messaging.Message(notification= notification, token= registration_token)


    try:
        # Send a message to the device corresponding to the provided
        # registration token.
        response = messaging.send(message)
        # Response is a message ID string.
        print(response)
        print('Successfully sent message:', response)
    except ValueError as e:
        print(str(e))
        return 'Failed: ' + str(e), 500

    
