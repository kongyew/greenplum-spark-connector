###########################
 Setup Greenplum and Spark
###########################

Pivotal Greenplum
====================
The Pivotal Greenplum Database  (GPDB) is an advanced, fully featured, open source data warehouse. It provides powerful and rapid analytics on petabyte scale data volumes. Uniquely geared toward big data analytics, Greenplum Database is powered by the world’s most advanced cost-based query optimizer delivering high analytical query performance on large data volumes.

<https://pivotal.io/pivotal-greenplum>


Pivotal Greenplum-Spark Connector
==================================
The [Pivotal Greenplum-Spark Connector](http://greenplum-spark.docs.pivotal.io/100/index.html) provides high speed, parallel data transfer between Greenplum Database and Apache Spark clusters to support:

- Interactive data analysis
- In-memory analytics processing
- Batch ETL

Apache Spark
=============
Spark is a fast and general cluster computing system for Big Data. It provides
high-level APIs in Scala, Java, Python, and R, and an optimized engine that
supports general computation graphs for data analysis. It also supports a
rich set of higher-level tools including Spark SQL for SQL and DataFrames,
MLlib for machine learning, GraphX for graph processing,
and Spark Streaming for stream processing.
<http://spark.apache.org/>



## Pre-requisites:
=================================================================
- [docker-compose](http://docs.docker.com/compose)
- [Greenplum-Spark connector](http://greenplum-spark.docs.pivotal.io/100/index.html)
- [Postgres JDBC driver - if you want to write data from Spark into Greenplum ](https://jdbc.postgresql.org/download/postgresql-42.1.4.jar)


# Using docker-compose
=================================================================
To create a standalone Greenplum cluster with the following command in the github root directory.
It builds a docker image with Pivotal Greenplum binaries and download some existing images such as Spark master and worker. Initially, it may take some time to download the docker image.

.. code-block:: bash

    $ runGPDBSpark2-1.sh
    docker_master_1 is up-to-date
    Creating docker_gpdb_1 ...
    Creating docker_worker_1 ...
    Creating docker_gpdb_1
    Creating docker_gpdb_1 ... done


The SparkUI will be running at `http://localhost:8080` with one worker listed.

To access `Greenplum cluster`, exec into a container:

.. code-block:: bash

    $ docker exec -it docker_gpdb_1 bash
    root@master:/usr/spark-2.1.0#


Setup Greenplum with sample tables
=================================================================
Follow this [readme](README_DB.md)

Connect to Spark master instance
=================================================================

1. Connect to the Spark master docker image

.. code-block:: bash

  $ docker exec -it docker_master_1 /bin/bash

Connect to Greenplum instance
=================================================================

1. Connect to the GPDB docker image

.. code-block:: bash

  $ docker exec -it docker_gpdb_1 /bin/bash