# @file
# @brief        The api specification.
# fadzmaq/routes.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
import firebase_admin
from flask import jsonify, request, Blueprint
import fadzmaq
from fadzmaq.api import recs_data, match_data
from fadzmaq.database import db
from firebase_admin import auth
import json

route_bp = Blueprint("route_bp", __name__)


@route_bp.route('/')
@route_bp.route('/index')
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

# Login decorator
def auth_required(func):
    def authenticate(*args, **kwargs):
        try:
            uid = verify_token()
            verify_user(uid=uid)
            return func(uid=uid, *args, **kwargs)
        except Exception as e:
            # Invalid token or user
            print('Authentication failed:', str(e))
            uid = 'hello'
            return func(uid=uid, *args, **kwargs)
            # Replace above return with below when in production
            # return 'Authentication failed: ' + str(e), 401

    authenticate.__name__ = func.__name__
    return authenticate


def verify_token():
    if 'Authorization' not in request.headers:
        raise ValueError("Token not present")

    # Verifying the token, if it fails proceed to except block.
    token = request.headers['Authorization']
    print('Attempting to verify token:', token)
    decoded_token = auth.verify_id_token(token, fadzmaq.auth_app, False)
    uid = decoded_token['uid']
    print('Verified, UID:', uid)
    return uid


def verify_user(uid):
    if not db.verify_user(uid):
        raise ValueError("User does not exist")


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
    try:
        data = json.loads(request.get_data())
        user = data["new_user"]

        uid = verify_token()
        user_id = db.make_user(user['name'], user['name'], uid)
        return user_id
    except Exception as e:
        return 'Account creation failed ' + str(e), 500


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# MATCHES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

@route_bp.route('/matches', methods=['GET'])
@auth_required
def get_matches(uid):
    # TODO: Get subject from auth
    print(request.get_data())
    try:
        return db.get_matches(uid), 200
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
