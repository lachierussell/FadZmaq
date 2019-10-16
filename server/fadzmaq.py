# @file
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
# @author Jordan Russell        20357813@student.uwa.edu.au
# @author Thiren Naidoo         22257963@student.uwa.edu.au
# @author Beining Chen          22384298@student.uwa.edu.au

# entry point for the api
from fadzmaq import create_app
import fadzmaq
import firebase_admin
from sqlalchemy import create_engine

app = create_app()
cred = firebase_admin.credentials.Certificate(app.config['CERT'])
fadzmaq.auth_app = firebase_admin.initialize_app(cred)

fadzmaq.engine = create_engine(app.config['DATABASE_URI'])


# only run if we are executing this script, otherwise handled by WSGI
if __name__ == "__main__":
    app.run()
