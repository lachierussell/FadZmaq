-- @file
--
-- FadZmaq Project
-- Professional Computing. Semester 2 2019
--
-- This script builds our database schema and uploads it with dummy values.
--
-- Copyright FadZmaq © 2019      All rights reserved.
-- @author Jordan Russell        20357813@student.uwa.edu.au

-- Who is using the database in case it can't be properly refreshed
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
DROP DATABASE IF EXISTS fadzmaq;

-- do creation
CREATE DATABASE fadzmaq;

SELECT current_database();

-- connect to new DB
\c fadzmaq

SELECT current_database();