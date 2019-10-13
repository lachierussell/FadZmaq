@echo on
start /wait /B pipenv install --dev
start /wait /B pipenv run python build_test_users.py 5
timeout -1