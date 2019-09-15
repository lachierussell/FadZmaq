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
import fadzmaq
from fadzmaq.api import recs_data
from fadzmaq.database import db
from firebase_admin import auth
import json

route_bp = Blueprint("route_bp", __name__)


@route_bp.route('/')
@route_bp.route('/index')
def index():
    response = '''
        It appears you have come to the wrong place. <br>
        Please try out our mobile app, fadzmaq. <br>
        This website is <strong> not </strong> for users.
    '''
    return response, 308


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# USERS
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

# @brief The auth_required function decorator.
# This function is responsible for authenticating users.
# It checks the validity of their token. And makes sure they are recorded in the database.
# If the user is not authenticated this will return the error as a string, and unauthorized http code.
# @param func   Function pointer to the decorated function.
# @return       The function pointer to the authenticate function.
def auth_required(func):
    def authenticate(*args, **kwargs):
        try:
            uid = verify_token()
            verify_user(uid=uid)
            return func(uid=uid, *args, **kwargs)
        except Exception as e:
            # Invalid token or user
            print('Authentication failed:', str(e))
            uid = '26ab0db90d72e28ad0ba1e22ee510510'
            return func(uid=uid, *args, **kwargs)
            # Replace above return with below when in production
            # return 'Authentication failed: ' + str(e), 401

    authenticate.__name__ = func.__name__
    return authenticate


# @brief Verifies the authentication token.
# This validates the token using firebase's package and our service account signature.
# @param request.headers    The http headers must be available to retrieve the authentication token.
# @returns                  The user id.
# @throws ValueError        If authentication token is not valid.
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


# @brief Verifies the user is in the database
# @param uid            The user ID from firebase
# @throws ValueError    If the user is not present in the database
#
def verify_user(uid):
    if not db.verify_user(uid):
        raise ValueError("User does not exist")


# @brief Retrieves user recommendations
@route_bp.route('/user/recs', methods=['GET'])
@auth_required
def recommendations(uid):
    print(uid)
    return jsonify(recs_data.my_recs), 200


# @brief Retries a users profile by their id
@route_bp.route('/user/<string:id>', methods=['GET'])
@auth_required
def get_user_by_id(uid, id):
    print(uid)
    print(id)
    return jsonify(recs_data.my_candiate), 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# PROFILE
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##


# @brief Retrieves the current users profile
@route_bp.route('/profile', methods=['GET'])
@auth_required
def get_profile(uid):
    try:
        return db.retrieve_profile(uid), 200
    except ValueError:
        return 'Profile not found', 204


# @brief Edits the current users profile
# TODO: USE JSON
@route_bp.route('/profile', methods=['POST'])
@auth_required
def update_profile(uid):
    try:
        db.update_profile(request, uid)
        return get_profile
    except Exception as e:
        return "Profile edit failed " + str(e), 500


# @brief Route for updating user profiles.
@route_bp.route('/profile/hobbies', methods=['POST'])
@auth_required
def update_hobbies(uid):
    try:
        response = json.loads(request.get_data())
        db.update_user_hobbies(uid, response)
        return "Success", 200
    except IOError as e:
        return "Update hobbies failed " + str(e), 500


# @brief Route for retrieving all current hobbies available.
@route_bp.route('/hobbies', methods=['GET'])
def get_hobbies():
    return jsonify(db.get_hobby_list()), 200


# @brief Creates a new account for a user if it does not already exist
# Creates a new account with the users firebase token for uid.
# Client must provide json containing the user 'name' and 'email'
# @returns  The user id of the new account.
@route_bp.route('/account', methods=['POST'])
def create_account():
    try:
        data = json.loads(request.get_data())
        user = data["new_user"]
        uid = verify_token()
        user_id = db.make_user(user['name'], user['email'], uid)
        return user_id
    except Exception as e:
        print(json.dumps(data, indent=4))
        print('Account creation failed ' + str(e))
        return 'Account creation failed ' + str(e), 500


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# MATCHES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

# @brief Retrieves the current matches of the user.
# @returns A json formatted list of the users current matches.
@route_bp.route('/matches', methods=['GET'])
@auth_required
def get_matches(uid):
    # TODO: Get subject from auth
    print(request.get_data())
    try:
        return db.get_matches(uid), 200
    except ValueError:
        return '{"error":"Internal server error"}', 404


# @brief Retrieves a specific matches profile data
@route_bp.route('/matches/<string:id>', methods=['GET'])
@auth_required
def get_matched_user(uid, id):
    try:
        response = db.get_match_by_id(uid, id)
        return response, 200
    except ValueError as e:
        return 'Failed: ' + str(e), 400


# @brief Un-matches a specific match by their user id
@route_bp.route('/matches/<string:id>', methods=['DELETE'])
@auth_required
def unmatch_user(uid, id):
    return "User unmatched", 200


# @brief Rates a user negatively
@route_bp.route('/matches/thumbs/down/<string:id>', methods=['POST'])
@auth_required
def rate_user_down(uid, id):
    return "Thumbs down!", 200


# @brief Rates a user positively
@route_bp.route('/matches/thumbs/up/<string:id>', methods=['POST'])
@auth_required
def rate_user_up(uid, id):
    return "Thumbs up!", 200


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# VOTES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

# @brief Like a user
@route_bp.route('/like/<string:id>', methods=['POST'])
@auth_required
def like_user(uid, id):
    return "User liked", 200


# @brief Pass on a user
@route_bp.route('/pass/<string:id>', methods=['POST'])
@auth_required
def pass_user(uid, id):
    return "User passed", 200
