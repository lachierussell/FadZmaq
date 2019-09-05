DROP ROLE IF EXISTS server_fadzmaq_role;

CREATE ROLE server_fadzmaq_role;

GRANT SELECT, UPDATE, INSERT, DELETE ON primary_user TO server_fadzmaq_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON matches TO server_fadzmaq_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON votes TO server_fadzmaq_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON hobbies TO server_fadzmaq_role;