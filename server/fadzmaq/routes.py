## @file
# @brief The routes file containing the API entry points.
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au
# @author Jordan Russell        20357813@student.uwa.edu.au
# @author Thiren Naidoo         22257963@student.uwa.edu.au
# @author Beining Chen          22384298@student.uwa.edu.au

from flask import jsonify, request, Blueprint
import fadzmaq
from fadzmaq.database import profile, recs, matches, hobbies
from firebase_admin import auth
import json

route_bp = Blueprint("route_bp", __name__)

page_not_found = '''
        It appears you have come to the wrong place. <br>
        Please try out our mobile app, fadzmaq. <br>
        This site is <strong> not </strong> for users.
'''


@route_bp.route('/')
@route_bp.route('/index')
def index():
    return page_not_found, 308


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# USERS
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

## @brief The auth_required function decorator.
# This function is responsible for authenticating users.
# It checks the validity of their token. And makes sure they are recorded in the database.
# @param func   Function pointer to the decorated function.
# @return       The function pointer to the authenticate function.
# @exception    Returns `page_not_found` message to user and 404 error code.
def auth_required(func):
    def authenticate(*args, **kwargs):
        try:
            uid = verify_token()
            verify_user(uid=uid)
            return func(uid=uid, *args, **kwargs)
        except Exception as e:
            # Invalid token or user
            print('Authentication failed:', str(e))
            return page_not_found, 404

    authenticate.__name__ = func.__name__
    return authenticate


## @brief Verifies the authentication token.
# This validates the token using firebase's package and our service account signature.
# @param request.headers    The http headers must be available to retrieve the authentication token.
# @returns                  The user id.
# @throws ValueError        If authentication token is not valid.
def verify_token(): 
    if 'Authorization' not in request.headers:
        raise ValueError("Token not present")

    # Verifying the token, if it fails proceed to except block.
    token = request.headers['Authorization']
    decoded_token = auth.verify_id_token(token, fadzmaq.auth_app, False)
    uid = decoded_token['uid']
    print('Verified, UID:', uid)
    return uid


## @brief Verifies the user is in the database
# @param uid            The user ID from firebase
# @throws ValueError    If the user is not present in the database
def verify_user(uid):
    if not profile.verify_user(uid):
        raise ValueError("User does not exist")


## @brief Retrieves a users recommendations
# @returns A json formatted list of the users recommendations.
# @exception Returns 404 Page not found.
@route_bp.route('/user/recs', methods=['GET'])
@auth_required
def get_recommendations(uid):
    try:
        return jsonify(recs.get_recommendations(uid)), 200
    except ValueError as e:
        return page_not_found, 404


## @brief Retries a users profile by their id
# @warning This function is deprecated. Please do not use as it will not return useful data.
# The route has been left intact for future usage & backwards compatibility. Though we think it may be
# a security risk to allow access to all users profile data.
# @exception Returns 410 Deprecated.
@route_bp.route('/user/<string:id>', methods=['GET'])
@auth_required
def get_user_by_id(uid, id):
    print(uid)
    print(id)
    return "Deprecated", 410


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# PROFILE
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

## @brief Retrieves the current users profile
# @exception Returns 404 Page not found.
@route_bp.route('/profile', methods=['GET'])
@auth_required
def get_profile(uid):
    try:
        return jsonify(profile.retrieve_profile(uid)), 200
    except ValueError:
        return 'Profile not found', 404


## @brief Edits the current users profile
# @exception Returns 404 Page not found.
@route_bp.route('/profile', methods=['POST'])
@auth_required
def update_profile(uid):
    try:
        profile.update_profile(request, uid)
        return get_profile()
    except Exception as e:
        return page_not_found, 404


## @brief Route for updating user profiles.
# @exception Returns 404 Page not found.
@route_bp.route('/profile/hobbies', methods=['POST'])
@auth_required
def update_hobbies(uid):
    try:
        request_data = json.loads(request.get_data())
        hobbies.update_user_hobbies(uid, request_data)
        return "Success", 200
    except Exception as e:
        return page_not_found, 404

## @brief Updates a users location and device id.
# @exception Returns 404 Page not found.
@route_bp.route('/profile/ping', methods=['POST'])
@auth_required
def ping_location(uid):
    try:
        data = json.loads(request.get_data())
        loc = data['location']
        profile.set_location(uid, loc['lat'], loc['long'], data['device'])
        return 'Ping Set', 204
    except Exception as e:
        return page_not_found, 404


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# ACCOUNT
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

