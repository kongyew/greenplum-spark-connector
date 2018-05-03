#!/bin/bash


set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

cd $current

# Determine greenplum installation
if [ -d "/usr/local/greenplum-db" ]
then
  echo "psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c \"DROP DATABASE IF EXISTS ${POSTGRES_DB}\" "
  psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP TABLE IF EXISTS export"
  psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP DATABASE IF EXISTS ${POSTGRES_DB}"
else
  if [ -d "/opt/gpdb" ]
  then
    echo "psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c \"DROP DATABASE IF EXISTS ${POSTGRES_DB}\" "
    psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP TABLE IF EXISTS export"
    psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP DATABASE IF EXISTS ${POSTGRES_DB}"
  fi
fi
