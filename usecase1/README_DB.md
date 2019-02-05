# How to setup Greenplum database
This readme describes how to setup Greenplum that is running inside docker.

## Pre-requisites:
- [docker-compose](http://docs.docker.com/compose)

# Verify the docker instance is running
Make sure the docker instances are running by running `docker ps`
```
  $ docker ps
CONTAINER ID        IMAGE                                COMMAND                  CREATED             STATUS              PORTS                                                                                                                                                        NAMES
b14bf4a39041        kochanpivotal/gpdb5oss               "/docker-entrypoint.…"   8 minutes ago       Up 8 minutes        0.0.0.0:5005->5005/tcp, 0.0.0.0:5010->5010/tcp, 0.0.0.0:5432->5432/tcp, 0.0.0.0:9090->9090/tcp, 0.0.0.0:40000-40002->40000-40002/tcp, 0.0.0.0:9022->22/tcp   gpdbsne
785d2673eb77        gettyimages/spark:2.1.1-hadoop-2.7   "bin/spark-class org…"   8 minutes ago       Up 8 minutes        7012-7016/tcp, 8881/tcp, 0.0.0.0:8081->8081/tcp                                                                                                              sparkworker
bd5591f409d6        gettyimages/spark:latest             "bin/spark-class org…"   8 minutes ago       Up 8 minutes        0.0.0.0:4040->4040/tcp, 0.0.0.0:6066->6066/tcp, 0.0.0.0:7077->7077/tcp, 0.0.0.0:8080->8080/tcp, 7001-7006/tcp                                                sparkmaster
```  


##  How to run the setupDB.sh
1. Connect to the GPDB docker image
The Greenplum DB cluster will be running at `gpdbsne` with two segments. To access this docker instance, exec into a container:
```
  $ docker exec -it gpdbsne bin/bash
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
