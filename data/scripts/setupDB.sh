#!/bin/bash


set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

# drop existing database
#psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP DATABASE IF EXISTS  ${GREENPLUM_DB}"
createdb -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB}


# generates data for demo; should take at most 1--2 minutes
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./sample_table.sql

cd $current
