DROP ROLE IF EXISTS test_fadzmaq_app;

CREATE ROLE test_fadzmaq_app WITH LOGIN PASSWORD 'test_fadzmaq_pass' IN ROLE server_fadzmaq_role;

