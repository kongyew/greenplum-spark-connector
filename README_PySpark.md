# Using docker-compose to access pySpark
To create a standalone Greenplum cluster with the following command in the github root directory.
It builds a docker image with Pivotal Greenplum binaries and download some existing images such as Spark master and worker. Initially, it may take some time to download the docker image.
```
    $ docker-compose up
```

The SparkUI will be running at `http://${YOUR_DOCKER_HOST}:8080` with one worker listed. To run `pyspark`, exec into a container:
```
    $ docker exec -it greenplumsparkconnector_master_1 bash
    $ bin/pyspark
```
To run `SparkPi`, exec into a container:
```
    $ docker exec -it greenplumsparkconnector_master_1 bash
    $ bin/run-example SparkPi 10
```

To access `Greenplum cluster`, exec into a container:
```
    $ docker exec -it greenplumsparkconnector_master_1 bash
    root@master:/usr/spark-2.1.0#
```

##  How to connect to Greenplum and Spark via JDBC driver
In this example, we will describe how to configure JDBC driver when you run Spark-shell.

1. Connect to the Spark master docker image
```
$ docker exec -it greenplumsparkconnector_master_1 /bin/bash

GSC_JAR=$(ls /code/greenplum-spark_2.11-*.jar)
spark-shell --jars "${GSC_JAR}"
```
2. Execute the command below to download jar into `~/.ivy2/jars` directory and type `:quit` to exit the Spark shell
```
root@master:/usr/spark-2.1.0#bin/spark-shell --packages org.postgresql:postgresql:42.1.1

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

4. Verify Greenplum-Spark driver is successfully loaded by Spark Shell
You can follow the example below to verify the Greenplum-Spark driver. The scala repl confirms the driver is accessible by returning `res0` result.
```
scala> Class.forName("io.pivotal.greenplum.spark.GreenplumRelationProvider")
res0: Class[_] = class io.pivotal.greenplum.spark.GreenplumRelationProvider
```
df = sqlContext.read.format('jdbc').options(url='jdbc:postgresql:dbserver', dbtable='(select id,name from emp) as emp').load()
shareedit
edited May 23 at 12:02

Community♦
11
answered Dec 7 '15 at 10:17

Kaushal
1,09321231
add a comment


val dataFrame = spark.read.format("io.pivotal.greenplum.spark.GreenplumRelationProvider")
.option("dbtable", "basictable")
.option("url", "jdbc:postgresql://greenplumsparkconnector_gpdb_1/basic_db")
.option("user", "gpadmin")
.option("password", "pivotal")
.option("driver", "org.postgresql.Driver")
.option("partitionColumn", "id")
.load()


## How read data from Greenplum into Spark
In this section, we will read data from Greenplum into Spark. It assumes the database and table are already created. See [how to setup GPDB DB with script](README_DB.md)

By default, you can run the command below to retrieve data from Greenplum with a single data partition in Spark cluster. In order to paste the command, you need to type `:paste` in the scala environment and paste the code below, followed by `Ctrl-D`
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

You can verify the Spark DataFrame by running these commands `df.printSchema` and `df.show()`
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

## Performance Limitations:
Apache Spark provides parallel data transfer to Greenplum via JDBC driver and this data transfer process works between Greenplum master host and Spark workers. Thus, the performance constraints are limited as it is not using the high speed data transfer features provided by Greenplum gpfdist protocol.

## Conclusions
In summary, Greenplum works seamlessly with Apache Spark by using Postgresql JDBC driver.

## License
MIT
