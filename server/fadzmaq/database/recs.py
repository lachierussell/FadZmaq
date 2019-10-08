# @file
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

import fadzmaq.database.connection as db
from fadzmaq.api.notifications import notify_match
from fadzmaq.database.profile import retrieve_profile
from fadzmaq.database.profile import build_profile_data

import random

def like_user(uid, id, vote):

    # # for testing remove me later!
    # import random
    # if random.choice([0, 1]) == 1:
    #     matches = []
    #     # use our own id while we're using placeholder recommendations
    #     matches.append(retrieve_profile(uid))
    #     # matches.append(retrieve_profile(id))
    #     return {
    #         "match": True,
    #         "matched": matches,
    #     }
    # else:
    #     return {
    #         "match": False,
    #         "matched":[],
    #     }


    ########################################################


    if id.startswith('testaccount') and random.choice([0,0,1]) == 1:
        test = db.get_db().execute(
            '''
            INSERT INTO votes (time, vote, user_from, user_to) 
            VALUES (now(), %s, %s, %s)
            RETURNING *;
            ''', vote, id, uid
        )


    rows = db.get_db().execute(
        '''
        INSERT INTO votes (time, vote, user_from, user_to) 
        VALUES (now(), %s, %s, %s)
        RETURNING *;
        ''', vote, uid, id
    )
    if rows.first() is None:
        print('MATCH')
        notify_match()
        matches = []
        matches.append(retrieve_profile(id))
        return {
            "match": True,
            "matched": matches,
            }
    else:
        return {
            "match": False,
            "matched":[],
            }


# @brief Gets a users recommendations
# @return A dictionary (JSON based) containing their match information.
def get_recommendations(subject):
    rows = db.get_db().execute(
        '''
        SELECT * FROM profile
        WHERE NOT profile.user_id IN (
            SELECT user_a
            FROM matches
            WHERE user_a = %s
               OR user_b = %s
        )
        AND NOT profile.user_id IN (
            SELECT user_b
            FROM matches
            WHERE user_a = %s
               OR user_b = %s
        )
        AND NOT profile.user_id IN (
            SELECT user_to
            FROM votes
            WHERE user_from = %s
        )
        AND profile.user_id != %s
        LIMIT 20;
        ''', subject, subject, subject, subject, subject, subject
    )

    recommendations = []

    for row in rows:
        # matches.append({
        #     'id': row['user_id'],
        #     'name': row['nickname'],
        #     'photo': row['photo'],
        #     'hobbies': get_matched_hobbies(subject, row['user_id'])
        # })

        recommendations.append(build_profile_data(row, 1))

    return {
        "recommendations": recommendations
    }