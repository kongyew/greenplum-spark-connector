
##  How to connect to Greenplum and Spark with PySpark
In this example, we will describe how to use pySpark

1. Connect to the Spark master docker image
```
$ docker exec -it docker_master_1 /bin/bash
```
2. Execute the command below to run pySpark
```
root@master:/usr/spark-2.1.0#GSC_JAR=$(ls /code/greenplum-spark_2.11-*.jar)
root@master:/usr/spark-2.1.0#pyspark --jars "${GSC_JAR}"
Python 3.4.2 (default, Oct  8 2014, 10:45:20)
[GCC 4.9.1] on linux
Type "help", "copyright", "credits" or "license" for more information.
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
17/09/23 18:51:37 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 2.1.1
      /_/

Using Python version 3.4.2 (default, Oct  8 2014 10:45:20)
SparkSession available as 'spark'.
```

3. To load a DataFrame from a Greenplum table in PySpark

```
>>>source_df = sqlContext.read.format('io.pivotal.greenplum.spark.GreenplumRelationProvider').options(
          url='jdbc:postgresql://docker_gpdb_1/basic_db',
          driver='com.mysql.jdbc.Driver',
          dbtable='basictable',
          user='gpadmin',
          password='pivotal',
          driver='org.postgresql.Driver',
          partitionColumn='id').load()


```
4. Verify source dataframe by running these commands
```
>>> source_df.count()
18432
>>> source_df.printSchema()
root
 |-- id: integer (nullable = false)
 |-- value: string (nullable = true)

>>> source_df.show()
+---+--------+
| id|   value|
+---+--------+
|  1|   Alice|
|  3| Charlie|
|  5|     Jim|
|  7|    Jack|
|  9|     Zim|
| 13|    John|
| 11|   Alice|
| 15| Charlie|
| 17|    Jack|
| 19|   Alice|
| 21|     Jim|
| 23|     Zim|
| 25|   Alice|
| 27|    Jack|
| 29|     Eve|
| 31|Victoria|
| 33|     Eve|
| 35|     Jim|
| 37|     Bob|
| 39|     Eve|
+---+--------+
only showing top 20 rows
```

## How to write data from Spark DataFrame into Greenplum
In this section, you can write data from Spark DataFrame into Greenplum table.

1. Determine the number of records in the "basictable" table by using psql command.  
```
$ docker exec -it docker_gpdb_1 /bin/bash
[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable"
 count
-------
18432
(1 row)
```
2. Configure JDBC URL and connection Properties and use DataFrame write operation to write data from Spark into Greenplum.
```
source_df.write.format('jdbc').options(
    url='jdbc:postgresql://docker_gpdb_1/basic_db',
    dbtable='basictable',
    user='gpadmin',
    password='pivotal',
    driver='org.postgresql.Driver').mode('append').save()

```
3. Verify the write operation is successful by exec into GPDB container and run psql command-line. The total number records in the Greenplum table must be 2x of the original data.
```
$ docker exec -it docker_gpdb_1 /bin/bash
[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable"
 count
-------
`36864`
(1 row)
```
