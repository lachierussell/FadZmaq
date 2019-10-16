# @file
# @brief Builds profile data and retrieves profile information.
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
# @author Jordan Russell        20357813@student.uwa.edu.au
# @author Thiren Naidoo         22257963@student.uwa.edu.au
# @author Beining Chen          22384298@student.uwa.edu.au

import fadzmaq.database.connection as db
from fadzmaq.database.hobbies import get_hobbies


## @brief Updates a users profile.
# @param subject    The posted values
# @param uid        Your user id.
# @warning For some reason this function uses HTML form data rather than
# JSON like the rest of the project. This was marked to be fixed by the team has been too
# pushed for time implementing all the other features.
# @warning Currently no input validation.
def update_profile(subject, uid):
    db.get_db().execute(
        '''
        UPDATE profile
        SET nickname= %s, bio= %s, email= %s, phone= %s, photo= %s
        WHERE user_id= %s;
        ''', subject.values['nickname'], subject.values['bio'], subject.values['email'],
        subject.values['phone'], subject.values['photo'], uid
    )


## @brief Builds a profiles user data into an object.
# This is a dynamic build depending on the permissions of the caller.
# e.g. a recommendation profile will only contain age and bio, but a match will also contain contact information.
# @param row        A ResultProxy row to extract values from.
# @param permission The permission value of the caller. 0 is recs, 1 is matches, 2 is account
# @return A profile object.
# @note This is not JSON, convert to JSON with `jsonify()`.
# @warning Location is currently excluded from the data.
def build_profile_data(row, permission):
    assert type(permission) is int
    assert permission <= 2
    # row = rows.first()
    assert row is not None, "Query retrieved no rows to build profile."

    profile_fields = []
    permission_keys = [['bio', 'location'],
                       ['phone', 'email'],
                       ['birth-date']
                       ]
    for perm in range(0, permission):
        for key in permission_keys[perm]:
            if key == 'location':
                continue
            profile_fields.append(
                {
                    "name": key,
                    "display_value": str(row[key])
                }
            )

    profile = {
        'profile': {
            'user_id': row['user_id'],
            'name': row['nickname'],
            'photo_location': row['photo'],
            'rating': row['rating'],
            'profile_fields': profile_fields,
            'hobbies': get_hobbies(row['user_id'])
        }
    }
    return profile


## @brief Retrieves profile information for the subject.
# @param    subject     user_id for the profile.
# @return   Profile data object.
# @note This is not JSON, convert to JSON with `jsonify()`.
def retrieve_profile(subject):
    # Retrieves user info.
    rows = db.get_db().execute(
        '''
        SELECT *, -1 as rating
        FROM profile 
        WHERE user_id = %s
        ''', subject
    )
    return build_profile_data(rows.first(), 2)


## @brief Verifies the user is in the database.
# @param subject    The user id to check if exists.
# @returns True if the user exists
def verify_user(subject):
    rows = db.get_db().execute(
        '''
        SELECT COUNT(user_id)
        FROM profile
        WHERE user_id = %s;
        ''', subject
    )

    for row in rows:
        if row['count'] == 1:
            return True
    return False


## @brief Creates a user in the database
# @param name   The users nickname.
# @param email  The users email.
# @param uid    The users ID.
# @throws IOError if the user already exists or the database insertion fails.
# @warning Currently no input validation.
def make_user(name, email, uid):
    rows = db.get_db().execute(
        '''
        INSERT INTO profile (nickname, email, user_id) VALUES (%s, %s, %s) RETURNING user_id;
        ''', name, email, uid
    )
    for row in rows:
        print(str(row['user_id']))
        return str(row['user_id'])
    print('IOError: No Rows')
    raise IOError


## @brief Performs a cascade delete on all the user information
# This will revoke any previous matches, likes, ratings and locations
# associated with this user.
# @param uid    The user ID to delete from the database.
# @warning This function is **NOT** reversible.
def delete_account(uid):
    db.get_db().execute(
        '''
        DELETE FROM profile WHERE user_id = %s; 
        ''', uid
    )


## @brief Retrieves the distance setting from the database.
# @param uid    The users id.
# @return A object containing the distance setting.
# @note This is not JSON, convert to JSON with `jsonify()`.
def retrieve_settings(uid):
    rows = db.get_db().execute(
        '''
        SELECT distance_setting 
        FROM profile
        WHERE user_id = %s;
        ''', uid
    )
    return {
        "distance_setting": rows.first()['distance_setting']
    }


## @brief Updates the distance settings for a particular user
# @param uid        The users id.
# @param value      The new distance value.
# @warning Currently no input validation.
def update_settings(uid, value):
    db.get_db().execute(
        '''
        UPDATE profile 
        SET distance_setting = %s 
        WHERE user_id = %s;
        ''', value, uid
    )


## @brief Sets the user location and device id.
# This records the user location. It should be reduced to 2.S.F on the device to reduce the risk of sensitive
# information being leaked.
# @param uid    The user id.
# @param lat    The latitude.
# @param long   The longitude.
# @param dev    The FCM device registration token.
def set_location(uid, lat, long, dev):
    db.get_db().execute(
        '''
        INSERT INTO location_data (user_id, lat, long, device_id) VALUES (%s, %s, %s, %s)
        ''', uid, float(lat), float(long), dev
    )
