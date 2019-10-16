REM @file
REM
REM FadZmaq Project
REM Professional Computing. Semester 2 2019
REM
REM Copyright FadZmaq © 2019      All rights reserved.
REM @author Jordan Russell        20357813@student.uwa.edu.au

@echo off
type database\build_database.sql database\init.sql tests\build_test.sql database\init.sql tests\create_test_user.sql> temp.sql
start /wait /B psql -U postgres -f temp.sql
del temp.sql
timeout -1