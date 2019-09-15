# @file
# @brief        Database functions
# database/db.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# This file contains our functions to retrieve and clean data from the database.
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
# @author Jordan Russell        [email]

import hashlib
import json
from flask import current_app, g
from sqlalchemy import create_engine


def init_app(app):
    app.teardown_appcontext(close_db)


def get_engine():
    if 'db_engine' not in g:
        g.db_engine = create_engine(current_app.config['DATABASE_URI'])
        # g.db_engine = create_engine(db_conf.DATABASE_URI)
    return g.db_engine


def get_db():
    if 'db' not in g:
        g.db = connect_db()
    return g.db


def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()


def connect_db():
    engine = get_engine()
    return engine.connect()


def hash_id(id):
    return hashlib.md5(str(id).encode()).hexdigest()

def update_profile(subject, uid):
    rows = get_db().execute(
        '''
		UPDATE profile set nickname = '{}', bio ='{}', email ='{}', phone ='{}' where user_id = '{}'
        '''.format(subject.values['nickname'], subject.values['bio'], subject.values['email'], subject.values['phone'], uid)
    )

# Retrieves profile information for the subject.
# @param    subject     user_id for the database entry
# @return   json profile data or raises value error.
def retrieve_profile(subject):
    # Retrieves user info.
    rows = get_db().execute(
        '''
        SELECT *, EXTRACT(year FROM age(current_date, dob)) :: INTEGER AS age 
        FROM profile 
        WHERE user_id = '{}'
        '''.format(subject)
    )

    for row in rows:
        # TODO: Dynamically serve profile fields data.
        profile = {
            'profile': {
                'user_id': hash_id(row['user_id']),
                'name': row['nickname'],
                'age': str(row['age']),
                'birth-date': str(row['dob']),
                'photo_location': row['photo'],
                'contact_details': {
                    'phone': row['phone'],
                    'email': row['email']
                },
                'profile_fields': [
                    {
                        'id': 1,
                        'name': 'About me',
                        'display_value': row['bio']
                    }
                ],
                'hobbies': get_hobbies(subject)
            }
        }
        return json.dumps(profile)
    raise ValueError


# Retrieves the user hobbies
# @param subject    User id
# @return List of share/discover hobbies as per API spec.
def get_hobbies(subject):
    # Retrieves hobbies
    rows = get_db().execute(
        '''      
        SELECT  h.hobby_id, h.name, uh.swap
        FROM profile
          JOIN user_hobbies uh
            ON profile.user_id = uh.user_id
          JOIN hobbies h
            ON uh.hobby_id = h.hobby_id
        WHERE profile.user_id = '{}';
        '''.format(subject)
    )

    share = []
    discover = []

    for row in rows:
        data = {
            'id': row['hobby_id'],
            'name': row['name']
        }
        if row['swap'] == 'share':
            share.append(data)

        if row['swap'] == 'discover':
            discover.append(data)

    return [
        {
            'share': share
        },
        {
            'discover': discover
        }
    ]


# @brief Gets a users current matches
# @return A dictionary (JSON based) containing their match information.
def get_matches(subject):
    rows = get_db().execute(
        '''
        SELECT profile.nickname, profile.user_id, profile.photo FROM profile
        WHERE profile.user_id IN (
            SELECT user_a
            FROM matches
            WHERE user_a = '{}'
               OR user_b = '{}'
        )
        AND profile.user_id != '{}'
        OR profile.user_id IN (
            SELECT user_b
            FROM matches
            WHERE user_a = '{}'
               OR user_b = '{}'
        )
        AND profile.user_id != '{}';
        '''.format(subject, subject, subject, subject, subject, subject)
    )

    matches = []

    for row in rows:
        matches.append({
            'id': row['user_id'],
            'name': row['nickname'],
            # 'photo': 'DOES NOT EXIST'
            'photo': row['photo']
        })

    return {
        "matches": matches
    }


# @brief Verifies the user is in the database
# @returns True if the user exists
def verify_user(subject):
    rows = get_db().execute(
        '''
        SELECT COUNT(user_id)
        FROM profile
        WHERE user_id = '{}';
        '''.format(subject)
    )

    for row in rows:
        if row['count'] == 1:
            return True
    return False


# @brief Creates a user in the database
# @throws IOError if the user already exists or the database insertion fails.
def make_user(name, email, uid):
    rows = get_db().execute(
        '''
        INSERT INTO profile (nickname, email, user_id) VALUES ('{}', '{}', '{}') RETURNING user_id; 
        '''.format(name, email, uid)
    )
    for row in rows:
        print(str(row['user_id']))
        return str(row['user_id'])
    print('IOErro: No Rows')
    raise IOError


# @brief Gets a match by id
def get_match_by_id(uid, id):
    print(uid, id)
    rows = get_db().execute(
        '''
        SELECT *, EXTRACT(year FROM age(current_date, dob)) :: INTEGER AS age 
        FROM profile
            WHERE user_id = '{}'
            AND user_id IN (
                SELECT user_id FROM matches
                WHERE user_a = '{}'
                        AND user_b = '{}'
                    OR user_b = '{}'
                        AND user_a = '{}'
        );
        '''.format(id, uid, id, uid, id)
    )

    for row in rows:
        profile = {
            'profile': {
                'user_id': row['user_id'],
                'name': row['nickname'],
                'age': str(row['age']),
                'photo_location': row['photo'],
                'contact_details': {
                    'phone': row['phone'],
                    'email': row['email']
                },
                'profile_fields': [
                    {
                        'id': 1,
                        'name': 'About me',
                        'display_value': row['bio']
                    }
                ],
                'hobbies': get_hobbies(id)
            }
        }
        return json.dumps(profile)
    raise ValueError("Did not find row")


# @brief Updates the users hobbies
# Deletes current hobbies and updates with the new hobbies.
def update_user_hobbies(uid, request):
    try:
        get_db().execute(
            '''
            DELETE FROM user_hobbies
            WHERE user_id = '{}';
            '''.format(uid)
        )
        hobbies = request["hobbies"]
        for category in hobbies:
            print(category)
            for offer in category:
                print(offer)
                for hobby in category[offer]:
                    print(hobby['id'])
                    get_db().execute(
                        '''
                        INSERT INTO user_hobbies (user_id, hobby_id, swap)
                        VALUES ('{}', {}, '{}');
                        '''.format(uid, hobby['id'], offer)
                    )

    except Exception as e:
        raise IOError(str(e))


# @brief Retrieves the full list of hobbies from the db.
def get_hobby_list():
    try:
        rows = get_db().execute(
            '''
            SELECT * FROM hobbies;
            '''
        )

        hobbies = []
        for row in rows:
            hobby = {
                "id": row['hobby_id'],
                "name": row["name"],
            }
            hobbies.append(hobby)

        hobbies_list = {
            'hobby_list': hobbies
        }
        return hobbies_list

    except Exception as e:
        raise IOError(str(e))


# # @brief updates the users profile in the db.
# def update_profile(uid, request):
#
#
#
#
