#!/bin/bash


set -e

current=`pwd`

cd `dirname $0`

. ./setEnv.sh

# generates data for demo; should take at most 1--2 minutes
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c  "select * from basictable limit 20"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c  "select count(*) from basictable"

cd $current
