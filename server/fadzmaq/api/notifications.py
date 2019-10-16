# @file
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.


from firebase_admin import messaging
import fadzmaq.database.connection as db


def notify_match(id):
    # TODO: query for token
    row = db.get_db().execute(
        '''
        SELECT device_id
        FROM location_data
        WHERE user_id = %s
        ORDER BY ping_time
        LIMIT 1;
        ''', id
    ).first()

    # This registration token comes from the client FCM SDKs.
    registration_token = row['device_id']

    # See documentation on defining a message payload.
    message = messaging.Message(
        data={
            'message': 'You have a new match!'
        },
        token=registration_token,
    )

    # Send a message to the device corresponding to the provided
    # registration token.
    response = messaging.send(message)
    # Response is a message ID string.
    print('Successfully sent message:', response)
