# Readme
This document describes how to setup PXF with JDBC examples.


## Error "ERROR:  remote component error (0) from ':5888': Failed to connect to localhost port 5888: Connection refused (libchurl.c:944)  (seg0 slice1 172.18.0.2:40000 pid=505) (cdbdisp.c:254)"
This error is displayed whenever PXF service is not running.
```
gpadmin=# select * from pxf_jdbc_postgres_testpxf;
ERROR:  remote component error (0) from ':5888': Failed to connect to localhost port 5888: Connection refused (libchurl.c:944)  (seg0 slice1 172.18.0.2:40000 pid=505) (cdbdisp.c:254)
DETAIL:  External table pxf_jdbc_postgres_testpxf
```


## Error "ERROR:  remote component error (500) from '127.0.0.1:5888':  type  Exception report   message   org.postgresql.Driver    description   The server encountered an internal error that prevented it from fulfilling this request.    exception   java.io.IOException: org.postgresql.Driver (libchurl.c:944)  (seg1 slice1 172.18.0.2:40001 pid=718) (cdbdisp.c:254)"
This error is displayed whenever JDBC driver is not loaded by PXF service.

```
gpadmin=# select * from pxf_jdbc_postgres_testpxf;
ERROR:  remote component error (500) from '127.0.0.1:5888':  type  Exception report   message   org.postgresql.Driver    description   The server encountered an internal error that prevented it from fulfilling this request.    exception   java.io.IOException: org.postgresql.Driver (libchurl.c:944)  (seg1 slice1 172.18.0.2:40001 pid=718) (cdbdisp.c:254)
DETAIL:  External table pxf_jdbc_postgres_testpxf
```
