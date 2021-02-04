
# Query patterns III

* `WINDOW` functions with `ORDER BY`

  > Consider moving `ORDER BY` out to use a parallel sort
  > Even if the window sorts again, it'll be faster


* Example:

```sql
EXPLAIN
SELECT row_number() OVER (
  PARTITION BY id
  ORDER BY id
)
FROM foo;
```

```sql
EXPLAIN
SELECT row_number() OVER (
  PARTITION BY id
  ORDER BY id
) FROM (
  SELECT id
  FROM foo
  ORDER BY id
) x;
```
