#!/bin/bash

set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

# Determine greenplum installation
if [ -d "/usr/local/gpdb" ] | [ -d "/opt/gpdb" ]
then
  echo "Running :psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${POSTGRES_DB} -c 'select count(*) from usertable;'"
  psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${POSTGRES_DB} -c "select count(*) from usertable;"
else
      echo "Directory /opt/gpdb does not exists."
fi

cd $current
