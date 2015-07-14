#!/usr/bin/env bash

# Useful for development ONLY, this script will:
# 	* wipe the existing database
#	* wipe all existing migrations
#	* create a fresh database with a single new migration
#	* remove and collect static files
#	* remove and collect media files
#	* run unit tests
#	* load sample data
#	* start up the django dev server on port 8000

export DJANGO_SETTINGS_MODULE=ozpv3.settings

# remove existing database and all migrations
rm db.sqlite3
rm -r ozpcenter/migrations/*
# create new database with a single new migration
python manage.py makemigrations ozpcenter
python manage.py migrate
# remove old static files
rm -rf static/
mkdir -p static
# collect static files
python manage.py collectstatic --noinput
# remove old media files
rm -rf media/
mkdir -p media
# run unit tests
python manage.py test ozpcenter/tests
# load sample data (uses runscript from django-extensions package)
echo 'Loading sample data...'
python manage.py runscript sample_data_generator
python manage.py runserver
