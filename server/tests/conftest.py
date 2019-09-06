import pytest

from fadzmaq import create_app
from fadzmaq import database

from fadzmaq.database.db import get_db

@pytest.fixture
def api():

    api = create_app({
        'TESTING': True,
    })

    with api.app_context():
        get_db()

    yield api


@pytest.fixture
def client(api):
    """A test client for the app."""
    return api.test_client()





