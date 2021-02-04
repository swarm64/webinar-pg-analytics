
# Practices on schemas
  (the ugly)


* OLAP schemas typically do not include many constraints
  > There is trust, that the source' data is correct
  > Consider removing constraints which don't add value
  > Consider adding constraints which add value


* OLTP + OLAP = HTAP needs to use data constraints
  > Keep constraints to the bare minimum for both workloads
  > Be aware: every additional constraint slows down write ops

