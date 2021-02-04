
# Query Patterns I

* Equivalency of `NOT EXISTS` and `LEFT JOIN`  with `IS NULL`
  (does also work with `EXISTS`)
  > Pick one or the other depending on needs
  > `LEFT JOIN` typically does the better job with larger chains


* Example:

```sql
EXPLAIN
SELECT id
FROM foo
WHERE NOT EXISTS(
  SELECT id
  FROM dont_touch_these dtt
  WHERE dtt.id = foo.id
);
```

```sql
EXPLAIN
SELECT id
FROM foo
LEFT JOIN dont_touch_these dtt USING(id)
WHERE dtt.id IS NULL;
```

