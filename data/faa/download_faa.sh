#!/bin/bash
pushd .

git clone https://github.com/greenplum-db/gpdb-sandbox-tutorials.git
cd gpdb-sandbox-tutorials
tar zxf faa.tar.gz

popd .
