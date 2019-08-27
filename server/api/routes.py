from time import sleep
from api import api
from flask import jsonify, request
import json

my_profile = {
        "profile": {
            "user_id": "6c18ec1127d5a8951265f35c66b60f82",
            "name": "Joshua",
            "age": 25,
            "gender": 0,
            "photo_location": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg",
            "contact_details": {
                "phone": "0423 161 368",
                "email": "joshua.smith@gmail.com"
            },
            "profile_fields": [
                {
                    "id": 7,
                    "name": "Location",
                    "display_value": "Duncraig",
                    "distance": 0,
                    "lat": 55.7558,
                    "long": 37.6173
                },
                {
                    "id": 3,
                    "name": "About me",
                    "display_value": "I am a boxer. Lets get in the ring."
                }
            ],
            "hobbies": [
                {
                    "share": [
                        {
                            "id": 33,
                            "name": "Boxing"
                        }
                    ]
                },
                {
                    "discover": [
                        {
                            "id": 99,
                            "name": "Netball"
                        }
                    ]
                }
            ]
        }
    }
my_recs = {
        "results": [
            {
                "user": {
                    "user_id": "f1bd8af2a28adbf70af43cfc6d79ef95",
                    "name": "Michaela",
                    "age": 20,
                    "gender": 1,
                    "photo_location": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg",
                    "profile_fields": [
                        {
                            "id": 2,
                            "name": "Location",
                            "display_value": "Sorrento",
                            "distance": 8
                        },
                        {
                            "id": 3,
                            "name": "About me",
                            "display_value": "Like a bit of everything, into netball and scuba diving!"
                        }
                    ],
                    "hobbies": [
                        {
                            "share": [
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
                    "user_id": "6c18ec1127d5a8951265f35c66b60f82",
                    "name": "Joshua",
                    "age": 25,
                    "gender": 0,
                    "photo_location": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg",
                    "profile_fields": [
                        {
                            "id": 7,
                            "name": "Location",
                            "display_value": "Duncraig",
                            "distance": 3
                        },
                        {
                            "id": 3,
                            "name": "About me",
                            "display_value": "I am a boxer. Lets get in the ring."
                        }
                    ],
                    "hobbies": [
                        {
                            "share": [
                                {
                                    "id": 33,
                                    "name": "Boxing"
                                }
                            ]
                        },
                        {
                            "discover": [
                                {
                                    "id": 99,
                                    "name": "Netball"
                                }
                            ]
                        }
                    ]
                }
            },
            {
                "user": {
                    "user_id": "857a7932ce146081c59d2ba659a506f4",
                    "name": "Jody",
                    "age": 23,
                    "gender": 2,
                    "photo_location": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg",
                    "profile_fields": [
                        {
                            "id": 5,
                            "name": "Location",
                            "display_value": "Duncraig",
                            "distance": 3
                        },
                        {
                            "id": 3,
                            "name": "About me",
                            "display_value": "Chill and looking for hobby buddies."
                        }
                    ],
                    "hobbies": [
                        {
                            "share": [
                                {
                                    "id": 12,
                                    "name": "Rock climbing"
                                }
                            ]
                        },
                        {
                            "discover": [
                                {
                                    "id": 12,
                                    "name": "Rock climbing"
                                }
                            ]
                        }
                    ]
                }
            }
        ]
    }
my_candiate = {
                "user": {
                    "user_id": "f1bd8af2a28adbf70af43cfc6d79ef95",
                    "name": "Michaela",
                    "age": 20,
                    "gender": 1,
                    "photo_location": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg",
                    "profile_fields": [
                        {
                            "id": 2,
                            "name": "Location",
                            "display_value": "Sorrento",
                            "distance": 8
                        },
                        {
                            "id": 3,
                            "name": "About me",
                            "display_value": "Like a bit of everything, into netball and scuba diving!"
                        }
                    ],
                    "hobbies": [
                        {
                            "share": [
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
my_match = {
        "match": {
            "user_id": "6c18ec1127d5a8951265f35c66b60f82",
            "name": "Joshua",
            "age": 25,
            "gender": 0,
            "photo_location": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg",
            "contact_details": {
                "phone": "0423 161 368",
                "email": "joshua.smith@gmail.com"
            },
            "profile_fields": [
                {
                    "id": 7,
                    "name": "Location",
                    "display_value": "Duncraig",
                    "distance": 0,
                },
                {
                    "id": 3,
                    "name": "About me",
                    "display_value": "I am a boxer. Lets get in the ring."
                }
            ],
            "hobbies": [
                {
                    "share": [
                        {
                            "id": 33,
                            "name": "Boxing"
                        }
                    ]
                },
                {
                    "discover": [
                        {
                            "id": 99,
                            "name": "Netball"
                        }
                    ]
                }
            ]
        }
    }

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
    return jsonify(my_recs), 200


@api.route('/user/<string:id>', methods=['GET'])
def get_user_by_id(id):
    return jsonify(my_candiate), 200


@api.route('/profile', methods=['GET'])
def get_profile():
    return jsonify(my_profile), 200


@api.route('/profile', methods=['POST'])
def update_profile():
    user = request.form['somedata']
    response = {
        "status": user
    }
    return jsonify(response), 200


@api.route('/matches', methods=['GET'])
def get_matches():
    response = {
        "matches": [
            {
                "id": "6c18ec1127d5a8951265f35c66b60f82",
                "name": "Joshua",
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg"
            },
            {
                "id": "2ff8557a16f674e466ee4ae619f22758",
                "name": "Mike",
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/John_Legend_2019_by_Glenn_Francis.jpg/1280px-John_Legend_2019_by_Glenn_Francis.jpg"
            }
        ]
    }
    return jsonify(response), 200


@api.route('/matches/<string:id>', methods=['GET'])
def get_matched_user(id):
    return jsonify(my_match), 200


@api.route('/like/<string:id>', methods=['POST'])
def like_user(id):
    return "success", 200


@api.route('/pass/<string:id>', methods=['POST'])
def pass_user(id):
    return "success", 200
