# pyarrow

> When reading from S3, file open/close are very expensive operations, so set a high value for the default_block_size in s3fs.S3FileSystem. This is especially important when reading from large files; experiment and derive the number of bytes to forward seek empirically. When reading all the columns in a Parquet file, do not list the column names in pyarrow.parquet.ParquetFile.read. Pyarrow provides multi-threading for free; utilize it by setting use_threads=True in pyarrow.parquet.ParquetFile.read

## Troubleshooting

```
.venv/lib/python3.11/site-packages/pandas/core/frame.py:2889: in to_parquet
    return to_parquet(
.venv/lib/python3.11/site-packages/pandas/io/parquet.py:411: in to_parquet
    impl.write(
.venv/lib/python3.11/site-packages/pandas/io/parquet.py:159: in write
    table = self.api.Table.from_pandas(df, **from_pandas_kwargs)
pyarrow/table.pxi:3475: in pyarrow.lib.Table.from_pandas
    ???
.venv/lib/python3.11/site-packages/pyarrow/pandas_compat.py:611: in dataframe_to_arrays
    arrays = [convert_column(c, f)
.venv/lib/python3.11/site-packages/pyarrow/pandas_compat.py:611: in <listcomp>
    arrays = [convert_column(c, f)
.venv/lib/python3.11/site-packages/pyarrow/pandas_compat.py:598: in convert_column
    raise e
.venv/lib/python3.11/site-packages/pyarrow/pandas_compat.py:592: in convert_column
    result = pa.array(col, type=type_, from_pandas=True, safe=safe)
pyarrow/array.pxi:314: in pyarrow.lib.array
    ???
.venv/lib/python3.11/site-packages/pyarrow/pandas_compat.py:668: in get_datetimetz_type
    type_ = pa.timestamp(unit, tz)
pyarrow/types.pxi:2524: in pyarrow.lib.timestamp
    ???
pyarrow/types.pxi:2457: in pyarrow.lib.tzinfo_to_string
    ???
pyarrow/error.pxi:144: in pyarrow.lib.pyarrow_internal_check_status
    ???
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

>   ???
E   pyarrow.lib.ArrowInvalid: ('Object returned by tzinfo.utcoffset(None) is not an instance of datetime.timedelta', "Conversion failed for column FLOWRUN_START_TIME with type datetime64[ns, Timezone('Australia/Melbourne')]")

pyarrow/error.pxi:100: ArrowInvalid
```

Occurs when trying to create a table using a pendulum.DateTime in the local timezone.
