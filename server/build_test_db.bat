@echo on
start /wait /B psql -U postgres -f tests/build_test.sql
timeout -1
