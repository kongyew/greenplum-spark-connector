#!/bin/bash

current=`pwd`

cd `dirname $0`

# https://jdbc.postgresql.org/download.html
wget -O postgresql-42.2.2.jar https://jdbc.postgresql.org/download/postgresql-42.2.2.jar

cd $current
