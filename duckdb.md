# duckdb

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

## Troubleshooting

> BinderException: Binder Error: There are no UNIQUE/PRIMARY KEY Indexes that refer to this table, ON CONFLICT is a no-op

INSERT OR REPLACE on table with no primary key ([src](https://github.com/duckdb/duckdb/blob/11ebe39/src/planner/binder/statement/bind_insert.cpp#L271)). Add a primary key to the table.

> BinderException: Binder Error: Conflict target has to be provided for a DO UPDATE operation when the table has multiple UNIQUE/PRIMARY KEY constraints

INSERT OR REPLACE on table with more than one primary key ([src](https://github.com/duckdb/duckdb/blob/11ebe39/src/planner/binder/statement/bind_insert.cpp#L276)). Specify which ones to use, eg: `ON CONFLICT DO UPDATE SET (c1 = excluded.c1, c2 = excluded.c2, ..)`.
