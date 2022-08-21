# sqlite

`sqlite3 myapp.db` open myapp.db, creating it if it doesnt' exist
`echo ".schema" | sqlite3 myapp.db` dump entire schema from command line

Import csv:

```
.mode csv
.import city.csv cities
.schema cities
```

Concat strings:

```
select users.screen_name,full_text,tweets.created_at,'https://twitter.com/'||users.screen_name||'/status/'||tweets.id as link from tweets join users on tweets.user = users.id where full_text like '%gitops%';
```

## commands

`.tables` list tables  
`.schema mytable` show CREATE statement for mytable
`.headers ON` to show column names in select results

See [Command Line Shell For SQLite](https://www.sqlite.org/cli.html)
