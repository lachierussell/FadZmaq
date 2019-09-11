# @file
# @brief
# fadzmaq.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Jordan Russell    [email]


# entry point for the api
from fadzmaq import create_app
import fadzmaq
import firebase_admin
from firebase_admin import credentials

app = create_app()

# only run if we are executing this script, otherwise handled by WSGI
if __name__ == "__main__":

    app.run()
