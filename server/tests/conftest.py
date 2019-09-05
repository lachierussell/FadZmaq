import pytest

from fadzmaq import create_app
from fadzmaq import database

@pytest.fixture
def api():

    api = create_app({
        'TESTING': True,
    })

    yield api


@pytest.fixture
def client(api):
    """A test client for the app."""
    return api.test_client()

@pytest.fixture
def db():
    """A test connection to the database"""
    return database



