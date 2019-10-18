REM @file
REM
REM FadZmaq Project
REM Professional Computing. Semester 2 2019
REM
REM Copyright FadZmaq © 2019      All rights reserved.
REM @author Jordan Russell        jordanrussell@live.com

@echo off
set /P num=Enter number of users: 
start /wait /B pipenv install --dev
start /wait /B pipenv run python build_test_users.py %num% 
timeout -1