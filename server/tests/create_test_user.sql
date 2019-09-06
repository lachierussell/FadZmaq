DROP ROLE IF EXISTS test_fadzmaq_app;

CREATE ROLE test_fadzmaq_app WITH LOGIN PASSWORD 'test_fadzmaq_pass';


GRANT SELECT, UPDATE, INSERT, DELETE ON matches TO test_fadzmaq_app;
GRANT SELECT, UPDATE, INSERT, DELETE ON votes TO test_fadzmaq_app;
GRANT SELECT, UPDATE, INSERT, DELETE ON hobbies TO test_fadzmaq_app;