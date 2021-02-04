
# Query patterns II

* Consider rewriting `SELECT COUNT(DISTINCT id) FROM foo`

  > Option A: `SELECT COUNT(*) FROM (SELECT DISTINCT id FROM foo) x;`
  > Option B: `SELECT COUNT(*) FROM (SELECT id FROM foo GROUP BY id) x;`


* A & B are more likely to favor a parallel plan

* Another option is to have an explicit index on the column
  > Doesn't necessarily help with parallelism, though


```sql
EXPLAIN
SELECT COUNT(DISTINCT id) FROM foo;

EXPLAIN
SELECT COUNT(*) FROM (SELECT DISTINCT id FROM foo) x;

EXPLAIN
SELECT COUNT(*) FROM (SELECT id FROM foo GROUP BY id) x;
```
