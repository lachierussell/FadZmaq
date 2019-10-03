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
            WHERE user_a = %s
               OR user_b = %s
        )
        AND profile.user_id != %s
        OR profile.user_id IN (
            SELECT user_b
            FROM matches
            WHERE user_a = %s
               OR user_b = %s
        )
        AND profile.user_id != %s;
        ''', subject, subject, subject, subject, subject, subject
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
            WHERE user_id = %s
            AND user_id IN (
                SELECT user_id FROM matches
                WHERE user_a = %s
                        AND user_b = %s
                    OR user_b = %s
                        AND user_a = %s
        );
        ''', id, uid, id, uid, id
    )
    return build_profile_data(rows, 1)

