from tests import random_account_gen
import sys
from sqlalchemy import create_engine
from flask import Flask


def main():

    if len(sys.argv) < 2:
        print("Usage: build_test_users [number of users] ")
        return

    num = sys.argv[1]

    api = Flask(__name__)
    api.config.from_pyfile("fadzmaq/fadzmaq.conf", silent=False)
    db_cred = api.config.get('DATABASE_URI')
    print("Cred: "+ db_cred)

    
    random_account_gen.make_random_accounts(int(num), db_cred)


if __name__ == "__main__":
    main()

    
    