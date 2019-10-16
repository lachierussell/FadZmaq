REM @file
REM
REM FadZmaq Project
REM Professional Computing. Semester 2 2019
REM
REM Copyright FadZmaq © 2019      All rights reserved.
REM @author Jordan Russell        jordanrussell@live.com

@echo on
start /wait /B pipenv install --dev
start /wait /B pipenv run coverage run -m pytest --tb=short
start /wait /B pipenv run coverage report
start /wait /B pipenv run coverage html
timeout -1