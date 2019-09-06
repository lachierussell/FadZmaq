-- this script is for creating a new test database as well as a user with privileges for that test db
-- you will need to log in as root initially for this setup


-- drop everything and start again
DROP ROLE IF EXISTS test_fadzmaq_admin;
DROP DATABASE IF EXISTS fadzmaq_test;

-- do creation
CREATE DATABASE fadzmaq_test;

CREATE ROLE test_fadzmaq_admin WITH PASSWORD 'test_admin_pass' CREATEROLE CREATESCHEMA LOGIN;
GRANT ALL PRIVILEGES ON DATABASE "fadzmaq_test" TO test_fadzmaq_admin;


