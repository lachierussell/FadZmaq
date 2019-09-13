# INSTALL

This document outlines the steps required to install the server. While many steps are common across unix and windows there are many differences which we attempt to outline.

## Preface

To differentiate unix and windows commands, code blocks will be marked with different languages as such.

Unix: `sh` 

```sh
$	echo "This is a unix shell"
```

Windows: `powershell`

```powershell
#	Write-Host "This is a powershell"
```

Cross platform: `pseudocode`

```pseudocode
%   python3 -c "print('hello world')"       
```

## Installing pipenv

It is a requirement to run this project that python3.7 is already installed. Pip3 is often installed with python, though you may need to acquire this separately. There are sufficient tutorials online specific to your system. 

First, navigate to the project directory.

```
CITS3200/
	\_ client/
	 \_server/		# Pipenv should be initialied inside the server directory.
```

 Then to install pipenv simply run in a terminal:

```sh
$	pip3 install pipenv
$   pipenv install --dev
```

```powershell
#	pip install pipenv
#	pipenv install --dev
```

This will install all of the dependancies specified in the `Pipfile` and create a new file, `Pipfile.lock`. You should never edit the `Pipfile.lock` file.

## Setting up the database

To use the server it is necessary to have an instance of PostgreSQL 9.6. Once you have installed PostgreSQL you can configure the database by running. Be careful: These scripts create the main database under the user postgres. 

```sh
$	./build_db.sh
$ 	./build_test_db.sh
```

```powershell
#	./build_db.bat
#	./build_test_db.bat
```

The main database is named fadzmaq and is owned by user postgres

The testing database is named fadzmaq_test and is owned by user test_fadzmaq_admin

## Installing firebase

The firebase authentication package will have been installed with during the installation of pipenv. Firebase requires a service account private key to verify the authenticity of the tokens being sent to the server. This is easy to obtain on the firebase console.

1. On the left of the console, click the cog.

2. Navigate to project settings.

3. Along the top, navigate to service accounts

4. Now click generate new private key.

    ​	*note: The key is not language specific.*

5. Download the key and place it outside of the project directory. Remember (or copy) the path to the key. We will use this for the next step.

## Configuring the server

To run the server we need to create a configuration file. A template is located in `server/fadzmaq/fadzmaq.conf.template`. You can create a copy of this file and rename it `server/fadzmaq/fadzmaq.conf` 

```python
# Config file
# Remove the .template from the filename to create the config file.
# DO NOT REMOVE THIS TEMPLATE FILE.

# Upon running the database enter your password:
# eg. fadzmaqpass
password = input("Database Password: ")

DATABASE_URI = 'postgresql+pg8000://postgres:{}@localhost/fadzmaq'.format(password)
CERT = '[Location of your service certificate -- do not keep in project directory]'                                                                                                                                                                                                                                                            
```

The template configuration file should look like this. Firstly, check the `DATABASE_URI` is pointing to the correct database instance. The URI is of the form `[sql type]+[database driver]://[user]:[password]@[address]/[database name]` 

This should be pre-configured with the shell scripts you used to configure the database. You *MUST* change the database password for security reasons. It will ask you to input the password whenever you run the server.

The `CERT` variable should be a string referencing the location of your firebase certificate. This is the private key we generated in the previous task. An example for mac and windows (using the linux sub system) is given below.

```sh
CERT = '/Users/yourname/Developer/fadzmaq1-firebase-adminsdk-78gsi-b01a0a6212.json'
```

```powershell
CERT = 'c:\mnt\c\Users\yourname\Developer\fadzmaq1-firebase-adminsdk-78gsi-b01a0a6212.json'
```

## Running the server

To run the server, navigate to the server/ directory and run: *Note: This is cross platform*

I have provided an example output below the command so you can be sure it is working.

```pseudocode
%	pipenv run python fadzmaq.py

* Serving Flask app "fadzmaq" (lazy loading)
* Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
* Debug mode: off
* Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)                                                            
```

## Testing the server

A basic unit testing suite is available to check the system is running as expected. This does not confirm the system is working 100% but will usually give a good indication something has gone wrong early. 

To run the tests:

```pseudocode
%	pipenv run python -m pytest

platform darwin -- Python 3.7.2, pytest-5.1.2, py-1.8.0, pluggy-0.13.0
rootdir: /Users/lachlanrussell/Developer/UNI/CITS3200-dev/server
tests/test_api.py ...F.F......                                                                [ 75%]
tests/test_db.py F.FF                                                                         [100%]
```

This example output has 5 failed tests.

## Updating the server

When you pull from the git repositories, another developer may have added dependancies into the Pipfile, or modified the database. To make sure this doesn't cause any issues, it is a good idea to update these before running the server.

```pseudocode
%	pipenv update
```

Then

```sh
$	./build_db.sh
$	./build_test_db.sh
```

```powershell
#	./build_db.bat			
#	./build_test_db.bat
```

If you ever need to reload the database, this can also be done using psql

```pseudocode
%	psql -U postgres -d fadzmaq -f fadzmaq/database/init.sql	
```

