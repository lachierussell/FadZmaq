# import pytest

# import fadzmaq


# @pytest.fixture
# def client():
#     # db_fd, flaskr.app.config['DATABASE'] = tempfile.mkstemp()
#     # flaskr.app.config['TESTING'] = True
#     client = fadzmaq.api.test_client()

#     # with fadzmaq.app.app_context():
#         # fadzmaq.init_db()

#     yield client

#     # os.close(db_fd)
#     # os.unlink(fadzmaq.app.config['DATABASE'])

# # def init_test_db():
# #     """Clear existing data and create new tables."""
# #     db = get_db()

# #     with current_app.open_resource('schema.sql') as f:
# #         db.executescript(f.read().decode('utf8'))    


# def test_index(client):
#     # rv = client.get('/');
#     # assert 'matches' in rv.data

#     response = client.get('/', follow_redirects=True)
#     client.assertEqual(response.status_code, 200)

import unittest
import fadzmaq
from fadzmaq import fadzmaq

class MyTestCase(unittest.TestCase):
    def test_something(self):
        self.asserEqual(True,False)
        fadzmaq.get_profile()

if __name__ == '__main__':
    unittest.main()
