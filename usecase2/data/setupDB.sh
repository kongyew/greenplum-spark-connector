#!/bin/bash

set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

# Determine greenplum installation
if [ -d "/usr/local/gpdb" ]
then
  createdb -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${POSTGRES_DB}
  psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${POSTGRES_DB} -f ./gpdb_sample.sql
else
  if [ -d "/opt/gpdb" ]
  then
    createdb -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${POSTGRES_DB}
    psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${POSTGRES_DB} -f ./gpdb_sample.sql
  else
      echo "Directory /opt/gpdb does not exists."
  fi
fi

cd $current
