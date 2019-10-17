# @file
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Jordan Russell        jordanrussell@live.com

import random
import string
import fadzmaq.database.connection as db

from tests.random_account_data import female_name_list
from tests.random_account_data import male_name_list
from tests.random_account_data import female_photo_list
from tests.random_account_data import male_photo_list
from tests.random_account_data import bio_paragraph_list

from tests.random_account_db import make_user_test
from tests.random_account_db import update_user_hobbies
from tests.random_account_db import get_hobby_list
from tests.random_account_db import set_location

engine = None
connection = None
db_cred = "empty"


def make_random_accounts(num, cred):
    global db_cred
    db_cred = cred
    print("Cred2: " + db_cred)
    for i in range(num):
        make_random_account()


def make_random_account():

    is_female = random.choice([True, False])

    uid = random_id()
    name = random_name(is_female)
    email = random_email(name)
    photo = random_photo(is_female)
    bio = random_bio()

    # db stuff
    make_user_test(name, email, uid, photo, bio)
    update_user_hobbies(uid, random_hobby_request())
    set_location(uid, random_lat(), random_long())

    print("added: " + name + " - " + uid)


def random_id():
    characters = string.ascii_letters + string.digits
    return 'testaccount' + ''.join(random.choice(characters) for i in range(15))


email_domains = [
    "@live.com",
    "@gmail.com",
    "@hotmail.com", 
]


def random_email(name):
    return name + ''.join(random.choice(string.digits) for i in range(4)) + random.choice(email_domains)


# to do implment
def random_phone():
    return '042'.join(random.choice(string.digits) for i in range(7))

# todo bio
def random_bio():
    number = random.choice([1, 2, 2, 2, 3, 3, 4])
    bio = ""
    for i in range(number):
        bio = bio + random.choice(bio_paragraph_list) + "\n\n"

    bio = (bio[:400]) if len(bio) > 400 else bio

    return bio

def random_name(is_female):
    if is_female:
        return random.choice(female_name_list)
    else:
        return random.choice(male_name_list)


def random_photo(is_female):
    if is_female:
        return random.choice(female_photo_list)
    else:
        return random.choice(male_photo_list)


def random_hobby(all_hobby_list):
    return random.choice(all_hobby_list)


def random_hobbies(all_hobby_list):
    # weight towards 3 and 4
    number = random.choice([1, 2, 3, 3, 3, 4, 4, 5])
    hobby_list = []
    for i in range(number):
        hob = random_hobby(all_hobby_list)
        if hob not in hobby_list:
            hobby_list.append(hob)

    return hobby_list


def random_hobby_request():

    all_hobby_list = get_hobby_list()['hobby_list']

    share_list = {
        'container': 'share',
        'hobbies': random_hobbies(all_hobby_list),
    }

    discover_list = {
        'container': 'discover',
        'hobbies': random_hobbies(all_hobby_list),
    }

    hobbies_list = {
        'hobbies': [share_list, discover_list]
    }

    return hobbies_list


# Random coordinates around perth
def random_lat():
    return round(random.uniform(-31.67, -32.17), 2)


def random_long():
    return round(random.uniform(115.75, 116.00), 2)
