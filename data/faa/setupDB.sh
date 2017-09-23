#!/bin/bash


currentpwd=`pwd`

cd `dirname $0`

. ./setEnv.sh

# drop existing database
#psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "DROP DATABASE IF EXISTS  ${GREENPLUM_DB}"
createdb -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB}

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "DROP SCHEMA IF EXISTS faa CASCADE;"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "CREATE SCHEMA faa;"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "SET SEARCH_PATH TO faa, public, pg_catalog, gp_toolkit;"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "SHOW search_path;"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "ALTER ROLE gpadmin SET search_path TO faa, public, pg_catalog, gp_toolkit;"

# generates data for demo; should take at most 1--2 minutes
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/create_dim_tables.sql

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/create_fact_tables.sql

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/create_bad_distro.sql

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/create_ext_table.sql


psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/create_load_tables.sql

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/create_sample_table.sql

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/load_into_fact_table.sql

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -f  ./gpdb-sandbox-tutorials/faa/faa_otp_load.sql


psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "\dt faa."

targetcommand="\COPY faa.d_airlines FROM '${currentpwd}/gpdb-sandbox-tutorials/faa/L_AIRLINE_ID.csv'  CSV HEADER"
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "${targetcommand}"

targetcommand="\COPY faa.d_airports FROM '${currentpwd}/gpdb-sandbox-tutorials/faa/L_AIRPORTS.csv'  CSV HEADER"
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "${targetcommand}"

targetcommand="\COPY faa.d_delay_groups FROM '${currentpwd}/gpdb-sandbox-tutorials/faa/L_ONTIME_DELAY_GROUPS.csv'  CSV HEADER"
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "${targetcommand}"

targetcommand="\COPY faa.d_delay_groups FROM '${currentpwd}/gpdb-sandbox-tutorials/faa/L_ONTIME_DELAY_GROUPS.csv'  CSV HEADER"
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "${targetcommand}"

targetcommand="\COPY faa.faa_otp_load FROM '${currentpwd}/gpdb-sandbox-tutorials/faa/otp201001'  CSV HEADER"
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "${targetcommand}"


#psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} -d ${GREENPLUM_DB} -c "\COPY faa.d_airlines FROM './gpdb-sandbox-tutorials/faa/L_AIRPORTS.csv'  CSV HEADER"
psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "select count(*) from faa.d_airlines"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "select count(*) from faa.d_airports"

psql -h ${GREENPLUM_HOST} -U ${GREENPLUM_USER} ${GREENPLUM_DB} -c "\d faa.otp_c"

cd $current
