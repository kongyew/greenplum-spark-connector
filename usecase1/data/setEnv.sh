#!/bin/bash
#
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


export POSTGRES_HOST=localhost
export POSTGRES_USER=dbuser
export POSTGRES_DB=streamsets_db
export POSTGRES_DB_PWD=dbuserpass
export PGPASSWORD=${POSTGRES_DB_PWD}

# Greenplum
export GREENPLUM_HOST=gpdbsne
export GREENPLUM_USER=gpadmin
export GREENPLUM_DB=gpadmin #
export GREENPLUM_DB_PWD=pivotal
export PGPASSWORD=${GREENPLUM_DB_PWD}
