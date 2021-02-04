
# Step 1: get your config right

Proudly presenting: **the top 3 pitfalls**

* Too shy for parallelism?
  > `max_worker_processes` (high) vs.
  > `max_parallel_workers` (high) vs.
  > `max_parallel_workers_per_gather` (as needed)
  > `min_parallel_table_scan_size` (start with 0, really)


* Costing system + stats
  > `default_statistics_target = 100` too low, consider 2500
  > Double check `seq_page_cost` & `random_page_cost`
  > Consider increasing `random_page_cost` to avoid nested loops


* `work_mem` is off
  > Goal: as many operations in memory as possible
  > Conservative approach: start with 1GB to 4GB, measure, increase
  > Adjust wrt parallel workers

