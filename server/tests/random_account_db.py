from sqlalchemy import create_engine
from tests import random_account_gen 


def get_engine():
    if random_account_gen.engine is None:
        # print("new engine")
        print("engine: " + random_account_gen.db_cred)
        random_account_gen.engine = create_engine(random_account_gen.db_cred)
    return random_account_gen.engine


def get_db():
    if random_account_gen.connection is None:
        # print("new connection")
        random_account_gen.connection = connect_db()
    return random_account_gen.connection


def connect_db():
    return get_engine().connect()


def close_db():
    if random_account_gen.connection is not None:
        # print("close connection")
        random_account_gen.connection.close()
        random_account_gen.connection = None


def make_user_test(name, email, uid, photo):
    rows = get_db().execute(
        '''
        INSERT INTO profile (nickname, email, user_id, photo) VALUES (%s, %s, %s, %s) RETURNING user_id;
        ''', name, email, uid, photo
    )
    close_db()
    for row in rows:
        # print(str(row['user_id']))
        return str(row['user_id'])
    print('IOError: No Rows')
    raise IOError

def get_hobby_list():
    try:
        rows = get_db().execute(
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
        close_db()
        return hobbies_list

    except Exception as e:
        raise IOError(str(e))

# @brief Updates the users hobbies
# Deletes current hobbies and updates with the new hobbies.
def update_user_hobbies(uid, request):
    hobbies = request["hobbies"]
    for category in hobbies:
        get_db().execute(
            '''
            DELETE FROM user_hobbies
            WHERE user_id = %s
              AND swap = %s;
            ''', uid, category['container']
        )
        for hobby in category['hobbies']:
            get_db().execute(
                '''
                INSERT INTO user_hobbies (user_id, hobby_id, swap)
                VALUES (%s, %s, %s);
                ''', uid, hobby['id'], category['container']
            )
    close_db()

def set_location(uid, lat, long):
    get_db().execute(
        '''
        INSERT INTO location_data (user_id, lat, long) VALUES (%s, %s, %s)
        ''', uid, float(lat), float(long)
    )
    close_db()
