# arrow

Arrow is optimised for use in-memory and is only lightly compressed. Parquet uses columnar compression. See [What is the difference between Apache Arrow and Apache Parquet?](https://arrow.apache.org/faq/#what-is-the-difference-between-apache-arrow-and-apache-parquet). The [IPC format](#ipc) can be compressed.

## Arrays

> An array represents a known-length sequence of values all having the same type.
>
> A arrow::ChunkedArray is, like an array, a logical sequence of values; but unlike a simple array, a chunked array does not require the entire sequence to be physically contiguous in memory. Also, the constituents of a chunked array need not have the same size, but they must all have the same data type.

See [Arrays](https://arrow.apache.org/docs/cpp/arrays.html).

## Arrow table vs Record Batch

> Record batches can be sent between implementations, such as via IPC or via the C Data Interface. Tables and chunked arrays, on the other hand, are concepts in the C++ implementation, not in the Arrow format itself, so they aren’t directly portable.
>
> However, a table can be converted to and built from a sequence of record batches easily without needing to copy the underlying array buffers.

See [Record batches](https://arrow.apache.org/docs/cpp/tables.html#record-batches).

## IPC

The [IPC stream format](https://arrow.apache.org/docs/format/Columnar.html#ipc-streaming-format) contains a schema, and a series of `DictionaryBatch` and `RecordBatch`.

The [IPC format](https://arrow.apache.org/docs/format/Columnar.html#ipc-file-format) is an extension of the streaming format that allows for random access.

![formats diagram](https://wesmckinney.com/images/arrow_file_formats.png)

See [Streaming Columnar Data with Apache Arrow](https://wesmckinney.com/blog/arrow-streaming-columnar/).

[Feather v2](https://arrow.apache.org/docs/python/feather.html) is the IPC format. Supports LZ4 and ZSTD compression.

[Mime types and file extensions](https://arrow.apache.org/faq/#mime-types-iana-media-types-for-arrow-data) are:

- `.arrow` is recommend for the IPC file format
- `.arrows` for the streaming format.

## JSON

pyarrow can [read line-delimited json](https://arrow.apache.org/docs/python/json.html) either compressed or uncompressed, with multi-threading and type inference.

## S3

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
