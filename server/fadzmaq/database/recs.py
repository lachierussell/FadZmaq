import fadzmaq.database.connection as db
from fadzmaq.api.notifications import notify_match


def like_user(uid, id, vote):
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
        return {"match": True}
    return {"match": False}
