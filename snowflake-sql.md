# snowflake sql

Create a temp table from results of last query (useful after a `desc` query)

```
CREATE OR REPLACE TEMPORARY TABLE my_temp_table AS
    SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
```

Query history by user:

```

select * from table(information_schema.QUERY_HISTORY_BY_USER(
      USER_NAME => 'CUPS_SANDBOX_SA'
      , END_TIME_RANGE_START=>to_timestamp_ltz('2023-05-10 13:00:00 +0000')
      , END_TIME_RANGE_END=>to_timestamp_ltz('2023-05-10 14:00:00 +0000')
      , RESULT_LIMIT => 1000 ));
```

NB:

- Result limit defaults to 100 if not specified.
- No warehouse size means no warehouse was used, eg: when fetching from result cache or working with metadata.

## Troubleshooting

> Schema 'SANDBOX."dev_tekumara"' does not exist or not authorized

When schemas are quoted they are case sensitive. So the schema "dev_tekumara" must exist with the lowercase name.

> snowflake.connector.errors.ProgrammingError: 000625 (57014): Statement '01bb1644-0513-b332-2247-8306a8ddf13b' has locked table 'MY_TABLE1' in transaction 1742288905053000000 and this lock has not yet been released.
> Your statement '01bb1644-0513-b332-2247-8306a8ddf637' was aborted because the number of waiters for this lock exceeds the 50 statements limit.

Occurs where there's a lot of concurrent writes, and these writes are queuing up. Once they hit 50 they'll abort.

Ways to address this:

- reduce the number of concurrent writes, eg: by writing to a staging area and then doing a single INSERT/UPDATE DML to the table
- increase concurrent capacity, eg: by increasing the warehouse size, MAX_CONCURRENCY_LEVEL, or MAX_CLUSTER_COUNT

See

- [Resource locking](https://docs.snowflake.com/en/sql-reference/transactions#resource-locking)
- [How to handle the-number-of-waiters-exceeds-the-20-statements-limit error?](https://snowflake.discourse.group/t/how-to-handle-the-number-of-waiters-exceeds-the-20-statements-limit-error/7538)
- [Overcoming Concurrent Write Limits in Snowflake](https://resultant.com/blog/technology/overcoming-concurrent-write-limits-in-snowflake/)

> 503 service unavailable when fetching result batches

Too much concurrency to the warehouse, so it's being told to slow down.

Reduce concurrency or increase concurrent capacity (see above).
