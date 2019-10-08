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
        SELECT *,
         CASE WHEN r.rate_value is NULL THEN -1 ELSE r.rate_value 
         END AS rating
        FROM profile
        FULL OUTER JOIN rating r 
          ON user_id = user_to
        WHERE profile.user_id IN (
            SELECT user_a
            FROM matches
            WHERE user_a = %s
               OR user_b = %s
               AND NOT matches.unmatch
        )
        AND profile.user_id != %s
        OR profile.user_id IN (
            SELECT user_b
            FROM matches
            WHERE user_a = %s
               OR user_b = %s
               AND NOT matches.unmatch
        )
        AND profile.user_id != %s;
        ''', subject, subject, subject, subject, subject, subject
    )

    matches = []

    for row in rows:
        # matches.append({
        #     'id': row['user_id'],
        #     'name': row['nickname'],
        #     'photo': row['photo'],
        #     'hobbies': get_matched_hobbies(subject, row['user_id'])
        # })
        matches.append(build_profile_data(row, 2))

    return {
        "matches": matches
    }


# @brief Gets a match by id
def get_match_by_id(uid, id):
    print(uid, id)
    # EXTRACT(year FROM age(current_date, dob)) :: INTEGER AS age # If we need age calculation
    rows = db.get_db().execute(
        '''
        SELECT *,
        CASE WHEN rating.rate_value is NULL THEN -1 ELSE rating.rate_value END AS rating
        FROM profile
        FULL OUTER JOIN rating 
          ON user_id = user_to
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
    return build_profile_data(rows.first(), 2)


# Un-matches two users by setting their matched column to false.
def unmatch(uid, id):
    rows = db.get_db().execute(
        '''
        UPDATE matches
        SET unmatch = TRUE
        WHERE user_a = %s
            AND user_b = %s
          OR user_a = %s
            AND user_b = %s;
        ''', uid, id, id, uid
    )


# Rates a user Thumbs up or down
# @param value  True is thumbs up
# @param uid    My id
# @param id     id of the user being rated/
def rate_user(uid, id, value):
    if value is None:
        row = db.get_db().execute(
            '''
            SELECT COUNT(*) as c
            FROM rating 
            WHERE user_from = %s
              AND user_to = %s;
            ''', uid, id
        ).first()
        if row['c'] > 0:
            db.get_db().execute(
                '''
                DELETE FROM rating WHERE user_from = %s AND user_to = %s;
                ''', uid, id
            )
            print('deleted')
    else:
        db.get_db().execute(
            '''
            INSERT INTO rating (user_to, user_from, rate_value) VALUES (%s, %s, %s);
            ''', id, uid, int(value)
        )
