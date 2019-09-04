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

from database import connection
import hashlib
import json


# Retrieves profile information for the subject.
# @param    subject     user_id for the database entry
# @return   json profile data or raises value error.
def retrieve_profile(subject):

    rows = connection.execute('SELECT *, EXTRACT(year FROM age(current_date, dob)) :: INTEGER AS age '
                              + 'FROM profile '
                              + 'WHERE user_id = ' + str(subject) + ';'
                              )

    for row in rows:
        # TODO: Need to implement the remaining data.
        # TODO: Needs additions and modifications to the database.
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
                ]
            }
        }
        return json.dumps(profile)
    raise ValueError
