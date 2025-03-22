# snowflake perf

- try to reduce the number of rows
- look for opportunities to reduce partitions scanned by filtering on clustering key (ie: minimise partitions scanned / partitions total )
- remote spilling means the warehouse can't fit the data into local disk, so reduce data or increase warehouse size
- look at most expensive nodes in the query profile, if `join` then the bottom neck is data size/spilling, if `table scan` then possibly need to reduce number of partitions scanned /total

## partitions overlaps

the fewer overlaps the more discriminating a key, see [Clustering Depth Illustrated](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions#clustering-depth-illustrated)

use [SYSTEM$CLUSTERING_INFORMATION](https://docs.snowflake.com/en/sql-reference/functions/system_clustering_information) to get the average overlaps.

## clustering keys

[Clustering Keys & Clustered Tables](https://docs.snowflake.com/en/user-guide/tables-clustering-keys)
