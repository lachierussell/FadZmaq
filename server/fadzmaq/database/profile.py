# @file
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

import fadzmaq.database.connection as db
from fadzmaq.database.hobbies import get_hobbies


def update_profile(subject, uid):
    rows = db.get_db().execute(
        '''
        UPDATE profile
        SET nickname= %s, bio= %s, email= %s, phone= %s
        WHERE user_id= %s;
        ''', subject.values['nickname'], subject.values['bio'], subject.values['email'],
        subject.values['phone'], uid
    )


def build_profile_data(row, permission):
    assert type(permission) is int
    assert permission <= 2
    # row = rows.first()
    assert row is not None, "Query retrieved no rows to build profile."

    profile_fields = []
    # permission_keys = [['bio', 'age', 'location'],
    permission_keys = [['bio', 'location'],
                       ['phone', 'email'],
                       ['birth-date']
                       ]
    for perm in range(0, permission):
        for key in permission_keys[perm]:
            if key == 'location':
                continue  # TODO: Add this to query and calculate on db
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
            'profile_fields': profile_fields,
            'hobbies': get_hobbies(row['user_id'])
        }
    }
    return profile


# Retrieves profile information for the subject.
# @param    subject     user_id for the database entry
# @return   json profile data or raises value error.
def retrieve_profile(subject):
    # Retrieves user info.
    rows = db.get_db().execute(
        '''
        SELECT *, EXTRACT(year FROM age(current_date, dob)) :: INTEGER AS age 
        FROM profile 
        WHERE user_id = %s
        ''', subject
    )

    return build_profile_data(rows.first(), 2)


# @brief Verifies the user is in the database
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


# @brief Creates a user in the database
# @throws IOError if the user already exists or the database insertion fails.
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


# @brief Performs a cascade delete on all the user information
# This will revoke and previous matches, likes, ratings and locations
# associated with this user.
def delete_account(uid):
    db.get_db().execute(
        '''
        DELETE FROM profile WHERE user_id = %s; 
        ''', uid
    )


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


def update_settings(uid, value):
    db.get_db().execute(
        '''
        UPDATE profile 
        SET distance_setting = %s 
        WHERE user_id = %s;
        ''', value, uid
    )


def set_location(uid, lat, long):
    db.get_db().execute(
        '''
        INSERT INTO location_data (user_id, lat, long) VALUES (%s, %s, %s)
        ''', uid, float(lat), float(long)
    )
