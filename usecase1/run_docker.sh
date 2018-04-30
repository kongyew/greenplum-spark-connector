#!/bin/bash
export DOCKER_LABEL="cloudera"
export DOCKER_TAG="cloudera/quickstart:latest"

docker run  -it -h quickstart.cloudera \
    --publish 8020:8020 \
    --publish 8022:22 \
    --publish 7180:7180 \
    --publish 8888:8888 \
    --publish 11000:11000 \
    --publish 50070:50070 \
    --volume /tmp:/tmp/volume \
    ${DOCKER_TAG} bin/bash


#docker exec -it gpdb5 sudo -u gpadmin psql
# - "8020:8020"
# - "8022:22"     # ssh
# - "7180:7180"   # Cloudera Manager
# - "8888:8888"   # HUE
# - "11000:11000" # Oozie
# - "50070:50070" # HDFS REST Namenode
# - "2181:2181"
# - "11443:11443"
# - "9090:9090"
# - "8088:8088"
# - "19888:19888"
# - "9092:9092"
# - "8983:8983"
# - "16000:16000"
# - "16001:16001"
# - "42222:22"
# - "8042:8042"
# - "60010:60010"
# - "8080:8080"
# - "7077:7077"
