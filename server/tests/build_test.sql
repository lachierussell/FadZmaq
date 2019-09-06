-- this script is for creating a new test database as well as a user with privileges for that test db
-- you will need to log in as root initially for this setup

select pid as process_id, 
       usename as username, 
       datname as database_name, 
       client_addr as client_address, 
       application_name,
       backend_start,
       state,
       state_change
from pg_stat_activity;

-- drop everything and start again
DROP DATABASE IF EXISTS fadzmaq_test;
DROP ROLE IF EXISTS test_fadzmaq_admin;


-- do creation
CREATE DATABASE fadzmaq_test;

CREATE ROLE test_fadzmaq_admin WITH PASSWORD 'test_admin_pass' CREATEROLE LOGIN;
GRANT ALL PRIVILEGES ON DATABASE "fadzmaq_test" TO test_fadzmaq_admin;


