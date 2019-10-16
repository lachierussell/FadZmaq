REM @file
REM
REM FadZmaq Project
REM Professional Computing. Semester 2 2019
REM
REM Copyright FadZmaq © 2019      All rights reserved.
REM @author Jordan Russell        20357813@student.uwa.edu.au

@echo on
start /wait /B pipenv install --dev
SET FLASK_APP=fadzmaq.py
REM start /wait /B pipenv run flask run
start /wait /B pipenv run python fadzmaq.py
timeout -1