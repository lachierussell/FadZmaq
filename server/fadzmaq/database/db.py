# @file
# @brief        Database functions
# database/__init__.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# This file contains our functions to retrieve and clean data from the database.
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

import hashlib
import json
from flask import current_app, g
from sqlalchemy import create_engine
from fadzmaq import api

from fadzmaq.database import db_conf

# need to change this to be config based
engine = create_engine(db_conf.DATABASE_URI)

def init_app(app):
    app.teardown_appcontext(close_db)

def get_db():
    if 'db' not in g:
        g.db = connect_db()
    return g.db

def close_db(e=None):
    db = g.pop('db',None)

    if db is not None:
        db.close()

def connect_db():
    # engine = get_engine()
    return engine.connect()

# Retrieves profile information for the subject.
# @param    subject     user_id for the database entry
# @return   json profile data or raises value error.
def retrieve_profile(subject):
    # Retrieves user info.
    rows = g.db.execute(
        '''
        SELECT *, EXTRACT(year FROM age(current_date, dob)) :: INTEGER AS age 
        FROM profile 
        WHERE user_id = {}
        '''.format(subject)
    )

    for row in rows:
        # TODO: Dynamically serve profile fields data.
        profile = {
            'profile': {
                'user_id': hashlib.md5(str(row['user_id']).encode()).hexdigest(),
                'name': row['nickname'],
                'age': str(row['age']),
                'birth-date': str(row['dob']),
                'gender': row['gender'],
                'photo_location': 'DOES NOT EXIST',
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
    rows = g.db.execute(
        '''      
        SELECT  h.hobby_id, h.name, uh.swap
        FROM profile
          JOIN user_hobbies uh
            ON profile.user_id = uh.user_id
          JOIN hobbies h
            ON uh.hobby_id = h.hobby_id
        WHERE profile.user_id = {};
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



