# A makefile to simplify the running of tests and the server

RUN = pipenv run python

run: 
	${RUN} fadzmaq.py

test: database
	${RUN} -m pytest


database:
	cat fadzmaq/database/build_database.sql fadzmaq/database/init.sql \
		tests/build_test.sql fadzmaq/database/init.sql tests/create_test_user.sql > temp.sql
	-@psql -U postgres -f temp.sql
	rm temp.sql



