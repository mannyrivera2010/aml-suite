#!/usr/bin/env bash
<< ////
Process:
* dump db ozp
* create db aml
* restore ozp dump file to aml db
* rename ozp tables to aml prefixes
* drop iwc tables
* drop django_migration db
* create django_migration file with new values

Preq:
User for AML database has been created
////

set_variables(){
  echo '-- Setting variables -- '
  export LEGACY_DUMP_FILENAME="ozp_dump.dump.sql"

  export LEGACY_DB_HOST="localhost"
  export LEGACY_DB_NAME="ozp"
  export LEGACY_DB_USER="ozp_user"

  export LEGACY_DUMP_OPTIONS=""

  export AML_DB_HOST="localhost"
  export AML_DB_NAME="aml"
  export AML_DB_USER="aml_user"
}

clear_aml_db(){
  if [ `psql -tA -c "SELECT 1 AS result FROM pg_database WHERE datname='$AML_DB_NAME'" -U postgres --host=localhost` == '1' ] ; then psql -c 'DROP DATABASE '$AML_DB_NAME';' -U postgres --host=localhost ; fi
  psql -c 'CREATE DATABASE '$AML_DB_NAME';' -U postgres --host=localhost
  psql -c 'GRANT ALL PRIVILEGES ON DATABASE '$AML_DB_NAME' TO '$AML_DB_USER';' -U postgres --host=localhost
}

dump_legacy_db(){
  rm *.dump.sql* -f
  echo '-- Dumping '$LEGACY_DUMP_FILENAME' --'
  pg_dump --username=$LEGACY_DB_USER --host=$LEGACY_DB_HOST $LEGACY_DB_NAME $LEGACY_DUMP_OPTIONS > $LEGACY_DUMP_FILENAME
}

# Replace ozp with aml, ozp_user with aml_user
clean_dump_file(){
  echo '-- Cleaning Dump File --'
  sed -i.org \
    -e 's/_ozpcenter/_amlcenter/g' \
    -e 's/ozpcenter_/amlcenter_/g' \
    -e 's/'$LEGACY_DB_USER'/'$AML_DB_USER'/g' \
    -e 's/leaving_ozp_warning_flag/leaving_aml_warning_flag/g' \
    $LEGACY_DUMP_FILENAME
}

restore_legacy_db_aml(){
  psql -h localhost -U aml_user aml < $LEGACY_DUMP_FILENAME
}

# ALTER
alter_restored_db(){
  echo '-- alter_restored_db --'
}


set_variables

dump_legacy_db

clean_dump_file

clear_aml_db

restore_legacy_db_aml

#alter_restored_db

# Dump Legacy Database Data

# ALTER TABLE IF EXISTS ozpcenter_docurl RENAME TO amlcenter_docurl;
