#!/bin/bash
# Including configurations
. config.sh

# https://hub.docker.com/r/gettyimages/spark/
docker run --rm -it -p 4040:4040 gettyimages/spark bin/run-example SparkPi 10
