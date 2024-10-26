# clickhouse

## vs duckdb

> Both DuckDB and Clickhouse were performant enough on local data. Well over 500k writes per second. They both support primary and secondary indexing (DuckDB: Adaptive Radix Tree, Clickhouse: Bloom Filters). However at half a billion rows, duckdb ART index, runs out of memory in 8GB (the entire index must be able to be loaded in memory). Clickhouse, uses sparse indexes, and therefore there is very little memory pressure even at 1 billion rows +.
