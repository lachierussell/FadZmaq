@echo on
start /wait /B pipenv install --dev
start /wait /B pipenv run coverage run -m pytest
start /wait /B pipenv run coverage report
timeout -1