from flask import Flask
from fadzmaq import database
from fadzmaq.database import db
from fadzmaq.routes import route_bp

# Initialisation of the api
def create_app(test_config=None):

    api = Flask(__name__)

    # conn = database.connection
    # users = conn.execute("SELECT * FROM primary_user;")
    # for user in users:
    #     print(user)
    # conn.close()

    db.init_app(api)
    
    api.register_blueprint(route_bp)
    

    return api