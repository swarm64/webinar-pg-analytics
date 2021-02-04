
# PostgreSQL & its natural habitat


* Postgres does OLTP very well
* Postgres can do OLAP out of the box very well, if

  > PG is properly configured (mostly costs, parallelism)
  > There's room to cache data (or partitions)
  > The schema provides guidance (esp. for JOINs and related ops)


* Extensions help Postgres to do OLAP even better

