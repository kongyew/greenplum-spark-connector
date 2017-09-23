# How to write data into Greenplum via JDBC
# Table of Contents
1. [Pre-requisites](#Pre-requisites)
2. [Using docker-compose](#Using docker-compose)
3. [Connect to Greenplum and Spark via Greenplum-Spark connector](#How to connect to Greenplum and Spark via Greenplum-Spark connector)
4. [Read data from Greenplum into Spark](#Read data from Greenplum into Spark)

## Pre-requisites:
- [docker-compose](http://docs.docker.com/compose)
- [Greenplum-Spark connector](http://greenplum-spark.docs.pivotal.io/100/index.html)

# Using docker-compose
To create a standalone Greenplum cluster with the following command in the github root directory.
It builds a docker image with Pivotal Greenplum binaries and download some existing images such as Spark master and worker. Initially, it may take some time to download the docker image.
```
    $ docker-compose up
```
The SparkUI will be running at `http://${YOUR_DOCKER_HOST}:8080` with one worker listed.

To access `Greenplum cluster`, exec into a container:
```
    $ docker exec -it greenplumsparkconnector_master_1 bash
    root@master:/usr/spark-2.1.0#
```
##  Use SparkShell with both JDBC and Greenplum-Spark connector
In this example, we will describe how to configure Greenplum-Spark connector and JDBC driver when you run Spark-shell. Currently, we need to use JDBC driver to write data from Spark into Greenplum

1. Make sure you download greenplum-spark_2.11.jar from Pivotal Network. And copy the jar into this sample's root directory.

2. Connect to the Spark master docker image
```
$ docker exec -it greenplumsparkconnector_master_1 /bin/bash
```

2. Execute the command below to download jar into `~/.ivy2/jars` directory and type `:quit` to exit the Spark shell
```
root@master:/usr/spark-2.1.0#bin/spark-shell --packages org.postgresql:postgresql:42.1.1
Ivy Default Cache set to: /root/.ivy2/cache
The jars for the packages stored in: /root/.ivy2/jars
:: loading settings :: url = jar:file:/usr/spark-2.1.0/jars/ivy-2.4.0.jar!/org/apache/ivy/core/settings/ivysettings.xml
org.postgresql#postgresql added as a dependency
:: resolving dependencies :: org.apache.spark#spark-submit-parent;1.0
	confs: [default]
	found org.postgresql#postgresql;42.1.1 in central
:: resolution report :: resolve 366ms :: artifacts dl 3ms
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

3. By default,the driver file is located at ~/.ivy2/jars/. Next, you can run your Spark-shell to load this Postgresql driver.
```
root@master:/usr/spark-2.1.0# bin/spark-shell --driver-class-path ~/.ivy2/jars/org.postgresql_postgresql-42.1.1.jar  --jars ~/.ivy2/jars/org.postgresql_postgresql-42.1.1.jar
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

4. Verify JDBC driver is successfully loaded by Spark Shell
You can follow the example below to verify the JDBC driver. The scala repl confirms the driver is accessible by returning `res1` result.
```
scala> Class.forName("org.postgresql.Driver")
res1: Class[_] = class org.postgresql.Driver
```


3. Run the command to start a spark shell that loads Greenplum-Spark connector.
```
root@master:/usr/spark-2.1.0#GSC_JAR=$(ls /code/greenplum-spark_2.11-*.jar)
root@master:/usr/spark-2.1.0#spark-shell --jars "${GSC_JAR}"
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
## Read data from Greenplum into Spark
In this section, we will read data from Greenplum into Spark. It assumes the database and table are already created. See [how to setup GPDB DB with script](README_DB.md)

1. By default, you can run the command below to retrieve data from Greenplum with a single data partition in Spark cluster. In order to paste the command, you need to type `:paste` in the scala environment and paste the code below, followed by `Ctrl-D`
```
scala> :paste
// Entering paste mode (ctrl-D to finish)
// that gives an one-partition Dataset
val dataFrame = spark.read.format("io.pivotal.greenplum.spark.GreenplumRelationProvider")
.option("dbtable", "basictable")
.option("url", "jdbc:postgresql://greenplumsparkconnector_gpdb_1/basic_db")
.option("user", "gpadmin")
.option("password", "pivotal")
.option("driver", "org.postgresql.Driver")
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

3. You create a temporary table to cache the results from Greenplum
```
scala> dataFrame.createGlobalTempView("people")

```


## How to write data from Spark DataFrame into Greenplum
In this section, you can write data from Spark DataFrame into Greenplum table.

1. Determine the number of records in the "basictable" table by using psql command.  
```
$ docker exec -it greenplumsparkconnector_gpdb_1 /bin/bash
[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable" -w pivotal
psql: warning: extra command-line argument "pivotal" ignored
 count
-------
18432
(1 row)
```
2. Configure JDBC URL and connection Properties and use DataFrame write operation to write data from Spark into Greenplum.
```
scala> :paste
// Entering paste mode (ctrl-D to finish)

val jdbcUrl = s"jdbc:postgresql://greenplumsparkconnector_gpdb_1/basic_db?user=gpadmin&password=pivotal"
val connectionProperties = new java.util.Properties()
dataFrame.write.mode("Append") .jdbc( url = jdbcUrl, table = "basictable", connectionProperties = connectionProperties)

// Exiting paste mode, now interpreting.

```
3. Verify the write operation is successful by exec into GPDB container and run psql command-line. The total number records in the Greenplum table must be 2x of the original data.
```
$ docker exec -it greenplumsparkconnector_gpdb_1 /bin/bash
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
[root@d632f535db87 scripts]# psql -h localhost -U gpadmin -d basic_db -c "\dt" -
psql: warning: extra command-line argument "pivotal" ignored
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

## License
MIT
