# @file
# @brief        The main entry point of the application.
# fadzmaq.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# This is the main entry point of the application.
# Run the application through this file.
# Please view the README, INSTALL, and LICENSE before using this project.
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Lachlan Russell       22414249@student.uwa.edu.au

from flask import Flask
from api import api

if __name__ == '__main__':
    api.run()

