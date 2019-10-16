## @file
# @brief Contains functions for retrieving and calculating recommendations.
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
# @author Jordan Russell        20357813@student.uwa.edu.au
# @author Thiren Naidoo         22257963@student.uwa.edu.au

import fadzmaq.database.connection as db
from fadzmaq.api.notifications import notify_match
from fadzmaq.database.profile import retrieve_profile
from fadzmaq.database.profile import build_profile_data


## @brief Votes a user. The type of vote is dependant on param vote.
# @param uid    Your user id.
# @param id     Their user id.
# @param vote   True for a like, False for a pass.
# @return An object indicating whether the vote resulted in a match.
# @note This is not JSON. To convert to JSON use `jsonify()`.
# @warning This function has been modified for testing. A vote on a test user will result in a
# match 1/3 of the time.
def like_user(uid, id, vote):
    ######
    # TESTING
    # REMOVE FOR PRODUCTION
    #####
    # Initialises random matches
    import random
    if id.startswith('testaccount') and random.choice([0, 0, 1]) == 1:
        db.get_db().execute(
            '''
            INSERT INTO votes (time, vote, user_from, user_to) 
            VALUES (now(), %s, %s, %s)
            RETURNING *;
            ''', vote, id, uid
        )

    # End of testing block
    rows = db.get_db().execute(
        '''
        INSERT INTO votes (time, vote, user_from, user_to) 
        VALUES (now(), %s, %s, %s)
        RETURNING *;
        ''', vote, uid, id
    )
    if rows.first() is None:
        print('MATCH')
        notify_match(id)
        matches = [retrieve_profile(id)]
        return {
            "match": True,
            "matched": matches,
            }
    return {
        "match": False,
        "matched": [],
        }


## @brief Calculates the compatibility score of your recommendations.
# This takes in input from the database indicating shared hobbies and distance as well as average rating
# and uses that to calculate an elo-based matching algorithm.
# @param row    ResultProxy row containing distance, hobbies and score.
# @returns A value indicating compatibility. Lower is better.
def calculate_compatibility(row):
    dist = row['distance']
    hobbies = row['hobbies']
    rating = row['score']

    # Default values for new users.
    # These values should be tuned for the algorithm
    # and desired result.
    if rating is None:
        rating = 0
    if dist is None:
        dist = 10
    if hobbies is None:
        hobbies = 0

    # 1.5 is the slow growth rate of having more hobbies
    hobbies_factor = (hobbies ** 1.5)

    # Increase 2 to increase effect of rating
    rating_factor = (2 ** (1 - rating))

    # This slows down the exponential function significantly,
    # we want the furthest people to impact rating
    distance_factor = (5 ** (0.03 * dist))

    return (hobbies_factor - distance_factor) * rating_factor


## @brief Retrieves a list of users who would be suitable recommendations to the current user.
# This builds a list of profiles (similar to matches) which contains their information in a sorted list, based off of
# the compatibility score calculated above.
# @param uid    Your user id.
# @return A sorted list of recommendations.
# @note This is not JSON. To convert to JSON use `jsonify()`.
def get_recommendations(uid):
    top_users = []

    rows = db.get_db().execute(
        '''
        SELECT * FROM matching_algorithm(%s);
        ''', uid
    )
    for row in rows:
        entry = [row['user_id'], calculate_compatibility(row)]
        top_users.append(tuple(entry))

    top_users.sort(key=lambda top: top[1], reverse=True)
    top_users = top_users[:20]
    print(top_users)

    recommendations = []
    for user in top_users:
        recommendations.append(get_recommendation_profile(user[0], uid))

    return {
        "recommendations": recommendations
    }


## @brief Gets a profile of a recommendation individually.
# This is used by get recommendations to build each profile in the list.
# @param user_id    Their user ID.
# @param my_id      Your user ID.
# @return Profile data object.
def get_recommendation_profile(user_id, my_id):
    row = db.get_db().execute(
        '''
        SELECT *, -1 as rating, (
             SELECT distance FROM distance_table(%s)
             WHERE user_id = %s
             LIMIT 1
        )
        FROM profile
        WHERE user_id = %s;
        ''', my_id, user_id, user_id
    ).first()

    return build_profile_data(row, 1)
