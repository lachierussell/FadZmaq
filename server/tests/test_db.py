import pytest
from fadzmaq.database.db import get_db
from fadzmaq.database import db

def test_retrieve_profile(api):
    with api.app_context():
        db.retrieve_profile(1)

def test_get_hobbies(api):
    with api.app_context():
        db.get_hobbies(1)




