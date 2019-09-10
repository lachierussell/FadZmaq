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
import requests



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


# @route_bp.route('/auth', methods=['POST'])
def authentication(token):
    # token = request.get_data()
    try:
        # Verifying the token, if it fails proceed to except block.
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']
        if not db.verify_user(uid):
            raise ValueError
        return uid

    except ValueError:
        # Invalid token
        err = 'Invalid token 404'
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
