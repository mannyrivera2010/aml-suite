[Documentation Site](https://aml-development.github.io/ozp-backend/)

## Background
Django-based backend API for the OZONE Platform (OZP).    
**ozp-backend** replaces [ozp-rest](https://github.com/ozone-development/ozp-rest)
as the backend for Center, HUD, Webtop, and IWC.     

Notable differences include:    

* Python vs. Java/Groovy
* Django, Django Rest Framework vs. Grails, JAX-RS
* Postgres vs. MySQL

## 3rd Party Services
Project relays on
Travis-CI
[![Build Status](https://travis-ci.org/aml-development/ozp-backend.svg?branch=master)](https://travis-ci.org/ozone-development/ozp-backend)

## Getting Started
### Development environment preparation
```
cd ~
mkdir git
cd git
git clone git@github.com:aml-development/ozp-backend.git
cd ozp-backend
virtualenv env
source env/bin/activate
pip install -r requirements.txt
```
If `virtualenv env` does not work it might be `python3 -m venv env` if the environment

### Building and running the OZP backend
```
cd ~/git/ozp-backend
source env/bin/activate
make dev
```

### MakeFile
There is a MakeFile in the project to run repetitive commands    

Commands:    
`make dev run` - Setup up the Development environment and run server on a SQLite Database (without Elasticsearch)  
`make pyenv` - Create Python environment and install requirements    
`make dev` - Setup up the development environment running on a SQLite Database (without Elasticsearch)    
`make dev_psql` - Setup up the development environment running on a Postgres Database (without Elasticsearch)    
`make dev_es` - Setup up the development environment running on a SQLite Database with Elasticsearch)    
`make reindex_es` - Reindex the data into Elasticsearch    
`make run` - Run the server    
`make run_es` - Run the server with Elasticsearch    
`make rung` - Run Server with gunicorn with a worker per core    
`make test` - Run all test    
`make codecheck` - Run pycodestyle python linter on the code    
`make upgrade_requirements` - Update project python dependencies    
