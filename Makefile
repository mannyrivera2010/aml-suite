# This is a make file to help with the commands
## Help documentatin à la https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ./Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

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
	TEST_MODE=True pytest -n `nproc` --dist=loadscope

test_parallel_psql: clean pre create_static  ## Run all test in parallel (increase speed of unit tests) using postgres
	echo Number of cores: `nproc`
	MAIN_DATABASE=psql TEST_MODE=True pytest -n `nproc` --dist=loadscope

test_soft: pre  ## Run all tests (without clean)
	TEST_MODE=True pytest

install_git_hooks:  ## Install Git Hooks
	cp .hooks/pre-commit .git/hooks/

run:  ## Run the server locally using sqlite
	MAIN_DATABASE=sqlite python manage.py runserver localhost:8001

run_es:  ## Run the server locally using sqlite and elasticsearch
	ES_ENABLED=True python manage.py runserver localhost:8001

run_psql:  ## Run the server locally using postgres
	MAIN_DATABASE=psql python manage.py runserver localhost:8001

run_psql_es:  ## Run the server locally using postgres and elasticsearch
	MAIN_DATABASE=psql ES_ENABLED=True python manage.py runserver localhost:8001

run_gunicorn:   ## Run server using gunicorn
	gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid

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

run_gunicorn_es:  ## Run server using gunicorn using sqlite and elasticsearch
	ES_ENABLED=True gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid

run_gunicorn_psql_es:  ## Run server using gunicorn using postgres and elasticsearch
	MAIN_DATABASE=psql ES_ENABLED=True gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid

codecheck: ## Run pycodestyle python linter on the code
	pycodestyle ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402,E722 --show-source

autopep:  ## Run tool to fix python code
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --in-place

autopepdiff:  ## Print out linter diff
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff

reindex_es:  # Reindex the data into Elasticsearch
	ES_ENABLED=TRUE python manage.py runscript reindex_es

recommend:  ## Run Recommendations algorthims
	python manage.py runscript recommend

recommend_es:
	ES_ENABLED=TRUE python manage.py runscript recommend

recommend_psql:
	MAIN_DATABASE=psql python manage.py runscript recommend

recommend_es_user:
	ES_ENABLED=TRUE RECOMMENDATION_ENGINE='elasticsearch_user_base' python manage.py runscript recommend

recommend_es_content:
	ES_ENABLED=TRUE RECOMMENDATION_ENGINE='elasticsearch_content_base' python manage.py runscript recommend

sqlite_migrate:
	MAIN_DATABASE=sqlite python manage.py makemigrations ozpcenter
	MAIN_DATABASE=sqlite python manage.py makemigrations ozpiwc
	MAIN_DATABASE=sqlite TEST_MODE=True python manage.py migrate

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

dev: clean pre create_static install_git_hooks sqlite_migrate  ## Set up development server with sample data
	MAIN_DATABASE=sqlite python manage.py runscript sample_data_generator

dev_fast: clean pre create_static install_git_hooks
	FAST_MODE=True MAIN_DATABASE=sqlite python manage.py runscript sample_data_generator

dev_es: clean pre create_static install_git_hooks sqlite_migrate
	MAIN_DATABASE=sqlite ES_ENABLED=FALSE python manage.py runscript sample_data_generator
	ES_ENABLED=TRUE python manage.py runscript reindex_es

dev_psql: clean pre create_static install_git_hooks  ## Set up development server with sample data on postgres
	MAIN_DATABASE=psql python manage.py makemigrations ozpcenter
	MAIN_DATABASE=psql python manage.py makemigrations ozpiwc
	MAIN_DATABASE=psql TEST_MODE=True python manage.py migrate

	MAIN_DATABASE=psql python manage.py flush --noinput # For Postgres

	echo 'Loading sample data...'
	MAIN_DATABASE=psql python manage.py runscript sample_data_generator

email:
	python manage.py runscript notification_email

shell:  ## Launch python shell using sqlite
	python manage.py shell_plus --print-sql

shell_psql:  ## Launch python shell using postgres
	MAIN_DATABASE='psql' python manage.py shell_plus  --print-sql

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
