@echo on
start /wait /B psql -U postgres -c "CREATE DATABASE fadzmaq"
start /wait /B psql -U postgres -d fadzmaq -f fadzmaq/database/init.sql
timeout -1