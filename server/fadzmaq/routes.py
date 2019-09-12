# @file
# @brief        The api specification.
# fadzmaq/routes.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

from flask import jsonify, request, Blueprint
from fadzmaq.api import recs_data, match_data
from fadzmaq.database import db
from firebase_admin import auth
import firebase_admin
import json

route_bp = Blueprint("route_bp", __name__)
cred = firebase_admin.credentials.Certificate("/Users/lachlanrussell/Developer/UNI/fadzmaq1-firebase-adminsdk-78gsi"
                                              "-b01a0a6212.json")
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

# Login decorator
def auth_required(func):
    def verify_token(*args, **kwargs):
        try:
            if 'Authorization' not in request.headers:
                raise ValueError("Token not present")

            # Verifying the token, if it fails proceed to except block.
            token = request.headers['Authorization']
            print('Attempting to verify token:', token)
            decoded_token = auth.verify_id_token(token, auth_app, False)
            uid = decoded_token['uid']
            print('Verified, UID:', uid)

            if not db.verify_user(uid):
                raise ValueError("User does not exist")
            return func(uid=uid, *args, **kwargs)

        except ValueError as e:
            # Invalid token
            print('Authentication failed:', str(e))
            uid = 'hello'
            return func(uid=uid, *args, **kwargs)
            # Replace above return with below when in production
            # return 'Authentication failed: ' + str(e), 401
    verify_token.__name__ = func.__name__
    return verify_token


@route_bp.route('/user/recs', methods=['GET'])
@auth_required
def recommendations(uid):
    print(uid)
    return jsonify(recs_data.my_recs), 200


@route_bp.route('/user/<string:id>', methods=['GET'])
@auth_required
def get_user_by_id(uid, id):
    print(uid)
    print(id)
    return jsonify(recs_data.my_candiate), 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# PROFILE
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@route_bp.route('/profile', methods=['GET'])
@auth_required
def get_profile(uid):
    # TODO: Send to authenticate function and return sub id.
    # print(request.headers['auth'])

    # TODO: Clean and retrieve inputs.
    uid = 1  # Temp value.

    try:
        return db.retrieve_profile(uid), 200

    except ValueError:
        return '{"error":"Profile not found"}', 404


@route_bp.route('/profile', methods=['POST'])
@auth_required
def update_profile(uid):
    response = request.get_data()
    return response, 200


@route_bp.route('/account', methods=['POST'])
def create_account():
    data = json.loads(request.get_data())
    user = data["new_user"]
    if 'Authorization' not in request.headers:
        return 'Token not present', 401

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
@auth_required
def get_matches(uid):
    # TODO: Get subject from auth
    print(request.get_data())
    subject = int(request.get_data())
    try:
        return db.get_matches(subject), 200
    except ValueError:
        return '{"error":"Internal server error"}', 404


@route_bp.route('/matches/<string:id>', methods=['GET'])
@auth_required
def get_matched_user(uid, id):
    return jsonify(match_data.my_match), 200


@route_bp.route('/matches/<string:id>', methods=['DELETE'])
@auth_required
def unmatch_user(uid, id):
    return "User unmatched", 200


@route_bp.route('/matches/thumbs/down/<string:id>', methods=['POST'])
@auth_required
def rate_user_down(uid, id):
    return "Thumbs down!", 200


@route_bp.route('/matches/thumbs/up/<string:id>', methods=['POST'])
@auth_required
def rate_user_up(uid, id):
    return "Thumbs up!", 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# VOTES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@route_bp.route('/like/<string:id>', methods=['POST'])
@auth_required
def like_user(uid, id):
    return "User liked", 200


@route_bp.route('/pass/<string:id>', methods=['POST'])
@auth_required
def pass_user(uid, id):
    return "User passed", 200


class UnauthorizedError(Exception):
    pass


class UnknownUserError(Exception):
    pass
