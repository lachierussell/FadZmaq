# A makefile to simplify the running of tests and the server

RUN = pipenv run python

run: 
	${RUN} fadzmaq.py

users: database
	${RUN} build_test_users.py 500

test: database
	${RUN} -m pytest

database: database/init.sql database/build_database.sql
	cat database/build_database.sql database/init.sql \
		tests/build_test.sql database/init.sql tests/create_test_user.sql > temp.sql
	psql -U postgres -f temp.sql

