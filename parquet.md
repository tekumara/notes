# parquet

Row groups - basic unit of task composition ie: parallelism.
Recommended row group size 24MB - 128MB: decreasing the size will increase the parallelism.
Stats are stored in footer for row groups and columns in those row groups to allow skipping row groups.
Stored at page level for each page, to allow skipping pages.

Column chunks are compressed.
Nested values stored as if there is no nesting.

Easiest way to convert JSON to Parquet is to convert to Avro first which applies a schema.

## Dictionary compression

Dictionary applied to all column types (string, double, float etc.). When using a dictionary on a string field, the individual entries can be substrings of the field.

The dictionary is at the row group level at the start of each column chunk.

Decreasing the row group size will decrease the cardinality of possible values and so make it more likely that a dictionary will be used.

## Organisation

- Partition by low cardinality fields - because split planning because expensive with more files
- Sort by high cardinality predicate fields

## References

[Parquet performance tuning: the missing guide](https://www.slideshare.net/RyanBlue3/parquet-performance-tuning-the-missing-guide)
https://www.safaribooksonline.com/library/view/strata-hadoop/9781491944660/video282760.html

[Parquet performance tuning: The missing guide - Ryan Blue (Netflix) - Part 2 (30:04 mins)](https://www.safaribooksonline.com/library/view/strata-hadoop/9781491944660/video282760.html)
