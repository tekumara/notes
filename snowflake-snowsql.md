# snowsql

snowsql is a python CLI that uses the snowflake python connector

```
brew install snowflake-snowsql
ln -s /Applications/SnowSQL.app/Contents/MacOS/snowsql /usr/local/bin/snowsql
```

Connect

```
export SNOWSQL_PWD=....
snowsql -a $account.$region -u $user -o log_level=DEBUG
```

To quit: CTRL+D or !exit

## Config

See _~/.snowsql/config_ for config
By default logging is at the debug level to the file _../snowsql_rt.log_. You probably want to change this.
