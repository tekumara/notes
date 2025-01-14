# rising wave

A streaming database.

> Users can define streaming tasks in the form of materialized views using SQL, with the goal of making stream processing as simple and accessible as possible. RisingWave does not provide a programming API, but custom code can be introduced via User-Defined Functions (UDFs) if necessary.
>
> In addition to stream processing, RisingWave provides query capabilities similar to a database and guarantees the correctness of snapshot reads. In particular, as long as the query of materialized views is performed within a single transaction, the result will always be consistent with the result of executing the defining SQL.

## Features

- SQL interface
- PostgreSQL wire-protocol - just use a pg client
- Materialized views, with snapshot-based consistency, used to represent pipelines
- Database/serving/storage layer - stores tables and materialized views in row based format. Enables composition, ie: views can reference other views and tables.
- Adhoc queries on tables / materialized views
- Indexes on tables
- Cloud storage of state - so recovery and scaling is much faster than when coupled to compute. Infinite spill.
- Lots of integrations incl. Snowflake, ElasticSearch, DynamoDb (Enterprise)
