# How to setup Greenplum database
This readme describes how to setup Greenplum that is running inside docker.

## Pre-requisites:
- [docker-compose](http://docs.docker.com/compose)

# Using docker-compose to initialize Greenplum cluster
To create a standalone Greenplum cluster with the following command below. It builds a docker image with Pivotal Greenplum binaries and download some existing images such as Spark master and worker.
```
    docker-compose up
```
The Greenplum DB cluster will be running at `greenplumsparkconnector_gpdb_1` with two segments. To access this docker instance, exec into a container:
```
  $ docker exec -it greenplumsparkconnector_gpdb_1 bin/bash
```  

##  How to run the setupDB.sh
1. Connect to the GPDB docker image
```
 $ docker exec -it greenplumsparkconnector_gpdb_1 bin/bash
```
2. Execute the command below to access the scripts folder under "/code/data"
```
[root@d632f535db87]# cd /code/data
```

3. Run `scripts/setupDB.sh`, in order to create a database and table.
```
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
```

4. Run the following psql command to verify database (basic_db) and table (basictable) are created correctly.
```
[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "\dt" -w pivotal
psql: warning: extra command-line argument "pivotal" ignored
           List of relations
 Schema |    Name    | Type  |  Owner
--------+------------+-------+---------
 public | basictable | table | gpadmin
(1 row)

[root@d632f535db87 data]# psql -h localhost -U gpadmin -d basic_db -c "select count(*) from basictable" -w pivotal
psql: warning: extra command-line argument "pivotal" ignored
 count
-------
  9216
(1 row)

```
