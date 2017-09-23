#!/bin/bash

current=`pwd`

cd `dirname $0`

wget -O postgresql-42.1.4.jar https://jdbc.postgresql.org/download/postgresql-42.1.4.jar

cd $current
