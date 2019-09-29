# @file
# @brief
# tests/test_db.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Jordan Russell    [email]

import pytest
from fadzmaq.database.matches import get_db, get_engine
from fadzmaq.database import matches
import sqlalchemy
import json


# Tests the correct tables are presentu
def test_tables(api):
    with api.app_context():
        engine = get_engine()
        assert engine.dialect.has_table(engine, "hobbies")
        assert engine.dialect.has_table(engine, "matches")
        assert engine.dialect.has_table(engine, "profile")
        assert engine.dialect.has_table(engine, "user_hobbies")
        assert engine.dialect.has_table(engine, "votes")


# Checks that the connection is closed outside the flask context
def test_get_close_db(api):
    with api.app_context():
        db = get_db()
        assert db is get_db()

    with pytest.raises(sqlalchemy.exc.StatementError) as e:
        db.execute('SELECT 1')

    assert 'closed' in str(e.value)

# these don't work and crash the db engine for some reason
# tested elsewhere anyway

# # Only tests that the sql command can be executed
# # We still need to check the data is accurate
#def test_retrieve_profile(api):
#   with api.app_context():
#       db.retrieve_profile('26ab0db90d72e28ad0ba1e22ee510510')
#
# #Only tests that the sql command can be executed
# #We still need to check the data is accurate
#def test_get_hobbies(api):
#    with api.app_context():
#        db.get_hobbies('26ab0db90d72e28ad0ba1e22ee510510')
