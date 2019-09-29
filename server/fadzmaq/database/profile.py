import fadzmaq.database.connection as db
from fadzmaq.database.hobbies import get_hobbies


def update_profile(subject, uid):
    rows = db.get_db().execute(
        '''
        UPDATE profile
        SET nickname= %s, bio= %s, email= %s, phone= %s
        WHERE user_id= %s;
        ''', subject.values['nickname'], subject.values['bio'], subject.values['email'],
        subject.values['phone'], uid
    )


def build_profile_data(rows):
    for row in rows:
        profile = {
            'profile': {
                'user_id': row['user_id'],
                'name': row['nickname'],
                'age': str(row['age']),
                'photo_location': row['photo'],
                'contact_details': {
                    'phone': row['phone'],
                    'email': row['email']
                },
                'profile_fields': [
                    {
                        'id': 1,
                        'name': 'About me',
                        'display_value': row['bio']
                    }
                ],
                'hobbies': get_hobbies(row['user_id'])
            }
        }
        return profile
    raise ValueError("Did not find row")


# Retrieves profile information for the subject.
# @param    subject     user_id for the database entry
# @return   json profile data or raises value error.
def retrieve_profile(subject):
    # Retrieves user info.
    rows = db.get_db().execute(
        '''
        SELECT *, EXTRACT(year FROM age(current_date, dob)) :: INTEGER AS age 
        FROM profile 
        WHERE user_id = %s
        ''', subject
    )

    return build_profile_data(rows)


# @brief Verifies the user is in the database
# @returns True if the user exists
def verify_user(subject):
    rows = db.get_db().execute(
        '''
        SELECT COUNT(user_id)
        FROM profile
        WHERE user_id = %s;
        ''', subject
    )

    for row in rows:
        if row['count'] == 1:
            return True
    return False


# @brief Creates a user in the database
# @throws IOError if the user already exists or the database insertion fails.
def make_user(name, email, uid):
    rows = db.get_db().execute(
        '''
        INSERT INTO profile (nickname, email, user_id) VALUES (%s, %s, %s) RETURNING user_id;
        ''', name, email, uid
    )
    for row in rows:
        print(str(row['user_id']))
        return str(row['user_id'])
    print('IOErro: No Rows')
    raise IOError

