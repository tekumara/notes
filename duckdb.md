# duckdb

- macos : `brew install duckdb'
- ubuntu:

  ```
  wget "https://github.com/duckdb/duckdb/releases/download/v0.8.1/duckdb_cli-linux-amd64.zip" -P /tmp
  unzip /tmp/duckdb_cli-linux-amd64.zip -d /tmp
  sudo install /tmp/duckdb /usr/local/bin/duckdb
  ```

Join csvs with no header:

```
select c2.column0 from 'catalog.csv' c1 right join 'catalog2.csv' c2 on c1.column0 = c2.column0 where c1.column0 is null;
```

Plain list as output:

```
.mode list
```

Show table schema:

```
.schema table_name
# or
describe table_name;
# or

```

List tables:

```
.tables
# or
select * from information_schema.tables;
```

List schemas:

```
select * from duckdb_schemas()
# or
select * from information_schema.schemata;
```

duckdb settings

```
select * from duckdb_settings();
```

Increase max rows for duckbox mode (the default) from 40 (the default):

```
.maxrows 1000
```

Set default schema to `foobar`:

```
SET SCHEMA = 'foobar';
```

Check current schema:

```
SELECT CURRENT_SETTING('schema');
```

Read parquet from s3:

```
from read_parquet('s3://commoncrawl/cc-index/table/cc-main/warc/crawl=CC-MAIN-2023-23/subset=robotstxt/part-00031-ffa3bf93-6ba1-4a27-adea-b0baae3b4389.c000.gz.parquet');
```

Debug s3 settings:

```
select * from duckdb_settings() where name like 's3%'
```

httpfs will [load the AWS env vars if present](https://github.com/duckdb/duckdb/pull/5419).

## Troubleshooting

> BinderException: Binder Error: There are no UNIQUE/PRIMARY KEY Indexes that refer to this table, ON CONFLICT is a no-op

INSERT OR REPLACE on table with no primary key ([src](https://github.com/duckdb/duckdb/blob/11ebe39/src/planner/binder/statement/bind_insert.cpp#L271)). Add a primary key to the table.

> BinderException: Binder Error: Conflict target has to be provided for a DO UPDATE operation when the table has multiple UNIQUE/PRIMARY KEY constraints

INSERT OR REPLACE on table with more than one primary key ([src](https://github.com/duckdb/duckdb/blob/11ebe39/src/planner/binder/statement/bind_insert.cpp#L276)). Specify which ones to use, eg: `ON CONFLICT DO UPDATE SET (c1 = excluded.c1, c2 = excluded.c2, ..)`.

> duckdb.InvalidInputException: Invalid Input Error: arrow_scan: get_next failed(): Invalid: Float value 588.8 was truncated converting to int64

The schema is BIGINT but contains Float values.

> Crash on GROUP BY

GROUP BY does a HASH_GROUP_BY which doesn't support out-of-core computation ie: offloading to disk.

"But again the hash aggregate does not have such an algorithm yet. That supports cleverly unloading blocks to disk
Table functions, ORDER BY, window functions and joins have such implementations now." From [discord](https://discord.com/channels/909674491309850675/1041092095454224494/1041099620345983007) see also [out-of-core right/outer/mark/anti hash joins](https://github.com/duckdb/duckdb/pull/4970) and [`HASH_GROUP_BY` vs `HASH_JOIN`](https://github.com/duckdb/duckdb/issues/4292#issuecomment-1239355854)

> Error: Out of Memory Error: could not allocate block of size 22.5MB (13.2GB/13.2GB used)
> Database is launched in in-memory mode and no temporary directory is specified.
> Unused blocks cannot be offloaded to disk.
>
> Launch the database with a persistent storage back-end
> Or set PRAGMA temp_directory='/path/to/tmp.tmp'

To open or create a persistent database:

- include a path as a command line argument, eg: `duckdb FILENAME`. DuckDB will create it if it doesn't already exist.
- use `.open FILENAME`. If FILENAME doesn't not exist is will be created.

DuckDB will then spill to _FILENAME.tmp/_

Alternatively use `PRAGMA temp_directory='/path/to/tmp.tmp'`

> Error: IO Error: Could not write all bytes to file

No more space on disk when spilling.

> Error: IO Error: No files found that match the pattern

```
from read_parquet('s3://bucket/predictions/predict[0].parquet');
```

Escape the square brackets, they're treated as part of a regex pattern.

> HTTP GET error on 'https://foo.s3.amazonaws.com/?encoding-type=url&list-type=2&prefix=bar%2F' (HTTP 403)

AWS credentials haven't been loaded. Set the AWS\_\* env vars or load the aws extension.
