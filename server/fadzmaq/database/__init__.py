# @file
# @brief        The entry point to our database models.
# database/__init__.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# This is the entry point to our database package. It establishes the connection with the
# database and initiates a session.
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
from sqlalchemy import create_engine

# from fadzmaq.database import db_conf, db
# from database import db_conf, db
from . import db_conf, db

engine = create_engine(db_conf.DATABASE_URI)
connection = engine.connect()
