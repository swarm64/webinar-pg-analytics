
# Divide and conquer

* Consider replicating your OLTP Postgres to a 2nd instance for OLAP
  > Allows to have per-workload DB configs (& machine types)

* Utilize logical replication to pre-select what you need
  > And also to add some early transformations pre-shaping the data

