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

from database import *
import json


def retrieve_profile(subject):

    rows = connection.execute('SELECT * FROM primary_user \
                         WHERE user_id =' + str(subject) + ';'
                        )

    for row in rows:
        profile = {
            'profile': {
                'user_id': row['user_id'],
                'name': row['nickname'],
                'age': row['age'],
                'gender': row['gender'],
                'contact_details': {
                    'phone': row['phone'],
                    'email': row['email']
                },
                'profile_fields': [
                    {
                        'id': 3,
                        'name': 'About me',
                        'display_value': row['bio']
                    }
                ]
            }
        }
        return json.dumps(profile)

    return json.dumps({'error': 'Profile not found'})
