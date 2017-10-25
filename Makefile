# This is a make file to help with the commands
root:
	# '==Commands=='
	# 'dev - make new development environment'
	# --Running--
	# 'run - run development environment'
	# 'run_es - run development environment with Elasticsearch'
	# 'runp - run development environment in multithreaded mode'
	# 'runp_es - run development environment with Elasticsearch  in multithreaded mode'
	# 'install_git_hooks - Install Git Hooks to run code checker'
	# 'shell - Enter into interactive shell'

# tail -f /var/log/postgresql/postgresql-9.3-main.log

clean:
	rm -f db.sqlite3
	rm -rf static/
	rm -rf media/
	rm -f ozp.log

create_static:
	mkdir -p static
	python manage.py collectstatic --noinput
	mkdir -p media

pre:
	export DJANGO_SETTINGS_MODULE=ozp.settings

test: clean pre create_static
	TEST_MODE=True pytest

ptest: clean pre create_static
	echo Number of cores: `nproc`
	TEST_MODE=True pytest -n `nproc` --dist=loadscope

ptest_psql: clean pre create_static
	echo Number of cores: `nproc`
	MAIN_DATABASE=psql TEST_MODE=True pytest -n `nproc` --dist=loadscope

softtest: pre
	TEST_MODE=True pytest

install_git_hooks:
	cp .hooks/pre-commit .git/hooks/

run:
	MAIN_DATABASE=sqlite python manage.py runserver localhost:8001

run_es:
	ES_ENABLED=True python manage.py runserver localhost:8001

run_psql:
	MAIN_DATABASE=psql python manage.py runserver localhost:8001

run_psql_es:
	MAIN_DATABASE=psql ES_ENABLED=True python manage.py runserver localhost:8001

rung:
	gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid

rung_es:
	ES_ENABLED=True gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid

rung_psql_es:
	MAIN_DATABASE=psql ES_ENABLED=True gunicorn --workers=`nproc` ozp.wsgi -b localhost:8001 --access-logfile logs.txt --error-logfile logs.txt -p gunicorn.pid

codecheck:
	pycodestyle ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402,E722 --show-source

autopep:
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --in-place

autopepdiff:
	autopep8 ozp ozpcenter ozpiwc plugins tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff

reindex_es:
	ES_ENABLED=TRUE python manage.py runscript reindex_es

recommend:
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

dev: clean pre create_static install_git_hooks sqlite_migrate
	MAIN_DATABASE=sqlite python manage.py runscript sample_data_generator

dev_es: clean pre create_static install_git_hooks sqlite_migrate
	MAIN_DATABASE=sqlite ES_ENABLED=FALSE python manage.py runscript sample_data_generator
	ES_ENABLED=TRUE python manage.py runscript reindex_es

dev_psql: clean pre create_static install_git_hooks
	MAIN_DATABASE=psql python manage.py makemigrations ozpcenter
	MAIN_DATABASE=psql python manage.py makemigrations ozpiwc
	MAIN_DATABASE=psql TEST_MODE=True python manage.py migrate

	MAIN_DATABASE=psql python manage.py flush --noinput # For Postgres

	echo 'Loading sample data...'
	MAIN_DATABASE=psql python manage.py runscript sample_data_generator

email:
	python manage.py runscript notification_email

shell:
	python manage.py shell_plus --print-sql

shell_psql:
	MAIN_DATABASE='psql' python manage.py shell_plus  --print-sql

create_virtualenv:
	virtualenv env

pyenv: create_virtualenv
	(source env/bin/activate &&  pip install -r requirements.txt)

pyenv_wheel: create_virtualenv
	(source env/bin/activate &&  pip install --no-index --find-links=wheelhouse -r requirements.txt)

upgrade_requirements:
	pip freeze | cut -d = -f 1 | xargs -n 1 pip install --upgrade

freeze_requirements:
	pip freeze > requirements.txt
