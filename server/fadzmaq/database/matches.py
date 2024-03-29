## @file
# @brief Retrieves information about a users matches.
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
# @author Jordan Russell        jordanrussell@live.com

import fadzmaq.database.connection as db
from fadzmaq.database.profile import build_profile_data


## @brief Gets a users current matches.
# This is a full list of matches.
# @param subject    Your user ID.
# @return A dictionary (JSON based) containing their match information.
# @note This is not JSON, convert to JSON with `jsonify()`.
def get_matches(subject):
    rows = db.get_db().execute(
        '''
        SELECT
            profile.*,
            MAX(time) AS time,
            MAX(COALESCE(rating.rate_value, - 1)) AS rating,
            MAX(COALESCE(distance.distance,-1)) AS distance
        FROM (
            SELECT user_b AS user_id, time
            FROM matches
            WHERE user_a = %s
                AND unmatch = false
            
            UNION
            
            SELECT user_a AS user_id, time
            FROM matches
            WHERE user_b = %s
                AND unmatch = false
            ) matches
        LEFT JOIN profile ON profile.user_id = matches.user_id
        LEFT JOIN rating ON matches.user_id = rating.user_to AND rating.user_from = %s
        LEFT JOIN distance_table(%s) AS distance ON matches.user_id = distance.user_id
        GROUP BY profile.user_id
        ORDER BY time DESC
        ''', subject, subject, subject, subject
    )

    matches = []
    for row in rows:
        matches.append(build_profile_data(row, 2))

    return {
        "matches": matches
    }


## @brief Gets a matches profile by their ID
# @param uid    Your user id.
# @param id     Their user id.
# @return Their profile data.
# @note This is not JSON, convert to JSON with `jsonify()`.
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
          AND user_from = %s
        WHERE user_id = %s
        AND user_id IN (
            SELECT user_id FROM matches
            WHERE user_a = %s
                    AND user_b = %s
                OR user_b = %s
                    AND user_a = %s
        );
        ''', uid, id, uid, id, uid, id
    )
    return build_profile_data(rows.first(), 3)


## @brief Un-matches two users by setting their matched column to false.
# @param uid    Your user id.
# @param id     Their user id.
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
