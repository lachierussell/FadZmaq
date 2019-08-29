# @file
# @brief        TEMPORARY TEST FILE FOR ORM MODELS
# fadzmaq.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

from sqlalchemy import Column, String, Integer, Date
from . import Base


class Person(Base):
    __tablename__ = 'person'

    user_id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String)

    def __init__(self, id, name):
        self.first_name = name
        self.user_id = id

