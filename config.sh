#!/bin/bash
#
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export DOCKER_OSS_LABEL="GPDB 5 OSS"
export DOCKER_OSS_TAG="kochanpivotal/gpdb5oss"
export DOCKER_LATEST_OSS_TAG="kochanpivotal/gpdb5oss:latest"

# Use Cases specific
export DC_USE_CASE1_SCRIPT="docker-compose -f usecase1/docker-compose_spark2-3.yml"


export DC_USE_CASE2_SCRIPT="docker-compose -f usecase2/docker-compose.yml"


export DC_USE_CASE3_SCRIPT="docker-compose -f usecase3/docker-compose.yml"

# export DC_USE_CASE1_SCRIPT="docker-compose -f docker/docker-compose.yml"
# export DC_USE_CASE1_SCRIPT="docker-compose -f docker/docker-compose.yml -f docker/docker-compose_spark2-2.yml"
