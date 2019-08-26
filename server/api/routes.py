from api import api

@api.route('/')
@api.route('/index')
def index():
    return "Hello, World!"