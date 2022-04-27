# This is a make file to help with the commands
# Help documentatin à la https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^.*?## .*$$' ./Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

help_markdown:
	@grep -E '^.*?## .*$$' ./Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "`%s`-%s\n", $$1, $$2}'

use_database := MAIN_DATABASE=sqlite
use_elasticsearch_str := ES_ENABLED=False
use_runserver_str := python manage.py runserver 0.0.0.0:8001
use_runscript_str := python manage.py runscript

## Flags
use_psql:  ## Use Postgres Database
	$(eval use_database := MAIN_DATABASE=psql)

use_es:  ## Use elasticsearch Database
	$(eval use_elasticsearch_str := ES_ENABLED=True)

use_gunicorn:  ## Use gunicorn
	$(eval use_runserver_str := gunicorn --workers=`nproc` aml.wsgi -b 0.0.0.0:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid)

# Commands
clean: ## Clean Directory
	rm -f db.sqlite3
	rm -rf static/
	rm -rf media/
	rm -f aml.log

create_static:  ## Collect static files
	mkdir -p static
	python manage.py collectstatic --noinput
	mkdir -p media

pre:
	export DJANGO_SETTINGS_MODULE=aml.settings

test: clean pre create_static  ## Run all tests
	TEST_MODE=True pytest

test_parallel: clean pre create_static  ## Run all test in parallel (increase speed of unit tests)
	echo Number of cores: `nproc`
	$(use_database) $(use_elasticsearch_str) TEST_MODE=True pytest -n `nproc` --dist=loadscope

test_soft: pre  ## Run all tests (without clean)
	TEST_MODE=True pytest

install_git_hooks:  ## Install Git Hooks
	cp .hooks/pre-commit .git/hooks/

run:  ## Run the server locally
	$(use_database) $(use_elasticsearch_str) $(use_runserver_str)

# my-app &
# echo $my-app-pid
run_all: ## Run server locally, celery_worker, Recommendations
	(make run &) && (echo $$! > SERVER_PYTHON.pid)
	(redis-server &) && (echo $$! > SERVER_REDIS.pid)

kill_all:
	# kill `cat SERVER_PYTHON.pid`
	# kill `cat SERVER_REDIS.pid`
	(ps aux | grep "redis-server" | grep "Sl" | awk '{print $$2}' | xargs -I {} echo "{}" | xargs kill) &
	(ps aux | grep "manage.py runserver" | grep "Sl" | awk '{print $$2}' | xargs -I {} echo "{}" | xargs kill) &

celery_worker:  ## Run the celery worker
	# env/lib/python3.4/site-packages/watchdog/observers/__init__.py
	# Change if platform.is_linux(): try: from .polling import PollingObserver as Observer
	watchmedo auto-restart --directory . --patterns='*.py' --recursive --interval=5 -- celery worker -l info -A aml

kill_celery_worker:
	ps aux | grep "celery worker" | grep "Ss" | awk '{print $$2}' | xargs -I {} echo "{}" | xargs kill

run_gunicorn_secure:   ## Run server using gunicorn on HTTPS (preq: clone dev-tools repo)
	$(use_database) $(use_elasticsearch_str) gunicorn --workers=`nproc` aml.wsgi -b localhost:8001 \
		--access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid \
		--keyfile ~/certs/server_nopass.key \
		--certfile ~/certs/server_nopass.crt \
		--ca-certs ~/certs/ca_root.pem

run_gunicorn_secure_ansible:     ## Run server using gunicorn on HTTPS (preq: clone aml-ansible repo)
	gunicorn --workers=`nproc` aml.wsgi -b localhost:8001 \
		--access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid \
		--keyfile ~/git/aml-ansible/roles/ssl_certs/files/server.key \
		--certfile ~/git/aml-ansible/roles/ssl_certs/files/server.crt \
		--ca-certs ~/git/aml-ansible/roles/ssl_certs/files/rootCA.pem

codecheck: ## Run pycodestyle python linter on the code
	pycodestyle aml amlcenter plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402,E722 --show-source

autopep:  ## Run tool to fix python code
	autopep8 aml amlcenter plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff
	autopep8 aml amlcenter plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --in-place

autopepdiff:  ## Print out linter diff
	autopep8 aml amlcenter plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff

reindex_es:  use_es  ## Reindex the data into Elasticsearch
	$(use_database) $(use_elasticsearch_str) $(use_runscript_str) reindex_es

recommend:  ## Run Recommendations algorthims
	$(use_database) $(use_elasticsearch_str) $(use_runscript_str) recommend

db_migrate:  ## Db migrate
	$(use_database) python manage.py makemigrations amlcenter
	$(use_database) TEST_MODE=True python manage.py migrate

dev: clean pre create_static install_git_hooks db_migrate  ## Set up development server with sample data
	if [[ $(use_database) = *"psql"* ]] ; then $(use_database) python manage.py flush --noinput; echo 'Flushed psql'  ; fi
	$(use_database) $(use_runscript_str) sample_data_generator

dev_fast: clean pre create_static install_git_hooks
	FAST_MODE=True $(use_database) $(use_runscript_str) sample_data_generator

email:  ## Send Notifications using email server
	$(use_runscript_str) notification_email

run_debug_email_server:  ## Run Debug Email Server
	python -m smtpd -n -d -c DebuggingServer localhost:1025

shell:  ## Launch python shell using sqlite
	$(use_database) python manage.py shell_plus --print-sql

shell_psql: use_psql  ## Launch python shell using postgres
	$(use_database) python manage.py shell_plus --print-sql

create_virtualenv:  ## Create Python Environment
	virtualenv env

pyenv: create_virtualenv  ## Create Python Environment and install dependencies
	(source env/bin/activate &&  pip install -r requirements.txt)

pyenv_wheel: create_virtualenv  ## Create Python Environment and install dependencies using wheelhouse
	(source env/bin/activate &&  pip install --no-index --find-links=wheelhouse -r requirements.txt)

##
## Requirements
upgrade_requirements:  ## upgrade requirements
	pip freeze | cut -d = -f 1 | xargs -n 1 pip install --upgrade

freeze_requirements:  ## freeze requirements
	pip freeze > requirements.freeze.txt

sqlite_dump: dev
	sqlite3 db.sqlite3 .dump > amlcenter/scripts/test_data/dump_sqlite3.sql

sqlite_restore:
	if [ -e 'db.sqlite3' ]; then rm db.sqlite3 ; fi && cat amlcenter/scripts/test_data/dump_sqlite3.sql | sqlite3 db.sqlite3

pgsql_dump: use_psql dev
	pg_dump --username=aml_user --host=localhost aml > amlcenter/scripts/test_data/dump_pgsql.sql

pgsql_create_user:
	if [ `psql -tA -c "SELECT 1 AS result FROM pg_database WHERE datname='aml'" -U postgres --host=localhost` == '1' ] ; then psql -c 'DROP DATABASE aml;' -U postgres --host=localhost ; fi
	psql -c 'CREATE DATABASE aml;' -U postgres --host=localhost
	psql -c 'GRANT ALL PRIVILEGES ON DATABASE aml TO aml_user;' -U postgres --host=localhost

pgsql_restore: pgsql_create_user
	psql --username=aml_user --host=localhost aml < amlcenter/scripts/test_data/dump_pgsql.sql
