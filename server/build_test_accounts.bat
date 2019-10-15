@echo off
set /P num=Enter number of users: 
start /wait /B pipenv install --dev
start /wait /B pipenv run python build_test_users.py %num% 
timeout -1