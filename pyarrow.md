# pyarrow

> When reading from S3, file open/close are very expensive operations, so set a high value for the default_block_size in s3fs.S3FileSystem. This is especially important when reading from large files; experiment and derive the number of bytes to forward seek empirically. When reading all the columns in a Parquet file, do not list the column names in pyarrow.parquet.ParquetFile.read. Pyarrow provides multi-threading for free; utilize it by setting use_threads=True in pyarrow.parquet.ParquetFile.read
