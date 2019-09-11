# @file
# @brief
# fadzmaq.py
#
# FadZmaq Project
# Professional Computing. Semester 2 2019
#
# Copyright FadZmaq © 2019      All rights reserved.
# @author Jordan Russell    [email]


# entry point for the api
from fadzmaq import create_app
import fadzmaq
import firebase_admin
from firebase_admin import credentials

app = create_app()

# only run if we are executing this script, otherwise handled by WSGI
if __name__ == "__main__":
    # print(
    #     fadzmaq.routes.authentication('eyJhbGciOiJSUzI1NiIsImtpZCI6IjU0ODZkYTNlMWJmMjA5YzZmNzU2MjlkMWQ4MzRmNzEwY2EzMDlkNTAiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiSm9yZGFuIFJ1c3NlbGwiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FBdUU3bUJfZ1JMdExwODJuczNhMHZCSGpFM1hiZUFUdXVCa0g1TFM3dTFsb21nPXM5Ni1jIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL2ZhZHptYXExIiwiYXVkIjoiZmFkem1hcTEiLCJhdXRoX3RpbWUiOjE1NjgxOTYxNTcsInVzZXJfaWQiOiJPUWV6WVV3RkMyUDJKT1A4MW5pY1FSNHFaUkIzIiwic3ViIjoiT1FlellVd0ZDMlAySk9QODFuaWNRUjRxWlJCMyIsImlhdCI6MTU2ODE5NjE1NywiZXhwIjoxNTY4MTk5NzU3LCJlbWFpbCI6ImpvcmRhc2hydXNzZWxsQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTA5OTk5NjQ4ODc2MDg5OTQ4NTA0Il0sImVtYWlsIjpbImpvcmRhc2hydXNzZWxsQGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6Imdvb2dsZS5jb20ifX0.Bo1QPWq0eR5rBQvzoBYTyszHTogUGUI2eld2Tvi-cdjpPHuox1T2P2J860Jq1ZJ_JuFYJBIkCi7mRgviD5R-uz5KwAgKryh45a6jGzluI-A3binx6tiCJS-3mD7nrSdGXCvm2orwI7SLYz91qI6_iJ0iBioJ5iFAsLG8whZvNTRWqPQYu8WF5ZtE0fB-D5POheVECb4VZXu1fLngmLljeieDsyORMFbKV6FhNe7FQBhjdcB0oTPfyrhjQxT-XnS0uLNifGigbPApf83mkOly_9NUQR8jy9R6hzmGYICm9URtxnibLFVkcfYvr-QA5BGpEHX-nA1z9jBdbXRMyQle0g')
    # )

    app.run()
