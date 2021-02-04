
# On what I call the configuration-controversy⁽¹⁾

* Controversial claim: it is OK to overutilize your resources


## CPU

* It is ok to overutilize parallel workers
  > The OS knows the concept of time-slicing

* **But**: watch out for memory consumption (see below)


## Memory

* Theoretical overutilization is fine

* Practical overutilization is bad, however
  > You want to avoid swap usage
  > In most cases, there should be space left for the page cache


* Example config for TPC-H @ Swarm64:

```bash
work_mem = '4GB'
max_worker_processes = 1000
max_parallel_workers = 1000
max_parallel_workers_per_gather = 54
```

* Do the math:
  > 4GB * 54 workers * 2 gather nodes max = 432GB peak RAM utilization
  |
  | Our testing system has ... drumroll ... 384GB of RAM
  | Does it crash? No.
  | Why? Because the practical limit during a benchmark is below that
  | Why do we set this at all? To help the query planner do a better job


* Practical recommendation: 4GB to 6GB
  > Adjust wrt available RAM, worker counts & expected concurrency
  > Experience: 12GB+ does not change things usually
  > Stay away from enormous values like 24GB



(1): Yes, I just invented that term when writing the slide
