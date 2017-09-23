#!/bin/bash
set -e
set -u
set -x

#!/bin/bash

export PIVNET_TOKEN=PASTE_THIS_FROM_PIVNET_USER_PROFILE
export LOCAL_FILE_NAME=greenplum-spark_2.11-1.0.0.jar
export DOWNLOAD_URL=https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/7106/product_files/30352/download
wget -O "$LOCAL_FILE_NAME" --post-data="" --header="Authorization: Token $PIVNET_TOKEN" $DOWNLOAD_URL
