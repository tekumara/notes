# snowflake sql

Create a temp talbe from results of last query (useful after a `desc` query)

```
CREATE OR REPLACE TEMPORARY TABLE my_temp_table AS
    SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
```

## Troubleshooting

### Schema 'SANDBOX."dev_tekumara"' does not exist or not authorized

When schemas are quoted they are case sensitive. So the schema "dev_tekumara" must exist with the lowercase name.
