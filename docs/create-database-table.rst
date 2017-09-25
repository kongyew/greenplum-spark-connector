#########################################
How to setup Greenplum database and table
#########################################


This readme describes how to setup Greenplum database and table(s).

Pre-requisites:
===============

- `docker-compose <http://docs.docker.com/compose>`_.




Run the docker instances:
=======================================

You can run spark and GPDB instances by using existing scripts.

.. code-block:: bash

	  $./runGPDBSpark2-1.sh

Verify the docker instance is running:
=======================================


Make sure the docker instances are running by running `docker ps`

.. code-block:: bash

	  $ docker ps

How to run the setupDB:
=======================================


This setupDB.sh script automatically creates default database and table(s). The script is located under `<src>/data/scripts/setupDB.sh`.

1. Connect to the GPDB docker image
The Greenplum DB cluster will be running with this instance name: `docker_gpdb_1` with two segments. To access this docker instance, exec into a container:

.. code-block:: bash

	$ docker exec -it docker_gpdb_1 bin/bash
 

2. Execute the command below to access the scripts folder under "/code/data"

.. code-block:: bash

	[root@d632f535db87]# cd /code/data

3. Run `scripts/setupDB.sh`, in order to create a database and table.

.. code-block:: bash

	[root@d632f535db87 data]# scripts/setupDB.sh
	psql:./sample_table.sql:1: NOTICE:  table "basictable" does not exist, skipping
	DROP TABLE
	psql:./sample_table.sql:5: NOTICE:  CREATE TABLE will create implicit sequence "basictable_id_seq" for serial column "basictable.id"
	CREATE TABLE
	INSERT 0 1
	INSERT 0 1
	INSERT 0 1
	INSERT 0 1
	INSERT 0 1
	INSERT 0 1
	INSERT 0 1
	INSERT 0 1
	INSERT 0 1
	INSERT 0 9
	INSERT 0 18
	INSERT 0 36
	INSERT 0 72
	INSERT 0 144
	INSERT 0 288
	INSERT 0 576
	INSERT 0 1152
	INSERT 0 2304
	INSERT 0 4608

4. Run the following psql command to verify database (basic_db) and table (basictable) are created correctly.

.. code-block:: bash

	[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "\dt" 
	           List of relations
	 Schema |    Name    | Type  |  Owner
	--------+------------+-------+---------
	 public | basictable | table | gpadmin
	(1 row)

.. code-block:: bash

	[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable" 
	 count
	-------
	  9216
	(1 row)
