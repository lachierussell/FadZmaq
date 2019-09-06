import pytest
from fadzmaq.database.db import get_db, get_engine
import sqlalchemy
from fadzmaq import create_app


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
        assert engine.dialect.has_table(engine, "hobbies")
        assert engine.dialect.has_table(engine, "matches")
        assert engine.dialect.has_table(engine, "profile")
        assert engine.dialect.has_table(engine, "user_hobbies")
        assert engine.dialect.has_table(engine, "votes")
  