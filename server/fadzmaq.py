
# entry point for the api
from fadzmaq import create_app
app = create_app()

# only run if we are executing this script, otherwise handled by WSGI
if __name__ == "__main__":
    app.run()


