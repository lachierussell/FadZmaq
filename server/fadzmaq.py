# @file
# @brief        The main entry point of the application.
# fadzmaq.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# This is the main entry point of the application.
# Run the application through this file.
# Please view the README, INSTALL, and LICENSE before using this project.
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

from flask import Flask
from sqlalchemy.ext.declarative import declarative_base

from api import api
from sqlalchemy.orm import sessionmaker
from sqlalchemy import *
from database import person
import database


if __name__ == '__main__':

    session = database.Session_factory()
    # lachie = person.Person(5, 'lachie')
    # josh = person.Person(7, 'josh')

    # session.add(lachie)
    # session.add(josh)
    #
    # session.commit()

    users = session.query(person.Person).all()

    for user in users:
        print(f'{user.first_name} has id {user.user_id}')

    session.close()

    # api.run()



