import pytest

from fadzmaq import create_app
from fadzmaq import database

from fadzmaq.database.db import get_db

from sqlalchemy import create_engine
import sqlalchemy

@pytest.fixture
def api():

    api = create_app({
        'TESTING': True,
    })

    build_test_db(api)

    yield api

    teardown_test_db(api)



@pytest.fixture
def client(api):
    """A test client for the app."""
    return api.test_client()

    

def build_test_db(api):
    engine = create_engine(api.config['DATABASE_TEST_ADMIN'])

    execute_sql(engine, "fadzmaq/database/init.sql")
    execute_sql(engine, "tests/create_test_user.sql")
    

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
    sqlFile = fd.read()
    sqlCommands = sqlFile.split(";")

    for command in sqlCommands:
        try:
            connection.execute(command)
        except sqlalchemy.exc.ProgrammingError as e:
            if "query was empty" not in str(e):
                print(str(e))

    connection.close()
    fd.close()
