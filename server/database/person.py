from sqlalchemy import Column, String, Integer, Date
from . import Base


class Person(Base):
    __tablename__ = 'person'

    user_id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String)

    def __init__(self, id, name):
        self.first_name = name
        self.user_id = id

