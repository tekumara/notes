# jupysql

## duckdb

Install:

```
pip install jupysql duckdb-engine
```

Connect:

```python
%load_ext sql
%config SqlMagic.feedback = False
%config SqlMagic.displaycon = False
%config SqlMagic.autopandas = True
%sql duckdb:///:memory:
```

## Snowflake

Install:

```
pip install jupysql snowflake-sqlalchemy
```

```python
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine

conn_info = dict(
    user=...,
    account=...,
    warehouse=...,
    database=...,
    schema=...    
)

engine = create_engine(URL(**conn_info))

%reload_ext sql
%config SqlMagic.feedback = False
%config SqlMagic.displaycon = False
%config SqlMagic.autopandas = True
%sql engine
```
