## @file
# @brief Retrieves and builds hobby related data.
# Contains the functions which collect the hobby data from the database and builds
# this data into json object. The functions have been abstracted to reduce code overhead.
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

import fadzmaq.database.connection as db


## @brief Retrieves a users currently selected hobbies.
# @param subject    User id
# @return List of share/discover hobbies as per API spec.
def get_hobbies(subject):
    # Retrieves hobbies
    rows = db.get_db().execute(
        '''
        SELECT  h.hobby_id, h.name, uh.swap
        FROM profile
          JOIN user_hobbies uh
            ON profile.user_id = uh.user_id
          JOIN hobbies h
            ON uh.hobby_id = h.hobby_id
        WHERE profile.user_id = %s;
        ''', subject
    )
    return build_hobby_data(rows)


## @brief Builds the selected hobby data into objects
# Takes the ResultProxy rows and builds these into hobby containers. These are collected into categories
# to provide the mobile client an indication of whether the user is sharing/discovering this hobby or it is a matched
# hobby with another user.
# @param rows   ResultProxy object containing the hobby data.
# @return A python list of dictionaries representing the JSON objects.
# @note This is not JSON. Convert to JSON with `jsonify()`
def build_hobby_data(rows):
    share = []
    discover = []
    matched = []

    for row in rows:
        data = {
            'id': row['hobby_id'],
            'name': row['name']
        }
        if row['swap'] == 'share':
            share.append(data)

        if row['swap'] == 'discover':
            discover.append(data)

        if row['swap'] == 'matched':
            matched.append(data)

    hobbies = []
    if len(share) > 0:
        hobbies.append(containerize("share", share))
    if len(discover) > 0:
        hobbies.append(containerize("discover", discover))
    if len(matched) > 0:
        hobbies.append(containerize("matched", matched))

    return hobbies


## @brief Helper function for building hobby data to containerise the categories.
# @param offer      The type of container - `(discover|share|matched)`
# @param hobbies    The list of hobbies that belong to this container.
# @return A contain object (python dictionary).
def containerize(offer, hobbies):
    return {
        'container': offer,
        'hobbies': hobbies
    }


## @brief Updates the users hobbies
# Deletes current hobbies and updates with the new hobbies.
# @param uid        The user id that we are updating
# @param request    The object sent from client containing their update.
def update_user_hobbies(uid, request):
    hobbies = request["hobbies"]
    for category in hobbies:
        db.get_db().execute(
            '''
            DELETE FROM user_hobbies
            WHERE user_id = %s
              AND swap = %s;
            ''', uid, category['container']
        )
        for hobby in category['hobbies']:
            db.get_db().execute(
                '''
                INSERT INTO user_hobbies (user_id, hobby_id, swap)
                VALUES (%s, %s, %s);
                ''', uid, hobby['id'], category['container']
            )


## @brief Retrieves the full list of hobbies from the db.
# This is of user selectable stored hobbies.
# @return A list of hobbies in dictionaries.
# @note This is not JSON. Convert to JSON with `jsonify()`
def get_hobby_list():
    try:
        rows = db.get_db().execute(
            '''
            SELECT * FROM hobbies ORDER BY name;
            '''
        )

        hobbies = []
        for row in rows:
            hobby = {
                "id": row['hobby_id'],
                "name": row["name"],
            }
            hobbies.append(hobby)

        hobbies_list = {
            'hobby_list': hobbies
        }
        return hobbies_list

    except Exception as e:
        raise IOError(str(e))


## @brief Retrieves the matched hobbies two users.
# @param uid    Your user id
# @param id     Their user id
# @returns A list of hobbies in containers from `build_hobby_data()`
def get_matched_hobbies(uid, id):
    try:
        rows = db.get_db().execute(
            '''
            SELECT DISTINCT(me.hobby_id), 'matched' AS swap, (
                SELECT name
                FROM hobbies
                WHERE me.hobby_id = hobbies.hobby_id
            )
            FROM user_hobbies me
                INNER JOIN user_hobbies you
                ON me.hobby_id = you.hobby_id
                AND me.swap != you.swap
            WHERE me.user_id = %s
            AND you.user_id = %s;
            ''', uid, id
        )
        return build_hobby_data(rows)
    except Exception as e:
        print(str(e))
        raise IOError(str(e))
