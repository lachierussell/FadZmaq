import fadzmaq.database.connection as db


# Retrieves the user hobbies
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
        WHERE profile.user_id = '{}';
        '''.format(subject)
    )
    return build_hobby_data(rows)


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


def containerize(offer, hobbies):
    return {
        'container': offer,
        'hobbies': hobbies
    }


# @brief Updates the users hobbies
# Deletes current hobbies and updates with the new hobbies.
def update_user_hobbies(uid, request):
    try:
        hobbies = request["hobbies"]
        for category in hobbies:
            db.get_db().execute(
                '''
                DELETE FROM user_hobbies
                WHERE user_id = '{}'
                  AND swap = '{}';
                '''.format(uid, category['container'])
            )
            for hobby in category['hobbies']:
                db.get_db().execute(
                    '''
                    INSERT INTO user_hobbies (user_id, hobby_id, swap)
                    VALUES ('{}', {}, '{}');
                    '''.format(uid, hobby['id'], category['container'])
                )
    except Exception as e:
        raise IOError(str(e))


# @brief Retrieves the full list of hobbies from the db.
def get_hobby_list():
    try:
        rows = db.get_db().execute(
            '''
            SELECT * FROM hobbies;
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
                WHERE me.user_id = '{}'
                AND you.user_id = '{}';
            '''.format(uid, id)
        )
        return build_hobby_data(rows)
    except Exception as e:
        print(str(e))
        raise IOError(str(e))
