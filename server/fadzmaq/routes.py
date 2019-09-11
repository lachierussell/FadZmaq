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
from firebase_admin import auth
import firebase_admin
import requests
import objectpath

route_bp = Blueprint("route_bp", __name__)
cred = firebase_admin.credentials.Certificate("/Users/lachlanrussell/Developer/UNI/fadzmaq1-firebase-adminsdk-78gsi-b01a0a6212.json")
auth_app = firebase_admin.initialize_app(cred)


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

# @route_bp.route('/auth', methods=['POST'])
def authentication(token):
    # token = request.get_data()
    try:
        print('try')
        # Verifying the token, if it fails proceed to except block.
        decoded_token = auth.verify_id_token(token, auth_app, False)
        print('verified')
        uid = decoded_token['uid']
        print(uid)
        if not db.verify_user(uid):
            raise UnknownUserError(uid)
        return uid

    except ValueError:
        # Invalid token
        raise UnauthorizedError('Invalid Token')


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
        return '{"error":"Profile not found"}', 404


@route_bp.route('/profile', methods=['POST'])
def update_profile():
    response = request.get_data()
    return response, 200


@route_bp.route('/account', methods=['POST'])
def create_account():
    data = json.loads(request.get_data())
    user = data["new_user"]
    if 'Authorization' not in request.headers:
        return 'Token not present', 403

    try:
        uid = authentication(request.headers['Authorization'])

    except UnknownUserError as e:
        uid = str(e)
    except UnauthorizedError:
        return 'Account creation failed', 401

    try:
        user_id = db.make_user(user['name'], user['name'], uid)
        return user_id
    except Exception:
        return 'Account creation failed', 500


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# MATCHES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@route_bp.route('/matches', methods=['GET'])
def get_matches():
    # TODO: Get subject from auth
    print(request.get_data())
    subject = int(request.get_data())
    try:
        return db.get_matches(subject), 200
    except ValueError:
        return '{"error":"Internal server error"}', 404


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


class UnauthorizedError(Exception):
    pass


class UnknownUserError(Exception):
    pass
