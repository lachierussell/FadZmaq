from flask import Flask
from fadzmaq import database
from fadzmaq.database import db
from fadzmaq.routes import route_bp

# Initialisation of the api
def create_app(config=None):

    api = Flask(__name__)

    # conn = database.connection
    # users = conn.execute("SELECT * FROM primary_user;")
    # for user in users:
    #     print(user)
    # conn.close()

    if config["TESTING"] == True:
        api.config.update(config)
        api.config.from_pyfile("test.cfg", silent=True)
    else:
        api.config.from_pyfile("fadzmaq.cfg", silent=True)


    db.init_app(api)
    
    api.register_blueprint(route_bp)
    

    return api