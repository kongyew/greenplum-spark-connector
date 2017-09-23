#!/bin/bash


set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

cd $current

echo "psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c \"DROP DATABASE IF EXISTS ${GREENPLUM_DB}\" "
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP DATABASE IF EXISTS ${GREENPLUM_DB}"
