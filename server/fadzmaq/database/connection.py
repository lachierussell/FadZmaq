## @file
# @brief Establishes and maintains database connection state.
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au


from flask import current_app, g
from sqlalchemy import create_engine
import fadzmaq


## @brief Removes any existing connections from the application context.
def init_app(app):
    app.teardown_appcontext(close_db)


## @brief Creates a database engine to interface with the database
# This does not connect to the database but builds an sqlalchemy engine and maintains it in the context.
# The database configuration and credentials are taken from a configuration file.
# @warning Do not hard code credentials in the configuration file. It is possible to configure this to use
# cloud keychains or even local keychains rather than accepting a raw password.
def get_engine():
    if fadzmaq.engine is None:
        print("new engine")
        fadzmaq.engine = create_engine(current_app.config['DATABASE_URI'])
    return fadzmaq.engine


## @brief Connects to the database if not already.
def get_db():
    if 'db' not in g:
        g.db = connect_db()
    return g.db


## @brief Closes the database connection.
def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()


## @brief Makes the connection call to the database.
def connect_db():
    return get_engine().connect()