# @brief Creates a new account for a user if it does not already exist
# Creates a new account with the users firebase token for uid.
# Client must provide json containing the user 'name' and 'email'
# @returns  The user id of the new account.
# @exception Returns 500 account failed or 401 Auth failed.
@route_bp.route('/account', methods=['POST'])
def create_account():
    try:
        data = json.loads(request.get_data())
        user = data["new_user"]
        uid = verify_token() 
        user_id = profile.make_user(user['name'], user['email'], uid)
        return user_id
    except ValueError as e:
        print('Account creation failed ' + str(e))
        return 'Account creation failed ' + str(e), 500
    except Exception as e:
        print("Authentication failed: " + str(e))
        return "Authentication failed: " + str(e), 401


## @brief Allows users to delete their account.
# @exception Returns 404 Page not found.
# @warning This is **NOT** reversible.
@route_bp.route('/account', methods=['DELETE'])
@auth_required
def delete_account(uid):
    try:
        profile.delete_account(uid)
        return "Success", 204
    except Exception as e:
        return page_not_found, 404


## @brief Allows users to get their current settings
# @exception Returns 404 Page not found.
@route_bp.route('/account/settings', methods=['GET'])
@auth_required
def get_settings(uid):
    try:
        return jsonify(profile.retrieve_settings(uid)), 200
    except Exception as e:
        return page_not_found, 404

## @brief Allows users to update their settings.
# @exception Returns 404 Page not found.
@route_bp.route('/account/settings', methods=['POST'])
@auth_required
def update_settings(uid):
    try:
        data = json.loads(request.get_data())
        setting = data['distance_setting']
        print(setting)
        profile.update_settings(uid, setting)
        return 'Success', 204
    except Exception as e:
        return page_not_found, 404


# @brief Route for retrieving all current hobbies available.
# @exception Returns 404 Page not found.
@route_bp.route('/hobbies', methods=['GET'])
def get_hobbies():
    try:
        return jsonify(hobbies.get_hobby_list()), 200
    except Exception:
        return page_not_found, 404


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# MATCHES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

# @brief Retrieves the current matches of the user.
# @returns A json formatted list of the users current matches.
# @exception Returns 404 Page not found.
@route_bp.route('/matches', methods=['GET'])
@auth_required
def get_matches(uid):
    try:
        return jsonify(matches.get_matches(uid)), 200
    except ValueError as e:
        return page_not_found, 404


# @brief Retrieves a specific matches profile data.
# @exception Returns 404 Page not found.
@route_bp.route('/matches/<string:id>', methods=['GET'])
@auth_required
def get_matched_user(uid, id):
    try:
        return jsonify(matches.get_match_by_id(uid, id)), 200
    except ValueError as e:
        return page_not_found, 404


# @brief Un-matches a specific match by their user id
# @exception Returns 404 Page not found.
@route_bp.route('/matches/<string:id>', methods=['DELETE'])
@auth_required
def unmatch_user(uid, id):
    try:
        matches.unmatch(uid, id)
        return "User unmatched", 204
    except Exception as e:
        return page_not_found, 404


# @brief Rates a user negatively
# @exception Returns 404 Page not found.
@route_bp.route('/matches/thumbs/down/<string:id>', methods=['POST'])
@auth_required
def rate_user_down(uid, id):
    try:
        matches.rate_user(uid, id, 0)
        return "Thumbs down!", 204
    except Exception:
        return page_not_found, 404


# @brief Rates a user positively
# @exception Returns 404 Page not found.
@route_bp.route('/matches/thumbs/up/<string:id>', methods=['POST'])
@auth_required
def rate_user_up(uid, id):
    try:
        matches.rate_user(uid, id, 1)
        return "Thumbs up!", 204
    except Exception:
        return page_not_found, 404


# @brief Removes a user rating
# @exception Returns 404 Page not found.
@route_bp.route('/matches/thumbs/<string:id>', methods=['DELETE'])
@auth_required
def rate_user_delete(uid, id):
    try:
        matches.rate_user(uid, id, None)
        return "Removed", 204
    except Exception:
        return page_not_found, 404


# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##
# VOTES
# ------- ## ------- ## ------- ## ------- ## ------- ## ------- ##

# @brief Like a user
# @exception Returns 404 Page not found.
@route_bp.route('/like/<string:id>', methods=['POST'])
@auth_required
def like_user(uid, id):
    try:
        return recs.like_user(uid, id, True), 200
    except Exception:
        return page_not_found, 404


# @brief Pass on a user
# @exception Returns 404 Page not found.
@route_bp.route('/pass/<string:id>', methods=['POST'])
@auth_required
def pass_user(uid, id):
    try:
        recs.like_user(uid, id, False)
        return "User passed", 200
    except Exception:
        return page_not_found, 404
