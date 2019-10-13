-- this script is for creating a new test database as well as a user with privileges for that test db
-- you will need to log in as root initially for this setup

SELECT pid AS process_id,
       usename AS username,
       datname AS database_name,
       client_addr AS client_address,
       application_name,
       backend_start,
       state,
       state_change
FROM pg_stat_activity;

-- drop everything and start again
DROP DATABASE IF EXISTS fadzmaq_test ;

-- do creation
CREATE DATABASE fadzmaq_test;

SELECT current_database();
-- SET ROLE test_fadzmaq_admin;
\c fadzmaq_test
SELECT current_database();



