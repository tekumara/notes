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

Duckdb settings

```
select * from duckdb_settings();
```

Set default schema to `foobar`:

```
SET SCHEMA = 'foobar';
```

Check current schema:

```
SELECT CURRENT_SETTING('schema');
```
