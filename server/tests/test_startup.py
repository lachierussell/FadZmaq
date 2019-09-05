import pytest

# Tests that the server is up at all.
# Code is 300 because we shouldn't be using index (I think?) - Jordan 
def test_index(client):
    response = client.get('/', follow_redirects=True)
    assert response.status_code == 300


def test_database(db):
    results = db.engine.execute('SELECT 1')
    print(results.first())


# Tests the correct tables are present
def test_tables(db):

    assert db.engine.dialect.has_table(db.engine, "primary_user")
    assert db.engine.dialect.has_table(db.engine, "hobbies")
    assert db.engine.dialect.has_table(db.engine, "matches")
    assert db.engine.dialect.has_table(db.engine, "votes")
  