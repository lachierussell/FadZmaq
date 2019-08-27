from time import sleep
from api import api
from flask import jsonify
import json

@api.route('/')
@api.route('/index')
def index():
    return "Hello, World!"


@api.route('/user/recs', methods=['GET'])
def recommendations():
    response = {
        "results": [
            {
                "user": {
                    "user_id": "obff5b362880e65951fa731ae4925d063daffc71a4adec7ab",
                    "name": "Michaela",
                    "age": 20,
                    "gender": 2,
                    "profile_fields": [
                        {
                            "id": 1,
                            "name": "Work",
                            "display_value": "Curtin University"
                        },
                        {
                            "id": 2,
                            "name": "Location",
                            "display_value": "Sorrento"
                        },
                        {
                            "id": 3,
                            "name": "About me",
                            "display_value": "Like a bit of everything, into netball and scuba diving!"
                        }
                    ],
                    "hobbies": [
                        {
                            "swap": [
                                {
                                    "id": 5,
                                    "name": "Scuba Diving"
                                },
                                {
                                   "id": 99,
                                   "name": "Netball"
                                }
                            ]
                        },
                        {
                            "discover": [
                                {
                                    "id": 5,
                                    "name": "Scuba Diving"
                                },
                                {
                                    "id": 99,
                                    "name": "Netball"
                                },
                                {
                                    "id": 20,
                                    "name": "Road Cycling"
                                }
                            ]
                        }
                    ]
                }
            },
            {
                "user": {
                    "user_id": "obff5b362880e65951fa731ae4925d063daffc71a4adec7ab",
                    "name": "Michaela",
                    "age": 20,
                    "gender": 2,
                    "profile_fields": [
                        {
                            "id": 1,
                            "name": "Work",
                            "display_value": "Curtin University"
                        },
                        {
                            "id": 2,
                            "name": "Location",
                            "display_value": "Sorrento"
                        },
                        {
                            "id": 3,
                            "name": "About me",
                            "display_value": "Like a bit of everything, into netball and scuba diving!"
                        }
                    ],
                    "hobbies": [
                        {
                            "swap": [
                                {
                                    "id": 5,
                                    "name": "Scuba Diving"
                                },
                                {
                                    "id": 99,
                                    "name": "Netball"
                                }
                            ]
                        },
                        {
                            "discover": [
                                {
                                    "id": 5,
                                    "name": "Scuba Diving"
                                },
                                {
                                    "id": 99,
                                    "name": "Netball"
                                },
                                {
                                    "id": 20,
                                    "name": "Road Cycling"
                                }
                            ]
                        }
                    ]
                }
            }
        ]
    }
    return jsonify(response), 200


# @api.route('/user/<int:id>', methods=['GET'])
# def
#
# @api.route('')
# def
#
# @api.route('')
# def

