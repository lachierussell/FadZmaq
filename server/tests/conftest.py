# @file
# @brief
# tests/conftest.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Jordan Russell    [email]

import pytest

from fadzmaq import create_app
from sqlalchemy import create_engine
import sqlalchemy
import os

@pytest.fixture
def api_no_db():

    api = create_app({
        'TESTING': True,
    })

    yield api


@pytest.fixture
def api(api_no_db):

    # rebuild the database for each test
    build_test_db(api_no_db)

    yield api_no_db

    # drop all tables - just in case some scripts rely on remnet tables
    teardown_test_db(api_no_db)


@pytest.fixture
def client_no_db(api_no_db):
    return api.test_client()


@pytest.fixture
def client(api):
    """A test client for the app."""
    return api.test_client()

    
def build_test_db(api):
    engine = create_engine(api.config['DATABASE_TEST_ADMIN'])

    os.system('psql -q psql.log -U postgres -d fadzmaq -f fadzmaq/database/init.sql')
    os.system('psql -q -U test_fadzmaq_admin -d fadzmaq_test -f fadzmaq/database/init.sql')

    # execute_sql(engine, "fadzmaq/database/init.sql")
    # execute_sql(engine, "tests/create_test_user.sql")
    

def teardown_test_db(api):
    engine = create_engine(api.config['DATABASE_TEST_ADMIN'])

    # Load the existing tables into sqlalchemy's meta
    meta = sqlalchemy.MetaData()
    meta.reflect(engine)
    # drop all tables
    con = engine.connect()
    meta.drop_all(con)

    # Drop the test fadzmaq app user
    execute_sql(engine, "tests/drop_roles.sql")


def execute_sql(engine, file):
    connection = engine.connect()
    fd = open(file, "r")
    sql_file = fd.read()
    sql_commands = sql_file.split(";")

    for command in sql_commands:
        try:
            connection.execute(command)
        except sqlalchemy.exc.ProgrammingError as e:
            if "query was empty" not in str(e):
                print(str(e))

    connection.close()
    fd.close()
