import pytest
from fadzmaq.database.db import get_db, get_engine
import sqlalchemy

# Tests that the server is up at all.
# Code is 300 because we shouldn't be using index (I think?) - Jordan 
def test_index(client):
    response = client.get('/', follow_redirects=True)
    assert response.status_code == 300


# def test_database(client):
#     results = db.engine.execute('SELECT 1')
#     print(results.first())

def test_get_close_db(api):
    with api.app_context():
        db = get_db()
        assert db is get_db()

    with pytest.raises(sqlalchemy.exc.StatementError) as e:
        db.execute('SELECT 1')

    assert 'closed' in str(e.value)

# Tests the correct tables are present
def test_tables(api):
    with api.app_context():
        engine = get_engine()
        assert engine.dialect.has_table(engine, "primary_user")
        assert engine.dialect.has_table(engine, "hobbies")
        assert engine.dialect.has_table(engine, "matches")
        assert engine.dialect.has_table(engine, "votes")
  