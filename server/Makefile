# @file
# @brief A makefile to simplify the running of tests and the server
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

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

