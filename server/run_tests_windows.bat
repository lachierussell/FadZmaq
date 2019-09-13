@echo on
start /wait /B pipenv install --dev
start /wait /B pipenv run coverage run -m pytest --tb=short
start /wait /B pipenv run coverage report
start /wait /B pipenv run coverage html
timeout -1