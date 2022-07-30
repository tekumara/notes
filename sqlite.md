# sqlite

`sqlite3 myapp.db` open myapp.db, creating it if it doesnt' exist
`echo ".schema" | sqlite3 myapp.db` dump entire schema from command line

Import csv:

```
.mode csv
.import city.csv cities
.schema cities
```

## commands

`.tables` list tables  
`.schema mytable` show CREATE statement for mytable
`.headers ON` to show column names in select results

See [Command Line Shell For SQLite](https://www.sqlite.org/cli.html)
