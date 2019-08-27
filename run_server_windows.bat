@echo on
cd ./server/
start /wait /B pipenv install --dev
start /wait /B pipenv run python fadzmaq.py