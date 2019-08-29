from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from sqlalchemy import *

DATABASE_URI= 'postgres+psycopg2cffi://lachlanrussell:[PASSWORD]@localhost:5432/fadzmaq'
engine = create_engine(DATABASE_URI)
Session_factory = sessionmaker(bind=engine)
Base = declarative_base()


def session_factory():
    Base.metadata.create_all(engine)
    return Session_factory()

from database import person
