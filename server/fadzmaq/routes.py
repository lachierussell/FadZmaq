# @file
# @brief        The api specification.
# fadzmaq/routes.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
import json

from flask import jsonify, request, Flask, Blueprint
from fadzmaq.api import recs_data, match_data, profile_data
from fadzmaq.database import db
from pip._vendor import requests

route_bp = Blueprint("route_bp", __name__)


@route_bp.route('/')
@route_bp.route('/index')
def index():

    # conn = db.connect_db()
    # users = conn.execute("SELECT * FROM primary_user;")
    # conn.close()

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


@route_bp.route('/auth', methods=['POST'])
def authentication():
    # (Receive token by HTTPS POST)
    # TODO: Get actual google token (speak with Seharsh)



    # TODO: Send json data to client app

    # (Does that mean that we have to stringify the data?)
    def stringify():
        databaselist = {
            "/user/recs": "Get recommendations",
            "/user/`id`": "Get user profile",
            "/profile": "Get your own profile information",
            "/matches": "Get a list of matches",
            "/matches/`id`": "Get profile information of a single match"
        }
        print(json.dumps(databaselist), 300)
        # As it said on https://www.webucator.com/how-to/how-send-receive-json-data-from-the-server.cfm
        # sending json string to the client should be as the response body
        # Is it how it works??
        url = '0000000'  # needs database url
        # https://stackoverflow.com/questions/6386308/http-requests-and-json-parsing-in-python/6386366
        response = requests.get(url=url, databaselist=databaselist)
        data = response.json()

    token = request.get_data()
    token = jwt.decode(token, verify=False)
    print(token)
    try:
        # Verifying the token, if it fails proceed to except block.
        idinfo = id_token.verify_oauth2_token(token, requests.Request())
        print(idinfo['name'])

        # TODO: make a database query -- later
        #found this web may be helpful
        #https://www.google.com/search?rlz=1C1CHBF_en-GBAU783AU783&biw=1366&bih=625&sxsrf=ACYBGNTj9xbd13MOsvbZqAAMUoG0asexIA%3A1567945873643&ei=kfR0Xa-AJ9vgrQG44bDABw&q=make+a+database+query+in+python&oq=make+a+database+query+in+python&gs_l=psy-ab.3...7779.7779..8015...0.1..0.218.218.2-1......0....1..gws-wiz.......0i71._XUm7LjZ_jg&ved=0ahUKEwjvjM3GncHkAhVbcCsKHbgwDHg4ChDh1QMICw&uact=5

        # Will need to be a query to the database.
        # if idinfo['aud'] not in ['CLIENT_ID_1', 'CLIENT_ID_2', 'CLIENT_ID_3']:
        #     raise ValueError('Could not verify audience.')

        if idinfo['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise ValueError('Wrong issuer.')

        # ID token is valid. Get the user's Google Account ID from the decoded token.
        userid = idinfo['sub']
        return userid

    except ValueError:
        # Invalid token
        # TODO: Return unauthorised error code
        userid != idinfo['sub']
        err = 'Invalid token 404'
        print(err)
        return err


@route_bp.route('/user/recs', methods=['GET'])
def recommendations():
    return jsonify(recs_data.my_recs), 200


@route_bp.route('/user/<string:id>', methods=['GET'])
def get_user_by_id(id):
    return jsonify(recs_data.my_candiate), 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# PROFILE
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##


@route_bp.route('/profile', methods=['GET'])
def get_profile():
    # TODO: Send to authenticate function and return sub id.
    # print(request.headers['auth'])

    # TODO: Clean and retrieve inputs.
    subject = 1  # Temp value.

    try:
        return db.retrieve_profile(subject), 200

    except ValueError:
        return '{"error":"Profile not found."}', 404


@route_bp.route('/profile', methods=['POST'])
def update_profile():
    user = request.form['somedata']
    response = {
        "status": user
    }
    return jsonify(response), 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# MATCHES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##


@route_bp.route('/matches', methods=['GET'])
def get_matches():
    return jsonify(match_data.my_matches), 200


@route_bp.route('/matches/<string:id>', methods=['GET'])
def get_matched_user(id):
    return jsonify(match_data.my_match), 200


@route_bp.route('/matches/<string:id>', methods=['DELETE'])
def unmatch_user(id):
    return "User unmatched", 200


@route_bp.route('/matches/thumbs/down/<string:id>', methods=['POST'])
def rate_user_down(id):
    return "Thumbs down!", 200


@route_bp.route('/matches/thumbs/up/<string:id>', methods=['POST'])
def rate_user_up(id):
    return "Thumbs up!", 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# VOTES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##


@route_bp.route('/like/<string:id>', methods=['POST'])
def like_user(id):
    return "User liked", 200


@route_bp.route('/pass/<string:id>', methods=['POST'])
def pass_user(id):
    return "User passed", 200
