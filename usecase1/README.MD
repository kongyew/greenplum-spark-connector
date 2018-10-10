# Pivotal Greenplum
The Pivotal Greenplum Database (GPDB) is an advanced, fully featured, open source data warehouse. It provides powerful and rapid analytics on petabyte scale data volumes. Uniquely geared toward big data analytics, Greenplum Database is powered by the world’s most advanced cost-based query optimizer delivering high analytical query performance on large data volumes.

<https://pivotal.io/pivotal-greenplum>

# Pivotal Greenplum-Spark Connector
The [Pivotal Greenplum-Spark Connector](http://greenplum-spark.docs.pivotal.io/) provides high speed, parallel data transfer between Greenplum Database and Apache Spark clusters to support:

- Interactive data analysis
- In-memory analytics processing
- Batch ETL

# Apache Spark
Spark is a fast and general cluster computing system for Big Data. It provides
high-level APIs in Scala, Java, Python, and R, and an optimized engine that
supports general computation graphs for data analysis. It also supports a
rich set of higher-level tools including Spark SQL for SQL and DataFrames,
MLlib for machine learning, GraphX for graph processing,
and Spark Streaming for stream processing.
<http://spark.apache.org/>

# Table of Contents
1. [Pre-requisites](#Pre-requisites)
2. [Using docker-compose](#Using-docker-compose)
3. [Connect to Greenplum and Spark via Greenplum-Spark connector](#How-to-connect-to-Greenplum-and-Spark-via-Greenplum-Spark-connector)
4. [Read data from Greenplum into Spark](#Read-data-from-Greenplum-into-Spark)
5. [Write data from Spark DataFrame into Greenplum - with JDBC](#How-to-write-data-from-Spark-DataFrame-into-Greenplum)
6. [Using pySpark](README_PySpark.md)


## Pre-requisites:
- [docker-compose](http://docs.docker.com/compose)
- [Greenplum-Spark connector](http://greenplum-spark.docs.pivotal.io/100/index.html)
- [Postgres JDBC driver - if you want to write data from Spark into Greenplum ](https://jdbc.postgresql.org/download/postgresql-42.2.5.jar)

# Using docker-compose:
To create a standalone Greenplum cluster with the following command in the github root directory.
It builds a docker image with Pivotal Greenplum binaries and download some existing images such as Spark master and worker. Initially, it may take some time to download the docker image.
```
    $ ./runDocker.sh -t usecase1 -c up
Creating network "docker_default" with the default driver
Creating docker_master_1 ... done
Creating docker_worker_1 ... done
Creating gpdbsne         ... done
Attaching to docker_master_1, docker_worker_1, gpdbsne
...

```
The SparkUI will be running at `http://localhost:8081` with one worker listed.

To access `Greenplum cluster`, exec into a container:
```
    $ docker exec -it gpdbsne bin/bash
    root@master:/usr/spark-2.1.0#
```
## Setup Greenplum with sample tables
Follow this [readme](usecase1/ README_DB.md)

##  Connect to Greenplum and Spark via Greenplum-Spark connector
In this example, we will describe how to configure Greenplum-Spark connector when you run Spark-shell.

1. Make sure you download greenplum-spark_2.11-1.5.0.jar or latest jar from Pivotal Network.

2. Connect to the Spark master docker image
```
$ docker exec -it usecase1_master_1 bash
```
3. Run the command to start a spark shell that loads Greenplum-Spark connector. This section assumes you have downloaded latest greenplum-spark.jar under the github repo with subfolder `scripts`.  The root directory is mounted by the docker images under /code directory.  You can also use scripts such as `scripts/download_postgresql.sh` to download binaries.

Also, we included Postgresql (optional), in order to write data from Spark into Greenplum. Greenplum-Spark connector will support write features in future release and support parallel data transfer that performs significantly better than JDBC driver.
```

root@master:/usr/spark-2.1.0#GSC_JAR=$(ls /code/scripts/greenplum-spark_2.11-*.jar)
root@master:/usr/spark-2.1.0#POSTGRES_JAR=$(ls /code/scripts/postgresql-*.jar)
root@master:/usr/spark-2.1.0#spark-shell --jars "${GSC_JAR},${POSTGRES_JAR}" --driver-class-path ${POSTGRES_JAR}
...
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.0
      /_/

Using Scala version 2.11.8 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_112)
Type in expressions to have them evaluated.
Type :help for more information.
scala>
```

4. Verify Greenplum-Spark driver is successfully loaded by Spark Shell
You can follow the example below to verify the Greenplum-Spark driver. The scala repl confirms the driver is accessible by returning `res0` result.
```
scala> Class.forName("io.pivotal.greenplum.spark.GreenplumRelationProvider")
res0: Class[_] = class io.pivotal.greenplum.spark.GreenplumRelationProvider
```

Verify JDBC driver is successfully loaded by Spark Shell
You can follow the example below to verify the JDBC driver. The scala repl confirms the driver is accessible by returning `res1` result.
```
scala> Class.forName("org.postgresql.Driver")
res1: Class[_] = class org.postgresql.Driver
```

## Read data from Greenplum into Spark
In this section, we will read data from Greenplum into Spark. It assumes the database and table are already created. See [how to setup GPDB DB with script](README_DB.md)

1. By default, you can run the command below to retrieve data from Greenplum with a single data partition in Spark cluster. In order to paste the command, you need to type `:paste` in the scala environment and paste the code below, followed by `Ctrl-D`
```
scala> :paste
// Entering paste mode (ctrl-D to finish)
// that gives an one-partition Dataset

val dataFrame = spark.read.format("greenplum")
.option("url", "jdbc:postgresql://gpdbsne/basic_db")
.option("user", "gpadmin")
.option("password", "pivotal")
.option("dbschema", "public")
.option("dbtable", "basictable")
.option("partitionColumn", "id")
.load()

// Exiting paste mode, now interpreting.

```
2. You can verify the Spark DataFrame by running these commands `dataFrame.printSchema` and `dataFrame.show()`
```
scala> dataFrame.printSchema
root
 |-- id: integer (nullable = false)
 |-- value: string (nullable = true)
scala> dataFrame.show()
+---+--------+
| id|   value|
+---+--------+
|  1|   Alice|
|  3| Charlie|
|  5|     Jim|
|  7|    Jack|
|  9|     Zim|
| 15|     Jim|
| 11|     Bob|
| 13|     Eve|
| 17|Victoria|
| 25|Victoria|
| 27|   Alice|
| 29| Charlie|
| 31|     Zim|
| 19|   Alice|
| 21| Charlie|
| 23|     Jim|
| 33|     Jim|
| 35|     Eve|
| 43|Victoria|
| 45|   Alice|
+---+--------+
only showing top 20 rows
scala> dataFrame.filter(dataFrame("id") > 40).show()
+---+--------+
| id|   value|
+---+--------+
| 41|     Jim|
| 43|    Jack|
| 45|     Zim|
| 47|   Alice|
| 49| Charlie|
| 51|     Jim|
| 53|    Jack|
| 55|     Bob|
| 57|     Eve|
| 59|    John|
| 61|Victoria|
| 63|     Zim|
| 65|     Bob|
| 67|     Eve|
| 69|    John|
| 71|Victoria|
| 73|     Bob|
| 75|   Alice|
| 77| Charlie|
| 79|     Jim|
+---+--------+
only showing top 20 rows

scala> dataFrame.explain
== Physical Plan ==
*Scan GreenplumRelation(StructType(StructField(id,IntegerType,false), StructField(value,StringType,true)),[Lio.pivotal.greenplum.spark.GreenplumPartition;@738ed8f5,io.pivotal.greenplum.spark.GreenplumOptions@1cfb7450) [id#0,value#1]
```

3. You create a temporary table to cache the results from Greenplum and using option to speed your in-memory processing in Spark cluster.  [Global temporary view](https://spark.apache.org/docs/latest/sql-programming-guide.html) is tied to a system preserved database global_temp, and we must use the qualified name to refer it, e.g. SELECT * FROM global_temp.view1. Meanwhile, Temporary views in Spark SQL are session-scoped and will disappear if the session that creates it terminates.
```
scala>
// Register the DataFrame as a global temporary view
dataFrame.createGlobalTempView("tempdataFrame")

// Global temporary view is tied to a system preserved database `global_temp`
spark.sql("SELECT * FROM global_temp.tempdataFrame").show()
```


## How to write data from Spark DataFrame into Greenplum
In this section, you can write data from Spark DataFrame into Greenplum table. by using JDBC driver. Please note: Greenplum - Spark connector does NOT yet support data transfer from Spark into Greenplum.

Pre-requisites:
1. Run the script under scripts/download_postgresql.sh to download postgresql-42.2.5.jar

2. Make sure your spark shell is loaded the Postgresql jar.
```
root@master:/usr/spark-2.1.0#GSC_JAR=$(ls /code/scripts/greenplum-spark_2.11-*.jar)
root@master:/usr/spark-2.1.0#POSTGRES_JAR=$(ls /code/scripts/postgresql-*.jar)
root@master:/usr/spark-2.1.0#spark-shell --jars "${GSC_JAR},${POSTGRES_JAR}" --driver-class-path ${POSTGRES_JAR}
...
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.0
      /_/

Using Scala version 2.11.8 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_112)
Type in expressions to have them evaluated.
Type :help for more information.
scala>
```


3. Determine the number of records in the "basictable" table by using psql command.  
```
$ docker exec -it gpdbsne /bin/bash
[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable"

 count
-------
18432
(1 row)
```
2. Configure JDBC URL and connection Properties and use DataFrame write operation to write data from Spark into Greenplum. You can use different write mode
```
scala> :paste
// Entering paste mode (ctrl-D to finish)

val jdbcUrl = s"jdbc:postgresql://gpdbsne/basic_db?user=gpadmin&password=pivotal"
val connectionProperties = new java.util.Properties()
dataFrame.write.mode("Append") .jdbc( url = jdbcUrl, table = "basictable", connectionProperties = connectionProperties)

// Exiting paste mode, now interpreting.

```
3. Verify the write operation is successful by exec into GPDB container and run psql command-line. The total number records in the Greenplum table must be 2x of the original data.
```
$ docker exec -it gpdbsne /bin/bash
[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable" -w pivotal
psql: warning: extra command-line argument "pivotal" ignored
 count
-------
`18432`
(1 row)
```

4. Next, you can write DataFrame data into an new Greenplum table via `append` mode.
```
scala>dataFrame.write.mode("Append") .jdbc( url = jdbcUrl, table = "NEWTable", connectionProperties = connectionProperties)
```

5. Run psql commands to verify the new table with new records.
```
[root@d632f535db87 scripts]# psql -h localhost -U gpadmin -d basic_db -c "\dt"
List of relations
Schema |            Name             | Type  |  Owner
--------+-----------------------------+-------+---------
public | basictable                  | table | gpadmin
public | newtable                    | table | gpadmin
public | spark_7ac1947b17a17725_0_41 | table | gpadmin
public | spark_7ac1947b17a17725_0_42 | table | gpadmin
(4 rows)

[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from newtable" -w pivotal
psql: warning: extra command-line argument "pivotal" ignored
 count
-------
18432
(1 row)
```

## Conclusions
Greenplum-Spark connector uses Greenplum gpfdist protocol to parallelize data transfer between Greenplum and Spark clusters. Therefore, this connector provides better read throughput, compared to typical JDBC driver.

For more details, see this [link](http://greenplum-spark.docs.pivotal.io)

## License
MIT
