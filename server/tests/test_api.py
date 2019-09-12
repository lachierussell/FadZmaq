# @file
# @brief
# test/test_api.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Jordan Russell    [email]

import json


# Tests that the server is up at all.
# Code is 300 because we shouldn't be using index (I think?) - Jordan 
def test_index(client):
    response = client.get('/', follow_redirects=True)
    assert response.status_code == 300


def test_user_request(client):
    response = client.get('/user/recs', follow_redirects=True)
    assert response.status_code == 200


def test_user_request_by_id(client):
    response = client.get('/user/1234', follow_redirects=True)
    assert response.status_code == 200


# Basic test the profile API
# To be expanded when we receive data from DB -Jordan
def test_profile(client):

    # Check we get a response
    response = client.get('/profile', follow_redirects=True)
    assert response.status_code == 404
    #
    # data = json.loads(response.data)
    # assert "profile" in data
    # profile = data["profile"]
    #
    # assert "name" in profile
    # assert "age" in profile


def test_profile_post(client):
    post_data = dict(somedata='data')
    response = client.post('/profile', data=post_data, follow_redirects=True)
    assert response.status_code == 200


def test_matches(client):
    response = client.get('/matches', follow_redirects=True)
    assert response.status_code == 200


def test_match_request_by_id(client):
    response = client.get('/matches/1234', follow_redirects=True)
    assert response.status_code == 200


def test_match_delete_by_id(client):
    response = client.delete('/matches/1234', follow_redirects=True)
    assert response.status_code == 200


def test_match_thumb_down(client):
    response = client.post('/matches/thumbs/down/1234', follow_redirects=True)
    assert response.status_code == 200


def test_match_thumb_up(client):
    response = client.post('/matches/thumbs/up/1234', follow_redirects=True)
    assert response.status_code == 200


def test_like(client):
    response = client.post('/like/1234', follow_redirects=True)
    assert response.status_code == 200


def test_pass(client):
    response = client.post('/pass/1234', follow_redirects=True)
    assert response.status_code == 200
