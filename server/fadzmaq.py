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

app = create_app()
cred = firebase_admin.credentials.Certificate(app.config['CERT'])
fadzmaq.auth_app = firebase_admin.initialize_app(cred)


# only run if we are executing this script, otherwise handled by WSGI
if __name__ == "__main__":
    app.run()
