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

import fadzmaq.database.connection as db
from fadzmaq.database.hobbies import get_matched_hobbies
from fadzmaq.database.profile import build_profile_data


# @brief Gets a users current matches
# @return A dictionary (JSON based) containing their match information.
def get_matches(subject):
    rows = db.get_db().execute(
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
            'photo': row['photo'],
            'hobbies': get_matched_hobbies(subject, row['user_id'])
        })

    return {
        "matches": matches
    }


# @brief Gets a match by id
def get_match_by_id(uid, id):
    print(uid, id)
    rows = db.get_db().execute(
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
    return build_profile_data(rows)


