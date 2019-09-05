# @file
# @brief        The api specification.
# fadzmaq.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# The main application. It specifies the wsgi routes, and begins the running of the application.
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

from flask import jsonify, request, Flask
from api import recs_data, match_data, profile_data
from database import db
import json

api = Flask(__name__)


@api.route('/')
@api.route('/index')
def index():
    response = {
        "/user/recs": "Get recommendations",
        "/user/`id`": "Get user profile",
        "/profile": "Get your own profile information",
        "/matches": "Get a list of matches",
        "/matches/`id`": "Get profile information of a single match"
    }
    return jsonify(response), 300

# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# USERS
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@api.route('/user/recs', methods=['GET'])
def recommendations():
    return jsonify(recs_data.my_recs), 200


@api.route('/user/<string:id>', methods=['GET'])
def get_user_by_id(id):
    return jsonify(recs_data.my_candiate), 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# PROFILE
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@api.route('/profile', methods=['GET'])
def get_profile():
    # TODO: Send to authenticate function and return sub id.
    # print(request.headers['auth'])

    # TODO: Clean and retrieve inputs.
    subject = 1  # Temp value.

    try:
        return db.retrieve_profile(subject), 200

    except ValueError:
        return '{"error":"Profile not found."}', 404


# Possible cant be used for change settings
@api.route('/profile', methods=['POST'])
def update_profile():
    user = request.form['somedata']
    response = {
        "status": user
    }
    return jsonify(response), 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# MATCHES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@api.route('/matches', methods=['GET'])
def get_matches():
    return jsonify(match_data.my_matches), 200


@api.route('/matches/<string:id>', methods=['GET'])
def get_matched_user(id):
    return jsonify(match_data.my_match), 200


@api.route('/matches/<string:id>', methods=['DELETE'])
def unmatch_user(id):
    return "User unmatched", 200


@api.route('/matches/thumbs/down/<string:id>', methods=['POST'])
def rate_user_down(id):
    return "Thumbs down!", 200


@api.route('/matches/thumbs/up/<string:id>', methods=['POST'])
def rate_user_up(id):
    return "Thumbs up!", 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# VOTES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@api.route('/like/<string:id>', methods=['POST'])
def like_user(id):
    return "User liked", 200


@api.route('/pass/<string:id>', methods=['POST'])
def pass_user(id):
    return "User passed", 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# MAIN APPLICATION
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

if __name__ == '__main__':

    data = json.loads(get_profile()[0])
    print(json.dumps(data, indent=2))


    # api.run()