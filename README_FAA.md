Work in progress:


val gscOptionMap = Map(
      "url" -> "jdbc:postgresql://greenplumsparkconnector_gpdb_1/tutorial",
      "user" -> "gpadmin",
      "password" -> "pivotal",
      "dbtable" -> "d_airports",
      "partitionColumn" -> "AirportID"
)

val gscOptionMap = Map(
      "url" -> "jdbc:postgresql://greenplumsparkconnector_gpdb_1/tutorial",
      "user" -> "gpadmin",
      "password" -> "pivotal",
      "dbtable" -> "otp_c",
      "partitionColumn" -> "airlineid"
)


scala> :paste
// Entering paste mode (ctrl-D to finish)
val gscOptionMap = Map(
      "url" -> "jdbc:postgresql://greenplumsparkconnector_gpdb_1/tutorial",
      "user" -> "gpadmin",
      "password" -> "pivotal",
      "dbtable" -> "d_airports",
      "partitionColumn" -> "airportid"
)
val gpdf = spark.read.format("io.pivotal.greenplum.spark.GreenplumRelationProvider")
        .options(gscOptionMap)
        .load()

control-D
// Exiting paste mode, now interpreting.

gpdf: org.apache.spark.sql.DataFrame = [flt_year: smallint, flt_quarter: smallint ... 44 more fields]
