#!/usr/bin/env bash
#

export DUMP_FILENAME="dump.sql"

export LEGACY_DB_HOST="localhost"
export LEGACY_DB_NAME="ozp"
export LEGACY_DB_USER="ozp_user"

export LEGACY_DUMP_OPTIONS="--data-only --disable-triggers --exclude-table=django_*"
export LEGACY_DUMP_OPTIONS=$LEGACY_DUMP_OPTIONS" --exclude-table=auth_group"
export LEGACY_DUMP_OPTIONS=$LEGACY_DUMP_OPTIONS" --exclude-table=auth_user_groups"
export LEGACY_DUMP_OPTIONS=$LEGACY_DUMP_OPTIONS" --exclude-table=auth_permission"
export LEGACY_DUMP_OPTIONS=$LEGACY_DUMP_OPTIONS" --exclude-table=auth_group_permissions"
export LEGACY_DUMP_OPTIONS=$LEGACY_DUMP_OPTIONS" --exclude-table=auth_user_user_permissions"

# Dump Legacy Database Data
pg_dump --username=$LEGACY_DB_USER --host=$LEGACY_DB_HOST $LEGACY_DB_NAME $LEGACY_DUMP_OPTIONS > $DUMP_FILENAME




# Remove database for testing
make pgsql_create_user
make db_migrate





psql -h localhost -U aml_user aml < dump.sql
