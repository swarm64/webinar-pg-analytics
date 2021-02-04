
# Practices on schemas
  (the bad)


* "Index hell"
  > Less is more
  > Sometimes, a full table scan isn't that bad
  > There is not only b-tree indexes
  > Understand how indexes are picked
  |
  | You define: `CREATE INDEX ON table(a, b, c)`
  | 9 out of 10 queries need: b and c


* Excess use of unconstrained non-integer based JOIN keys
  > PG can be not so forgiving sometimes
  > Example: JOIN on multiple text columns, likely results in off-estimates
  > Off-estimates can cause an avalanche effect:
  |
  | **PG planner**: Only 100 rows? I'm going to use a nested loop from here on.
  | **PG user   **: Uuhh, well but there will be 1M rows above?
  | **System    **: Uses 1 out of 24 cores for the next hour or so.

