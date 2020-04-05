
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

The number of partitions created when shuffling a Dataframe (only SQL queries or all??) can be controlled by the `spark.sql.shuffle.partitions` configuration parameter and defaults to 200 (regardless of number of executors cores). Example of setting this to 500: `spark.sql("set spark.sql.shuffle.partitions=500")`

The number of partitions when doing a join, reduceByKey or parallelize on a RDD can be set by the `spark.default.parallelism` config parameter and defaults to the total number of cores in the cluster. When run locally (`spark.master = "local[*]"`), this will be the result of `Runtime.getRuntime.availableProcessors()` ie: the number of logical cores, which includes hyper-threads. 

## Repartitioning

Dataframes can be repartitioned using `repartitionByRange` see this [stack overflow example](
http://stackoverflow.com/questions/30995699/how-to-define-partitioning-of-a-spark-dataframe)

## Dataframe Partitioners 

Types of partitioners for Dataframes:
* RoundRobinPartitioning - any record
* hashpartitioning - partition based on 1 or more columns

When hashpartitioning, you can't get more partitions that unique values for your key. If the partition size is greater than cardinality, you'll end up with some empty partitions. So you want cardinality >= partitions >= cores, and small enough to fit into memory and block sizes < 2G (because of the spark 2G limit).

Also note that when the number of partitions is close to the number of records (ie: N <= β * numPartitions where β ~ 2) you can get empty partitions and uneven buckets from these partitioners. Even when N is large relative to numPartitions, there will still be some (~0.2%) variability in the partition sizes. To get more control you will need to use RDDs with a customer partitioner.

`coalesce` - group together one or more partitions from the parent
`DataframeWriter.partitionBy/bucketBy` - split out a parent parent into individual files

See also
* [How does HashPartitioner work?](https://stackoverflow.com/questions/31424396/how-does-hashpartitioner-work)

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

