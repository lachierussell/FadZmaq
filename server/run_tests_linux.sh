pipenv install --dev
pipenv run coverage run -m pytest
pipenv run coverage report
pipenv run coverage html