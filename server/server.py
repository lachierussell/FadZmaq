#! /usr/bin/env python3

from backend import backend
from flask import Flask

if __name__ == '__main__':
    app = Flask(__name__)
    app.run()
