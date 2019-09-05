import pytest

from fadzmaq import create_app


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

def test_index(client):
    response = client.get('/')
    assert b"matches" in response.data


