# snowflake flatten

[FLATTEN](https://docs.snowflake.com/en/sql-reference/functions/flatten) is a table function. [Table functions](https://docs.snowflake.com/en/sql-reference/functions-table) appear in the FROM clause. Table functions must be wrapped in `table(..)` or preceded by the LATERAL keyword. The effect of either is the same - to tells Snowflake a table function is next.

Table functions work like a correlated subquery, ie:

- the outer query executes first for a single row
- for each row processed by the outer query, the table function executes and can use values from the current outer row
