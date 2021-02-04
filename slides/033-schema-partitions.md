
# Partitions

* ...are a good thing, they help Postgres to manage data better


* Design your partition schema to efficiently use partition pruning
  > Use increasing IDs, timestamps, categories, ...
  > Use range or list partitioning


* Avoid hash partitioning
  > Contradicts pruning if the hashing works in a uniform manner
  > For OLAP you want to reduce data somehow


* Consider disabling JIT
  > `jit = on` likely leads to very large overhead with many partitions

