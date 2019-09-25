# @file
# @brief
# fadzmaq/__init__.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Jordan Russell       [email]


from flask import Flask
from fadzmaq.database import db
from fadzmaq.routes import route_bp

auth_app = None
engine = None
test_engine = None


# Initialisation of the api
def create_app(config=None):

    api = Flask(__name__)

    if config is not None and config["TESTING"]:
        api.config.update(config)
        api.config.from_pyfile("test.conf", silent=True)
    else:
        api.config.from_pyfile("fadzmaq.conf", silent=True)

    db.init_app(api)
    api.register_blueprint(route_bp)

    return api
