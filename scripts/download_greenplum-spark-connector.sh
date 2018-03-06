#!/bin/bash
# Change PIVNET_TOKEN, in order to use this script
#
#
set -e
set -u
set -x


current=`pwd`

cd `dirname $0`
# Replace me with a valid Pivotal network token .  It is found under your profile ->PIVNET_TOKEN  (Link: https://network.pivotal.io/users/dashboard/edit-profile)
# if you have pivnet cli , check cat ~/.pivnetrc
export PIVNET_TOKEN=CHANGE_ME

export LOCAL_FILE_NAME=greenplum-spark_2.11-1.2.0.jar
export DOWNLOAD_URL=https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/50181/product_files/81988/download
wget -O "$LOCAL_FILE_NAME" --post-data="" --header="Authorization: Token $PIVNET_TOKEN" $DOWNLOAD_URL

cd $current
