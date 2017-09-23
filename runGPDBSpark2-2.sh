#!/bin/bash
# Dockerfiles are located under `docker` directory

# Use override file to configure Spark 2.2 (docker-compose_spark2-2.yml)
docker-compose -f docker/docker-compose.yml -f docker/docker-compose_spark2-2.yml  up -d
