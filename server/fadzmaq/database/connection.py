# @file
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au


from flask import current_app, g
from sqlalchemy import create_engine
import fadzmaq


def init_app(app):
    app.teardown_appcontext(close_db)


def get_engine():
    if fadzmaq.engine is None:
        print ("new engine")
        fadzmaq.engine = create_engine(current_app.config['DATABASE_URI'])
    return fadzmaq.engine


def get_db():
    if 'db' not in g:
        g.db = connect_db()
    return g.db


def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()


def connect_db():
    return get_engine().connect()
