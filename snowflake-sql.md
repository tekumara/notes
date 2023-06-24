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

### Schema 'SANDBOX."dev_tekumara"' does not exist or not authorized

When schemas are quoted they are case sensitive. So the schema "dev_tekumara" must exist with the lowercase name.
