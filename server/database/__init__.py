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

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import *

from database import db_conf
from database import person

engine = create_engine(db_conf.DATABASE_URI)
Session_factory = sessionmaker(bind=engine)
Base = declarative_base()


def session_factory():
    Base.metadata.create_all(engine)
    return Session_factory()
