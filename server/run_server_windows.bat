@echo on
start /wait /B pipenv install --dev
SET FLASK_APP=fadzmaq.py
REM start /wait /B pipenv run flask run
start /wait /B pipenv run python fadzmaq.py
timeout -1