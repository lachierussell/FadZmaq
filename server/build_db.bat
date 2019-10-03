@echo off
type fadzmaq\database\build_database.sql fadzmaq\database\init.sql tests\build_test.sql fadzmaq\database\init.sql tests\create_test_user.sql> temp.sql
start /wait /B psql -U postgres -f temp.sql
del temp.sql
timeout -1