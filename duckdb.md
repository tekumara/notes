# duckdb

Join csvs with no header:

```
select c2.column0 from 'catalog.csv' c1 right join 'catalog2.csv' c2 on c1.column0 = c2.column0 where c1.column0 is null;
```

Plain list as output:

```
.mode list
```
