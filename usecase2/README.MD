# Pivotal Greenplum
The Pivotal Greenplum Database (GPDB) is an advanced, fully featured, open source data warehouse. It provides powerful and rapid analytics on petabyte scale data volumes. Uniquely geared toward big data analytics, Greenplum Database is powered by the world’s most advanced cost-based query optimizer delivering high analytical query performance on large data volumes.
<https://pivotal.io/pivotal-greenplum>

# Streamsets

<https://www.cloudera.com/>

# Table of Contents
1. [Pre-requisites](#Pre-requisites)
2. [Starting Docker-compose](#Starting Docker-compose)
3. [Configure Greenplum](#Configure-Greenplum)
4. [Configure Cloudera](#Configure-Cloudera)

## Pre-requisites:
- [docker-compose](http://docs.docker.com/compose)
- [Streamsets docker image](https://hub.docker.com/u/streamsets/)
- [GPDB 5.x OSS docker image](https://hub.docker.com/r/kochanpivotal/gpdb5oss/)

## Starting Docker-compose
Once you have cloned this repository, you can run the command  `./runDocker.sh -t usecase1 -c up`, in order to start both Greenplum and Streamsets docker instances.

The assumption: docker and docker-compose are already installed on your machine.

### Run command to start both Greenplum and Streamsets instances
```
Kongs-MacBook-Pro:greenplum-streamsets kochan$ ./runDocker.sh -t usecase1 -c up
Creating network "usecase1_mynetwork" with driver "bridge"
Creating gpdbsne ... done
Creating usecase1_sdc_1 ... done
Attaching to gpdbsne, usecase1_sdc_1
gpdbsne  | /bin/run-parts
gpdbsne  | Running /docker-entrypoint.d
gpdbsne  | Running bin/bash
...
 Reflections - Reflections took 54 ms to scan 2 urls, producing 1234 keys and 2030 values
sdc_1    | Running on URI : 'http://streamsets-dc:18630'
sdc_1    | 2018-04-19 21:03:32,549 [user:] [pipeline:] [runner:] [thread:main] INFO  WebServerTask - Running on URI : 'http://streamsets-dc:18630'
```
### How to access Greenplum docker instance:
You can use this command `docker exec -it gpdbsne bin/bash` to access Greenplum docker instance.

For example:
```
Kongs-MacBook-Pro:greenplum-streamsets kochan$ docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                                                                                                                                NAMES
ea149332c133        streamsets/datacollector        "/docker-entrypoint.…"   6 minutes ago       Up 7 minutes        0.0.0.0:18630->18630/tcp                                                                                                             usecase1_sdc_1
78b7793b1b37        kochanpivotal/gpdb5oss:latest   "/docker-entrypoint.…"   6 minutes ago       Up 7 minutes        0.0.0.0:5005->5005/tcp, 0.0.0.0:5010->5010/tcp, 0.0.0.0:5432->5432/tcp, 0.0.0.0:40000-40002->40000-40002/tcp, 0.0.0.0:9022->22/tcp   gpdbsne
Kongs-MacBook-Pro:greenplum-streamsets kochan$ docker exec -it gpdbsne bin/bash
root@gpdbsne:/#

```

### How to access Streamsets docker instances:
You can use this command `docker exec -it usecase1_sdc_1 bin/bash` to access Streamsets docker instance.

For example:
```
Kongs-MacBook-Pro:gpdb kochan$ docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                                                                                                                                NAMES
ea149332c133        streamsets/datacollector        "/docker-entrypoint.…"   4 minutes ago       Up 5 minutes        0.0.0.0:18630->18630/tcp                                                                                                             usecase1_sdc_1
78b7793b1b37        kochanpivotal/gpdb5oss:latest   "/docker-entrypoint.…"   4 minutes ago       Up 5 minutes        0.0.0.0:5005->5005/tcp, 0.0.0.0:5010->5010/tcp, 0.0.0.0:5432->5432/tcp, 0.0.0.0:40000-40002->40000-40002/tcp, 0.0.0.0:9022->22/tcp   gpdbsne
Kongs-MacBook-Pro:gpdb kochan$ docker exec -it usecase1_sdc_1 bin/bash
```


## Configure Greenplum
Once you have access to Greenplum docker instance, you can create database, table with some sample data.

1. Start GPDB instance:
Use the command 'startGPDB.sh'
```
root@gpdbsne# startGPDB.sh
SSHD isn't running
 * Starting OpenBSD Secure Shell server sshd                             [ OK ]
SSHD is running...
20180419:21:15:09:000094 gpstart:gpdbsne:gpadmin-[INFO]:-Starting gpstart with args: -a
20180419:21:15:09:000094 gpstart:gpdbsne:gpadmin-[INFO]:-Gathering information and validating the environment...
...
20180419:21:15:18:000247 gpstart:gpdbsne:gpadmin-[INFO]:-Have lock file /tmp/.s.PGSQL.5432 and a process running on port 5432
20180419:21:15:18:000247 gpstart:gpdbsne:gpadmin-[ERROR]:-gpstart error: Master instance process running
```
2. Create database and table with sample database
The scripts to create database and sample data is found at `/code/usercase1/data`.

Next, run the command '/code/usecase1/data/setupDB.sh'
```
root@gpdbsne:/# cd /code/usecase1/data
root@gpdbsne:/code/usecase1/data# ./setupDB.sh
psql:./gpdb_sample.sql:2: NOTICE:  table "usertable" does not exist, skipping
DROP TABLE
CREATE TABLE
root@gpdbsne:/code/usecase1/data#
```
3. Verify database and table is created.
Use the command `su - gpadmin`, followed by `psql -U gpadmin -d streamsets_db -c "select count(*) from usertable;"`.  The result shows no records are yet created.

Example:
```
root@gpdbsne:/code/usecase1/data#su - gpadmin
$
$ psql -U gpadmin -d streamsets_db -c "select count(*) from usertable;"
 count
-------
     0
(1 row)
```

## Configure Cloudera
