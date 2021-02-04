
# Schema

```txt
+--------------------------------------------------------------+
|                                                              |
| brokerage.application ←- brokerage.application_request_data  |
|   |                                                          |
|   +-→ brokerage.loan_application                             |
|   |                                                          |
|   +-→ brokerage.requester                                    |
|   |                                                          |
|   +-→ economical_data                                        |
|         |                                                    |
|         +-→ economical_data_debt_consolidation               |
|               |                                              |
|               +-→ debt_consolidation                         |
|                                                              |
+--------------------------------------------------------------+
```

* Current constraints:
  > Every table has a PK
  > There are some UKs
  > ed / eddc / dc has FKs

* Indexes:
  > Swarm64 DA column-store index on `brokerage.application_request_data`
  > B-tree on `brokerage.application_request_data(state)`

* Key sizes for `brokerage.application_request_data`:
  > Table: 112GB
  > PK index: 10GB
  > Index on state: 15GB
  > Column-store index: 52GB (2.2x compression)

