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
import fadzmaq

from fadzmaq import create_app
from sqlalchemy import create_engine
import sqlalchemy
import fadzmaq.database.connection as dbc
import os


# from flask import current_app

# def get_test_admin_engine(app):
#     if fadzmaq.test_engine is None:
#         print ("new test engine")
#         # fadzmaq.test_engine = create_engine('postgresql+pg8000://test_fadzmaq_admin:test_admin_pass@localhost/fadzmaq_test')
#         fadzmaq.test_engine = create_engine(app.config['DATABASE_TEST_ADMIN'])
#     return fadzmaq.test_engine


@pytest.fixture
def api_no_db(mocker):

    mocker.patch("fadzmaq.routes.verify_token", return_value="26ab0db90d72e28ad0ba1e22ee510510")
    # mocker.patch("fadzmaq.db.get_engine", return_value = get_test_engine)

    api = create_app({
        'TESTING': True,
    })

    yield api_no_db


@pytest.fixture
def api(mocker):

    mocker.patch("fadzmaq.routes.verify_token", return_value="26ab0db90d72e28ad0ba1e22ee510510")
    # mocker.patch("fadzmaq.db.get_engine", return_value = get_test_engine)

    api = create_app({
        'TESTING': True,
    })

    # rebuild the database for each test
    # build_test_db(api)

    yield api

    # drop all tables - just in case some scripts rely on remnet tables
    # teardown_test_db(api)


@pytest.fixture
def client_no_db(api_no_db):
    return api.test_client()


@pytest.fixture
def client(api):
    """A test client for the app."""
    return api.test_client()

    
# def build_test_db(api):
#     # engine = create_engine(api.config['DATABASE_TEST_ADMIN'])

#     # os.system('PGPASSWORD=test_admin_pass psql -q -U test_fadzmaq_admin -d fadzmaq_test -f fadzmaq/database/init.sql')
#     # os.system('PGPASSWORD=test_admin_pass psql psql -q -U test_fadzmaq_admin -d fadzmaq_test -f tests/create_test_user.sql')

#     # os.system('psql -q psql.log -U postgres -d fadzmaq -f fadzmaq/database/init.sql')
#     # os.system('psql -q -U test_fadzmaq_admin -d fadzmaq_test -f fadzmaq/database/init.sql')

#     execute_sql(get_test_admin_engine(api), "fadzmaq/database/init.sql")
#     execute_sql(get_test_admin_engine(api), "tests/create_test_user.sql")
    

# def teardown_test_db(api):
#     # engine = create_engine(api.config['DATABASE_TEST_ADMIN'])

#     # Load the existing tables into sqlalchemy's meta
#     meta = sqlalchemy.MetaData()
#     meta.reflect(get_test_admin_engine(api))
#     # drop all tables
#     con = get_test_admin_engine(api).connect()
#     meta.drop_all(con)
#     con.close()

#     # Drop the test fadzmaq app user
#     execute_sql(get_test_admin_engine(api), "tests/drop_roles.sql")


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
