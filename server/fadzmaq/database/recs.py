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
            "matched":[],
        }


    ########################################################


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
