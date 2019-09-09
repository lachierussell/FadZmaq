# INSTALL

## Unix

This process requires you to have already installed pip3. This will be dependant on your specific operating system and available package managers. 

Once this has installed, it should be as simple as following the commands into a sh compatible terminal bellow, denoted with $	


```sh
$	pip3 install pipenv
$	git clone https://github.com/22257963/CITS3200.git

Cloning into 'CITS3200'...
remote: Enumerating objects: 1922, done.
remote: Counting objects: 100% (1922/1922), done.
remote: Compressing objects: 100% (1657/1657), done.
remote: Total 1922 (delta 295), reused 1831 (delta 206), pack-reused 0
Receiving objects: 100% (1922/1922), 7.42 MiB | 1.06 MiB/s, done.
Resolving deltas: 100% (295/295), done.

$	cd CITS3200/server
$	pipenv install --dev

Creating a virtualenv for this project…
Pipfile: /Users/lachlanrussell/Developer/CITS3200/server/Pipfile
Using /usr/local/bin/python3 (3.7.3) to create virtualenv…
⠏ Creating virtual environment...Already using interpreter /usr/local/bin/python3
Using base prefix '/usr/local/Cellar/python/3.7.3/Frameworks/Python.framework/Versions/3.7'
New python executable in /Users/lachlanrussell/.local/share/virtualenvs/server-HXrmzZNi/bin/python3
Also creating executable in /Users/lachlanrussell/.local/share/virtualenvs/server-HXrmzZNi/bin/python
Installing setuptools, pip, wheel...
done.
Running virtualenv with interpreter /usr/local/bin/python3
✔ Successfully created virtual environment! 
Virtualenv location: /Users/lachlanrussell/.local/share/virtualenvs/server-HXrmzZNi
Installing dependencies from Pipfile.lock (14acb9)…
  🐍   ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉ 12/12 — 00:00:04
To activate this project's virtualenv, run pipenv shell.
Alternatively, run a command inside the virtualenv with pipenv run.

$	pipenv run python fadzmaq.py 

 * Serving Flask app "api" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```

You now have the web server running. You can access it by typing http://127.0.0.1:5000/ into your browser.

## Windows

1. Run Windows Power Shell as Administrator
2. Run the following command in Power Shell

```
pip install pipenv
```

Once this has installed 

```powershell
$	git clone https://github.com/22257963/CITS3200.git

$	cd CITS3200\server

$	pipenv install --dev

$	pipenv run python fadzmaq.py 

 * Serving Flask app "api" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```

The web server should now be running. To check it works, try opening the address inside your browser.

*I am unsure of command output and I am not able to test due to a deficiency in a windows device.*

