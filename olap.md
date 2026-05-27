# olap real-time

- Clickhouse
- Apache Pinot (StarTree)
- Apache Doris (VeloDB/StarRocks)
- Dremio

Each of these systems offers different approaches to serving Parquet/Iceberg data, optimized for varying levels of concurrency and query complexity. eg: Pinot sounds designed for high concurrency with low query complexity scenarios.

However, Iceberg doesn't support efficient streaming ingestion of small data increments. To achieve real-time analytics latencies, you would need SSD caching or storage tiering.
