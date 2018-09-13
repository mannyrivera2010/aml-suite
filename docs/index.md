## Background
Django-based backend API  

## 3rd Party Services
Project relays on    
Travis-CI  [![Build Status](https://travis-ci.org/aml-development/aml-backend.svg?branch=master)](https://travis-ci.org/aml-development/aml-backend)

## Getting Started
### Software Versions
`Elasticsearch` - 6.3.2
`Python` - 3.4

### Development environment preparation
```
cd ~
mkdir git
cd git
git clone git@github.com:aml-development/aml-backend.git
cd aml-backend
virtualenv env
source env/bin/activate
pip install -r requirements.txt
```
If `virtualenv env` does not work it might be `python3 -m venv env` if the environment

### Building and running the AML backend
```
cd ~/git/aml-backend
source env/bin/activate
make dev
```

### MakeFile
There is a MakeFile in the project to run repetitive commands    

*Flags*
`use_psql`-Use Postgres Database
`use_es`-Use elasticsearch Database
`use_gunicorn`-Use gunicorn
`clean`-Clean Directory
`create_static`-Collect static files
`test`-Run all tests
`test_parallel`-Run all test in parallel (increase speed of unit tests)
`test_soft`-Run all tests (without clean)
`install_git_hooks`-Install Git Hooks
`run`-Run the server locally
`run_all`-Run server locally, celery_worker, Recommendations
`celery_worker`-Run the celery worker
`run_gunicorn_secure`-Run server using gunicorn on HTTPS (preq: clone dev-tools repo)
`run_gunicorn_secure_ansible`-Run server using gunicorn on HTTPS (preq: clone aml-ansible repo)
`codecheck`-Run pycodestyle python linter on the code
`autopep`-Run tool to fix python code
`autopepdiff`-Print out linter diff
`reindex_es`-Reindex the data into Elasticsearch
`recommend`-Run Recommendations algorthims
`db_migrate`-Db migrate
`dev`-Set up development server with sample data
`email`-Send Notifications using email server
`run_debug_email_server`-Run Debug Email Server
`shell`-Launch python shell using sqlite
`shell_psql`-Launch python shell using postgres
`create_virtualenv`-Create Python Environment
`pyenv`-Create Python Environment and install dependencies
`pyenv_wheel`-Create Python Environment and install dependencies using wheelhouse

*Requirements*
`upgrade_requirements`-upgrade requirements
`freeze_requirements`-freeze requirements



### Postgres Setup
Command to install postgresql (on Debian-based OS)
```
sudo apt-get install postgresql postgresql-contrib
```

Commands to setup postgresql for aml-backend
```
sudo -i -u postgres
createuser aml_user
psql -c 'ALTER USER aml_user CREATEDB;'
psql -c "ALTER USER "aml_user" WITH PASSWORD 'password';"
createdb aml
psql -c 'GRANT ALL PRIVILEGES ON DATABASE aml TO aml_user;'
```

### Local development method (minimal)
To serve the application on your host machine with minimal external dependencies,
do the following:

1. Remove psycopg2 from requirements.txt (so that Postgres won't be required)
2. Enable HTTP Basic Auth and disable PKI authentication. In settings.py,
`REST_FRAMEWORK.DEFAULT_AUTHENTICATION_CLASSES` should be set to
`'rest_framework.authentication.BasicAuthentication'`
3. Disable the authorization service. In settings.py, set `AML.USE_AUTH_SERVER`
to `False`
4. In settings.py, set `AML.DEMO_APP_ROOT` to `localhost:8000` (or wherever
the django app will be served at)

Then, do the following:

1. Install Python 3.4.3. Python can be installed by downloading the appropriate
    files [here](https://www.python.org/downloads/release/python-343/). Note
    that Python 3.4 includes both `pip` and `venv`, a built-in replacement
    for the `virtualenv` package
2. Create a new python environment using python 3.4.x. First, create a new
    directory where this environment will live, for example, in
    `~/python_envs/aml`. Now create a new environment there:
    `python3.4 -m venv ENV` (where `ENV` is the path you used above)
3. Active the new environment: `source ENV/bin/activate`
4. Install the necessary dependencies into this python environment:
    `pip install -r requirements.txt`
5. Run the server: `make dev`

Swagger documentation for the api is available at `http://localhost:8000/docs/`
Use username `wsmith` password `password` when prompted for authentication info

There's also the admin interface at `http://localhost:8000/admin`
(username: `wsmith`, password: `password`)

### aml-ansible method
For those who just want to get AML up and running, see the
[quickstart](https://github.com/aml-development/aml-ansible#quickstart) of the [aml-ansible](https://github.com/aml-development/aml-ansible) project.

The recommended approach is to use the vagrant box referenced at the beginning
of this README, which will create a production-esque deployment of AML:

* Postgres (vs. SQLite)
* PKI (vs. HTTP Basic Auth)
* Use of external authorization service
* Enable HTTPS (via nginx reverse proxy)
* Served via Gunicorn (vs. Django development server)

### Runing Elasticsearch for Search
aml/Settings.py file variable needs to be updated to `ES_ENABLED = True`    
After installing Elasticsearch run `make reindex_es` and run `make run_es` in the aml-backend folder while inside of your $env     

### Installing and Running Elasticsearch    
aml-backend requires Elasticsearch 2.4.1    
[Installation Guide for 2.4.1](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/_installation.html)

The requirement for installing Elasticsearch is Java 7.    
Preferably, you should install the latest version of the official Java from www.java.com.    

You can get the Elasticsearch 2.4.1 from https://www.elastic.co/blog/elasticsearch-2-4-1-released.    
To install Elasticsearch, download and extract the archive file for your platform.    
Once you’ve extracted the archive file, Elasticsearch is ready to run.   

Below are the commands:
```
wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.1/elasticsearch-2.4.1.tar.gz
tar xvf elasticsearch-2.4.1.tar.gz
cd elasticsearch-2.4.1
./bin/elasticsearch
```

**Tip**    
When installing Elasticsearch in production, you can choose to use the Debian or RPM packages provided on the downloads page.    
You can also use the officially supported Puppet module, Chef cookbook, or Ansible.    

## Releasing
Run `python release.py` to generate a tarball with Wheels for the application
and all of its dependencies. See `release.py` for details

## Sample Users for BasicAuth
By default, HTTP Basic Authentication is used for login.    
This can be changed to PKI (client certificates) by changing `REST_FRAMEWORK.DEFAULT_AUTHENTICATION_CLASSES` in `settings.py`

Below are usernames that are part of our sample data (defined in
`aml-backend/amlcenter/scripts/sample_data_generator.py`) (password for all users is `password`):

**Admins:**    

* bigbrother (minipax)
* bigbrother2 (minitrue)
* khaleesi (miniplen)

**Org Stewards:**    

 * wsmith (minitrue, stewarded_orgs: minitrue)    
 * julia (minitrue, stewarded_orgs: minitrue, miniluv)    
 * obrien (minipax, stewarded_orgs: minipax, miniplenty)     

**Users:**    

 * aaronson (miniluv)
 * hodor (miniluv - PKI)
 * jones (minitrue)
 * tammy (minitrue - PKI)
 * rutherford (miniplenty)
 * noah (miniplenty - PKI)
 * syme (minipax)
 * abe (minipax - PKI)
 * tparsons (minipax, miniluv)
 * jsnow (minipax, miniluv - PKI)
 * charrington (minipax, miniluv, minitrue)
 * johnson (minipax, miniluv, minitrue - PKI)
