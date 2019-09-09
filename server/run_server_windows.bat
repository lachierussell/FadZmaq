@echo on
start /wait /B pipenv install --dev
SET FLASK_APP=fadzmaq.py
start /wait /B pipenv run flask run
timeout -1