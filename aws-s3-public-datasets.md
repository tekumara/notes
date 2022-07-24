# aws s3 public datasets

Useful for testing:

A pipe separated csv (2k):

```
aws s3 --no-sign-request cp s3://tpc-h-csv/nation/nation.tbl -
```

[GBIF](https://gbif-open-data-ap-southeast-2.s3.ap-southeast-2.amazonaws.com/index.html) data in Parquet ()

```
aws s3 --no-sign-request ls --human-readable --summarize s3://gbif-open-data-ap-southeast-2/occurrence/2022-07-01/occurrence.parquet/
2022-07-02 03:04:17  166.1 MiB 000000
2022-07-02 03:04:17  202.3 MiB 000001
..
```

## References

- [awslabs/open-data-registry](https://github.com/awslabs/open-data-registry)
