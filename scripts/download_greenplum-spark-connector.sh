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
export PIVNET_TOKEN=H9sn5XbmcKWySySPhNxv


# GSC 1.6.0 - sha 3ca929f1bb030bda085e56b2e3cfc912e879ad60c1b63f36815d75b5e69903ad
# Link: https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/225597/product_files/243101/download
export LOCAL_FILE_NAME=greenplum-spark_2.11-1.6.0.jar

export DOWNLOAD_URL=https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/225597/product_files/243101/download
wget -O "$LOCAL_FILE_NAME" --post-data="" --header="Authorization: Token $PIVNET_TOKEN" $DOWNLOAD_URL

cd $current
