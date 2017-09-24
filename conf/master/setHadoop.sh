#!/bin/bash

# Reference
# https://www.tutorialspoint.com/hadoop/hadoop_enviornment_setup.htm
export HADOOP_VERSION=2.7.2
export HADOOP_HOME=/usr/hadoop-$HADOOP_VERSION
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
