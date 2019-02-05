################################################
 Writing data from Spark into Greenplum via JDBC
################################################

In this section, you can write data from Spark DataFrame into Greenplum table by using JDBC driver.  

1. Run the script under scripts/download_postgresql.sh to download postgresql jar to the directory 'scripts'.

.. code-block:: bash
   :emphasize-lines: 1

	$ scripts/download_postgreql.sh
	...
	HTTP request sent, awaiting response... 200 OK
	Length: 713037 (696K) [application/java-archive]
	Saving to: ‘postgresql-42.1.4.jar’
	postgresql-42.1.4.jar         100%[=================================================>] 696.33K   850KB/s    in 0.8s
	2017-09-24 20:59:25 (850 KB/s) - ‘postgresql-42.1.4.jar’ saved [713037/713037]


2. Make sure your spark shell is loaded the Postgresql jar.

.. code-block::java
   :emphasize-lines: 1-3

	root@master:/usr/spark-2.1.0#GSC_JAR=$(ls /code/scripts/greenplum-spark_2.11-*.jar)
	root@master:/usr/spark-2.1.0#POSTGRES_JAR=$(ls /code/scripts/postgresql-*.jar)
	root@master:/usr/spark-2.1.0#spark-shell --jars "${GSC_JAR},${POSTGRES_JAR}" --driver-class-path ${POSTGRES_JAR}
	...
	Using Scala version 2.11.8 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_112)
	Type in expressions to have them evaluated.
	Type :help for more information.
	scala>


3. Determine the number of records in the "basictable" table by using psql command.  

.. code-block:: bash

	$ docker exec -it docker_gpdb_1 /bin/bash
	[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable"

4. Configure JDBC URL and connection Properties and use DataFrame write operation to write data from Spark into Greenplum. You can use different write mode

.. code-block:: java

	scala> :paste
	// Entering paste mode (ctrl-D to finish)
	val jdbcUrl = s"jdbc:postgresql://docker_gpdb_1/basic_db?user=gpadmin&password=pivotal"
	val connectionProperties = new java.util.Properties()
	dataFrame.write.mode("Append") .jdbc( url = jdbcUrl, table = "basictable", connectionProperties = connectionProperties)
	// Exiting paste mode, now interpreting.


5. Verify the write operation is successful by exec into GPDB container and run psql command-line. The total number records in the Greenplum table must be 2x of the original data.

.. code-block:: bash

	$ docker exec -it docker_gpdb_1 /bin/bash
	[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable" 

6. Next, you can write DataFrame data into an new Greenplum table via `append` mode.

.. code-block:: java

	scala>dataFrame.write.mode("Append") .jdbc( url = jdbcUrl, table = "NEWTable", connectionProperties = connectionProperties)

7. Run psql commands to verify the new table with new records.

.. code-block:: bash

	[root@d632f535db87 scripts]# psql -h localhost -U gpadmin -d basic_db -c "\dt"
	List of relations
	Schema |            Name             | Type  |  Owner
	--------+-----------------------------+-------+---------
	public | basictable                  | table | gpadmin
	public | newtable                    | table | gpadmin
	public | spark_7ac1947b17a17725_0_41 | table | gpadmin
	public | spark_7ac1947b17a17725_0_42 | table | gpadmin
	(4 rows)




