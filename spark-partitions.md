
# Spark Partitions

1 partition = 1 task

These tasks will be spread over the cluster. Each executor will get up to `spark.executor.cores` tasks to process at a time.

## Input DataSources

Each input DataSource in Spark defines its own way of partitioning input data. Single parquet files can be split by row group into multiple partitions. To show how many partitions, and which parquet file (or part of a parquet file) is in each partition (can be multiple files per partition)
```
df.rdd.getNumPartitions
df.rdd.partitions.foreach(println)
```

The PartitionCount in the `FileScan parquet` step in the query plan will show how many parquet files are being read from disk/s3, which are distinct from Spark partitions:
```
df.explain
*FileScan parquet [steps#81,metadata#82,y#83,m#84,d#85] Batched: false, Format: Parquet, Location: InMemoryFileIndex[s3://example/foo-bar], PartitionCount: 5, PartitionFilters: [], PushedFilters: [], ReadSchema ....
```

## Shuffle defaults

The number of partitions created when shuffling a Dataframe can be controlled by the `spark.sql.shuffle.partitions` configuration parameter and defaults to 200 (regardless of number of executors cores). Here's how you could set this to 500: `spark.sql("set spark.sql.shuffle.partitions=500")`

The number of partitions when doing a join, reduceByKey or parallelize on a RDD can be set by the `spark.default.parallelism` config parameter and defaults to the total number of cores in the cluster. When run locally (`spark.master = "local[*]"`), this will be the result of `Runtime.getRuntime.availableProcessors()` ie: the number of logical cores, which includes hyper-threads. 

## Partitioning

A partitioner will redistribute (aka shuffle or exchange) a dataset across nodes.

Types of partitioners:
* [round robin partitioning](https://github.com/apache/spark/blob/b3bdfd7f102eb79d111e096baa923926f6ccf7a2/sql/catalyst/src/main/scala/org/apache/spark/sql/catalyst/plans/physical/partitioning.scala#L198) - distributes rows evenly across partitions, regardless of their values
* [hash partitioning](https://github.com/apache/spark/blob/b3bdfd7f102eb79d111e096baa923926f6ccf7a2/sql/catalyst/src/main/scala/org/apache/spark/sql/catalyst/plans/physical/partitioning.scala#L214) - splits a dataset into partitions based on the value of one or more columns (specifically, the Java `Object.hashCode` of the value). All rows that share the same column values are guaranteed to be in the same partition.
* [range partitioning](https://github.com/apache/spark/blob/b3bdfd7f102eb79d111e096baa923926f6ccf7a2/sql/catalyst/src/main/scala/org/apache/spark/sql/catalyst/plans/physical/partitioning.scala#L254) - rows are split based on their ordering into roughly equal ranges. All rows that share the same value for the ordering expression are guaranteed to be in the same partition.

Hash and range partitioning rely on values to do the partitioning, so if the number of partitions is greater than the cardinality of the values, you'll end up with some empty partitions, eg: if `isAlive` is a boolean value, then `repartition(isAlive, 1024)` will create 1024 tasks, of which only 2 receive data. Because they both provide guarantees that the same value ends up in the same partition, you can also end up with imbalanced partition sizes if the values are skewed. Generally you want cardinality >= partitions >= cores, and partitions small enough to fit into memory/disk and block sizes < 2G (because of the spark 2G limit). 

When using round robin partitioning, note that when the number of partitions is close to the number of records (ie: N <= β * numPartitions where β ~ 2) you can get empty partitions and uneven buckets. Even when N is large relative to numPartitions, there will still be some (~0.2%) variability in the partition sizes. To get more control you will need to use RDDs with a customer partitioner.

## Partitioning commands

* `repartitionByRange` uses a range partitioner
* `repartition(numPartitions: Int)` uses a round robin partitioner 
* [`repartition(partitionExprs: Column*)`](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.Dataset@repartition(partitionExprs:org.apache.spark.sql.Column*):org.apache.spark.sql.Dataset[T]) uses a hash partitioner
* `orderBy` will do a range partition first. In the physical plan you will see `Exchange rangepartitioning`, followed by a `Sort`.

In any of the above (including orderBy), when the number of partitions is not specified it defaults to `spark.sql.shuffle.partitions`.

* `coalesce` - group together one or more partitions from the parent  
* `DataframeWriter.partitionBy/bucketBy` - split out a parent parent into individual files


## Writing Dataframes

`partitionBy` determines the layout on the file system, but doesn't actually partition the dataset. Make sure the dataset is partitioned on the same field as `partitionBy`.

In the following example, if the dataset isn't partition by `batch` already, then spark will create approx `number of partitions * number of buckets` files, for each `batch`.

eg: if number of partitions is 640 (eg: `spark.sql.shuffle.partitions`) then this will create up to 640 * 8 = 5120 files inside each `batch=*` folder.

```
    df.write
      .partitionBy("batch")
      .bucketBy(8, "id")
      .sortBy("id")
      .mode("overwrite")
      .format("parquet")
      .option("path", "/tmp/my_table")
      .saveAsTable("my_table")
```


## RDD Partition Example

Adapted from [How does HashPartitioner work?](https://stackoverflow.com/questions/31424396/how-does-hashpartitioner-work)

```
# create a RDD of (key, value) pairs so we have the PairRDDFunctions like partitionBy
val rdd = sc.parallelize(for {
    x <- 1 to 5
    y <- 1 to 5
} yield (x, x), 8)


# a function to count the number of rows in each partitionBy
import org.apache.spark.rdd.RDD

def countByPartition(rdd: RDD[(Int, None.type)]) = {
    rdd.mapPartitions(iter => Iterator(iter.length))
}

# range partition into 1000 partitions

import org.apache.spark.RangePartitioner

val rddrp1000 = rdd.partitionBy(new RangePartitioner(1000, rdd))

rddrp1000.partitions.length
# res11: Int = 6

countByPartition(rddrp1000).collect()
# res13: Array[Int] = Array(5, 5, 5, 5, 5, 0)

# hash partition into 1000 partitions

import org.apache.spark.HashPartitioner

val rddhp1000 = rdd.partitionBy(new HashPartitioner(1000))

rddhp1000.partitions.length
# res14: Int = 1000

countByPartition(rddhp1000).collect()
# res15: Array[Int] = Array(0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
```

Note
* hash partitioner creates 1000 partitions, with only 5 containing data.
* ranger partitioner creates 6 partitions, with only 5 containing data


## References

* [SPARK-22614](https://issues.apache.org/jira/browse/SPARK-22614)

