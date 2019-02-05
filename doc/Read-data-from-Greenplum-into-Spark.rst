#########################################
 Reading data from Greenplum into Spark
#########################################

In this example, we will describe how to configure Greenplum-Spark connector when you run Spark-shell. It assumes the database and table are already created.

1. Make sure you download greenplum-spark_2.11-x.x.jar from `Pivotal Network <https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/7106/product_files/30352/download/>`_. 

2. Connect to the Spark master instance.

.. code-block:: java

	$ docker exec -it sparkmaster /bin/bash

3. Run the command to start a spark shell that loads Greenplum-Spark connector. This section assumes you have downloaded greenplum-spark_2.11.jar under the github repo with subfolder `scripts`.  The root directory is mounted by the docker images under /code directory.  You can also use scripts such as `scripts/download_postgresql.sh` and `scripts/download_greenplum-spark-connector.sh` to download required binaries.

Also, we included Postgresql, in order to write data from Spark into Greenplum. Greenplum-Spark connector will support write features in future release and support parallel data transfer that performs significantly better than JDBC driver.


.. code-block:: java
   :emphasize-lines: 1-3

	root@master:/usr/spark-2.1.0#GSC_JAR=$(ls /code/scripts/greenplum-spark_2.11-*.jar)
	root@master:/usr/spark-2.1.0#POSTGRES_JAR=$(ls /code/scripts/postgresql-*.jar)
	root@master:/usr/spark-2.1.0#spark-shell --jars "${GSC_JAR},${POSTGRES_JAR}" --driver-class-path ${POSTGRES_JAR}
	...
	Using Scala version 2.11.8 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_112)
	Type in expressions to have them evaluated.
	Type :help for more information.
	scala>


4. Verify Greenplum-Spark driver is successfully loaded by Spark Shell.
You can follow the example below to verify the Greenplum-Spark driver. The scala repl confirms the driver is accessible by returning `res0` result.

.. code-block:: java

	scala> Class.forName("io.pivotal.greenplum.spark.GreenplumRelationProvider")
	res0: Class[_] = class io.pivotal.greenplum.spark.GreenplumRelationProvider

Verify JDBC driver is successfully loaded by Spark Shell.
You can follow the example below to verify the JDBC driver. The scala repl confirms the driver is accessible by returning `res1` result.


.. code-block:: java

	scala> Class.forName("org.postgresql.Driver")
	res1: Class[_] = class org.postgresql.Driver


5. By default, you can run the command below to retrieve data from Greenplum with a single data partition in Spark cluster. In order to paste the command, you need to type `:paste` in the scala environment and paste the code below, followed by `Ctrl-D`.

.. code-block:: java

	scala> :paste
	// Entering paste mode (ctrl-D to finish)
	// that gives an one-partition Dataset
	val dataFrame = spark.read.format("io.pivotal.greenplum.spark.GreenplumRelationProvider")
	.option("dbtable", "basictable")
	.option("url", "jdbc:postgresql://gpdbsne/basic_db")
	.option("user", "gpadmin")
	.option("password", "pivotal")
	.option("driver", "org.postgresql.Driver")
	.option("partitionColumn", "id")
	.load()
	// Exiting paste mode, now interpreting.


2. You can verify the Spark DataFrame by running these commands `dataFrame.printSchema` and `dataFrame.show()`.

.. code-block:: java

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

.. code-block::java

	scala> dataFrame.explain
	\\== Physical Plan \\==
	*Scan GreenplumRelation(StructType(StructField(id,IntegerType,false), StructField(value,StringType,true)),[Lio.pivotal.greenplum.spark.GreenplumPartition;@738ed8f5,io.pivotal.greenplum.spark.GreenplumOptions@1cfb7450) [id#0,value#1]


3. You create a temporary table to cache the results from Greenplum and using option to speed your in-memory processing in Spark cluster.   `Global temporary view <https://spark.apache.org/docs/latest/sql-programming-guide.html>`_. is tied to a system preserved database global_temp, and we must use the qualified name to refer it, e.g. SELECT * FROM global_temp.view1. Meanwhile, Temporary views in Spark SQL are session-scoped and will disappear if the session that creates it terminates.

.. code-block:: java

	scala>
	// Register the DataFrame as a global temporary view
	dataFrame.createGlobalTempView("tempdataFrame")
	// Global temporary view is tied to a system preserved database `global_temp`
	spark.sql("SELECT * FROM global_temp.tempdataFrame").show()


Conclusions
------------

Greenplum-Spark connector uses Greenplum gpfdist protocol to parallelize data transfer between Greenplum and Spark clusters. Therefore, this connector provides better read throughput, compared to typical JDBC driver.

