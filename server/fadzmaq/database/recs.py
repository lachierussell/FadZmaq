# @file
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

import fadzmaq.database.connection as db
from fadzmaq.api.notifications import notify_match
from fadzmaq.database.profile import build_profile_data


def like_user(uid, id, vote):

    # for testing remove me later!
    import random
    if random.choice([0, 1]) == 1:
        matches = []
        # use our own id while we're using placeholder recommendations
        matches.append(retrieve_profile(uid))
        # matches.append(retrieve_profile(id))
        return {
            "match": True,
            "matched": matches,
        }
    else:
        return {
            "match": False,
            "matched": [],
        }

    ########################################################
    # # CAN THIS BE REMOVED?
    #
    # rows = db.get_db().execute(
    #     '''
    #     INSERT INTO votes (time, vote, user_from, user_to)
    #     VALUES (now(), %s, %s, %s)
    #     RETURNING *;
    #     ''', vote, uid, id
    # )
    # if rows.first() is None:
    #     print('MATCH')
    #     notify_match()
    #
    #     matches = []
    #     matches.append(retrieve_profile(id))
    #     return {
    #         "match": True,
    #         "matched": matches,
    #         }
    # else:
    #     return {
    #         "match": False,
    #         "matched":[],
    #         }


def calculate_compatibility(row):

    dist = row['distance']
    hobbies = row['hobbies']
    rating = row['score']

    compatibility = (dist - hobbies) * (1 - rating)

    return compatibility


def get_recommendations(uid):
    top_users = []
    rows = db.get_db().execute(
        '''
        SELECT * FROM matching_algorithm(%s)
        ''', uid
    )
    for row in rows:
        entry = [row['user_id'], calculate_compatibility(row)]
        top_users.append(tuple(entry))

    top_users.sort(key=lambda top: top_users[1], reverse=True)
    top_users = top_users[:20]
    print(top_users)

    recommendations = []
    for user in top_users:
        recommendations.append(get_recommendation_profile(user[0], uid))

    return recommendations


def get_recommendation_profile(user_id, my_id):
    row = db.get_db().execute(
        '''
        SELECT *, (
             SELECT * FROM distance_table(%s)
             WHERE user_id = %s
        )
        FROM profile
        WHERE user_id = %s;
        ''', my_id, user_id, user_id
    ).first()

    build_profile_data(row, 1)
