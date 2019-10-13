@echo off
type database\build_database.sql database\init.sql tests\build_test.sql database\init.sql tests\create_test_user.sql> temp.sql
start /wait /B psql -U postgres -f temp.sql
del temp.sql
timeout -1