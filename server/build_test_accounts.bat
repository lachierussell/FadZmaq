REM @file
REM
REM FadZmaq Project
REM Professional Computing. Semester 2 2019
REM
REM Copyright FadZmaq © 2019      All rights reserved.
REM @author Jordan Russell        20357813@student.uwa.edu.au

@echo on
start /wait /B pipenv install --dev
start /wait /B pipenv run python build_test_users.py 5
timeout -1