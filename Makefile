# This is a make file to help with the commands
## Help documentatin à la https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ./Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

use_database := MAIN_DATABASE=sqlite
use_elasticsearch_str := ES_ENABLED=False
use_runserver_str := python manage.py runserver localhost:8001
use_runscript_str := python manage.py runscript

use_psql:  ## - Use Postgres Database
	$(eval use_database := MAIN_DATABASE=psql)

use_elasticsearch:  ## - Use elasticsearch Database
	$(eval use_elasticsearch_str := ES_ENABLED=True)

use_gunicorn:  ## - Use gunicorn
	$(eval use_runserver_str := gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid)

clean: ## Clean Directory
	rm -f db.sqlite3
	rm -rf static/
	rm -rf media/
	rm -f ozp.log

create_static:  ## Collect static files
	mkdir -p static
	python manage.py collectstatic --noinput
	mkdir -p media

pre:
	export DJANGO_SETTINGS_MODULE=ozp.settings

test: clean pre create_static  ## Run all tests
	TEST_MODE=True pytest

test_parallel: clean pre create_static  ## Run all test in parallel (increase speed of unit tests)
	echo Number of cores: `nproc`
	$(use_database) $(use_elasticsearch_str) TEST_MODE=True pytest -n `nproc` --dist=loadscope

test_parallel_psql: clean pre create_static use_psql ## Run all test in parallel (increase speed of unit tests) using postgres
	echo Number of cores: `nproc`
	$(use_database) $(use_elasticsearch_str) TEST_MODE=True pytest -n `nproc` --dist=loadscope

test_soft: pre  ## Run all tests (without clean)
	TEST_MODE=True pytest

install_git_hooks:  ## Install Git Hooks
	cp .hooks/pre-commit .git/hooks/

run:  ## Run the server locally using sqlite
	$(use_database) $(use_elasticsearch_str) $(use_runserver_str)

run_es: use_elasticsearch  ## Run the server locally using sqlite and elasticsearch
	$(use_database) $(use_elasticsearch_str) $(use_runserver_str)

run_psql_es: use_psql use_elasticsearch  ## Run the server locally using postgres and elasticsearch
	$(use_database) $(use_elasticsearch_str) $(use_runserver_str)

run_gunicorn: use_gunicorn  ## Run server using gunicorn
	$(use_database) $(use_elasticsearch_str) $(use_runserver_str)

run_gunicorn_es: use_gunicorn use_elasticsearch  ## Run server using gunicorn using sqlite and elasticsearch
	$(use_database) $(use_elasticsearch_str) $(use_runserver_str)

run_gunicorn_psql_es: use_gunicorn use_elasticsearch use_psql  ## Run server using gunicorn using postgres and elasticsearch
	$(use_database) $(use_elasticsearch_str) $(use_runserver_str)

run_gunicorn_secure:   ## Run server using gunicorn on HTTPS (preq: clone dev-tools repo)
	gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 \
		--access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid \
		--keyfile ~/git/dev-tools/certs/server_nopass.key \
		--certfile ~/git/dev-tools/certs/server_nopass.crt \
		--ca-certs ~/git/dev-tools/certs/ca_root.pem

run_gunicorn_secure_ansible:     ## Run server using gunicorn on HTTPS (preq: clone ozp-ansible repo)
	gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 \
		--access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid \
		--keyfile ~/git/ozp-ansible/roles/ssl_certs/files/server.key \
		--certfile ~/git/ozp-ansible/roles/ssl_certs/files/server.crt \
		--ca-certs ~/git/ozp-ansible/roles/ssl_certs/files/rootCA.pem

codecheck: ## Run pycodestyle python linter on the code
	pycodestyle ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402,E722 --show-source

autopep:  ## Run tool to fix python code
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --in-place

autopepdiff:  ## Print out linter diff
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff

reindex_es:  use_elasticsearch  ## Reindex the data into Elasticsearch
	$(use_database) $(use_elasticsearch_str) $(use_runscript_str) reindex_es

recommend:  ## Run Recommendations algorthims
	$(use_database) $(use_elasticsearch_str) $(use_runscript_str) recommend

recommend_es: use_elasticsearch
	$(use_database) $(use_elasticsearch_str) $(use_runscript_str) recommend

recommend_psql: use_psql
	$(use_database) $(use_runscript_str) recommend

sqlite_dump: dev
	sqlite3 db.sqlite3 .dump > ozpcenter/scripts/test_data/dump_sqlite3.sql

sqlite_restore:
	if [ -e 'db.sqlite3' ]; then rm db.sqlite3 ; fi && cat ozpcenter/scripts/test_data/dump_sqlite3.sql | sqlite3 db.sqlite3

pgsql_dump: dev_psql
	pg_dump --username=ozp_user --host=localhost ozp > ozpcenter/scripts/test_data/dump_pgsql.sql

pgsql_restore:
	if [ `psql -tA -c "SELECT 1 AS result FROM pg_database WHERE datname='ozp'" -U postgres --host=localhost` == '1' ] ; then psql -c 'DROP DATABASE ozp;' -U postgres --host=localhost ; fi
	psql -c 'CREATE DATABASE ozp;' -U postgres --host=localhost
	psql -c 'GRANT ALL PRIVILEGES ON DATABASE ozp TO ozp_user;' -U postgres --host=localhost
	psql --username=ozp_user --host=localhost ozp < ozpcenter/scripts/test_data/dump_pgsql.sql

db_migrate:
	$(use_database) python manage.py makemigrations ozpcenter
	$(use_database) python manage.py makemigrations ozpiwc
	$(use_database) TEST_MODE=True python manage.py migrate

dev: clean pre create_static install_git_hooks db_migrate  ## Set up development server with sample data
	$(use_database) $(use_runscript_str) sample_data_generator

dev_fast: clean pre create_static install_git_hooks
	FAST_MODE=True $(use_database) $(use_runscript_str) sample_data_generator

dev_es: clean pre create_static install_git_hooks db_migrate
	$(use_database) ES_ENABLED=FALSE $(use_runscript_str) sample_data_generator
	$(use_database) ES_ENABLED=TRUE $(use_runscript_str) reindex_es

dev_psql: clean pre create_static install_git_hooks use_psql db_migrate ## Set up development server with sample data on postgres
	$(use_database) python manage.py flush --noinput # For Postgres
	$(use_database) $(use_runscript_str) sample_data_generator

email:
	$(use_runscript_str) notification_email

shell:  ## Launch python shell using sqlite
	$(use_database) python manage.py shell_plus --print-sql

shell_psql: use_psql  ## Launch python shell using postgres
	$(use_database) python manage.py shell_plus  --print-sql

create_virtualenv:  ## Create Python Environment
	virtualenv env

pyenv: create_virtualenv  ## Create Python Environment and install dependencies
	(source env/bin/activate &&  pip install -r requirements.txt)

pyenv_wheel: create_virtualenv  ## Create Python Environment and install dependencies using wheelhouse
	(source env/bin/activate &&  pip install --no-index --find-links=wheelhouse -r requirements.txt)

upgrade_requirements:
	pip freeze | cut -d = -f 1 | xargs -n 1 pip install --upgrade

freeze_requirements:
	pip freeze > requirements.txt
