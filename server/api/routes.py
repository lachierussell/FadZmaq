from time import sleep
from flask import jsonify, request
from api import api
from api import match_data, recs_data, profile_data
import json

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


@api.route('/user/recs', methods=['GET'])
def recommendations():
    return jsonify(recs_data.my_recs), 200


@api.route('/user/<string:id>', methods=['GET'])
def get_user_by_id(id):
    return jsonify(recs_data.my_candiate), 200


@api.route('/profile', methods=['GET'])
def get_profile():
    return jsonify(profile_data.my_profile), 200


@api.route('/profile', methods=['POST'])
def update_profile():
    user = request.form['somedata']
    response = {
        "status": user
    }
    return jsonify(response), 200


@api.route('/matches', methods=['GET'])
def get_matches():
    return jsonify(match_data.my_matches), 200


@api.route('/matches/<string:id>', methods=['GET'])
def get_matched_user(id):
    return jsonify(match_data.my_match), 200


@api.route('/matches/<string:id>', methods=['DELETE'])
def unmatch_user(id):
    return "User unmatched", 200


@api.route('/like/<string:id>', methods=['POST'])
def like_user(id):
    return "User liked", 200


@api.route('/pass/<string:id>', methods=['POST'])
def pass_user(id):
    return "User passed", 200
