# snowflake connector for python

```
pip install snowflake-connector-python
```

## Building from source

In a venv:

```
pip install build
python -m build --wheel .
pip install -e ".[secure-local-storage]"
```

## Usage

```python
import os

import snowflake.connector

with snowflake.connector.connect(
    user="PROD_JAFFLES_SA",
    role="PROD_JAFFLES_ADMIN",
    account='RH90206',
    region="ap-southeast-2",
    database="PROD_JAFFLES",
    warehouse="PROD_JAFFLES_WH",
    password=os.getenv("SNOWFLAKE_PASSWORD"),
) as conn:
    with conn.cursor() as cur:
        print(cur.execute("select 'hello world';").fetchone())
```

To use browser-based SSO replace `password` with `authenticator="externalbrowser"`.

## Browser-based SSO ID token caching

To [enable ID tokens](https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-use.html#using-connection-caching-to-minimize-the-number-of-prompts-for-authentication-optional) to minimise authentication prompts:

```
alter account set allow_id_token = true;
```

ID tokens are cached and valid for 4 hours.

On Mac ID tokens are cached in the `login` keychain. To cache tokens on macOS install:

```
pip install "snowflake-connector-python[secure-local-storage]"
```

On Linux ID tokens are stored in _~/.cache/snowflake/temporary_credential.json_ or the directory specified by the env var `SF_TEMPORARY_CREDENTIAL_CACHE_DIR`. To cache tokens connect with:

```python
conn = snowflake.connector.connect(
    ...
    client_store_temporary_credential=True
)
```

If you are using dbt it will import `snowflake-connector-python[secure-local-storage]` and set [client_store_temporary_credential=True](https://github.com/dbt-labs/dbt-snowflake/blob/d9f8655/dbt/adapters/snowflake/connections.py#L150) for you.

## Result batch

The results of SQL queries are stored in S3 across multiple objects. Each object is a [result batch/chunk](https://github.com/snowflakedb/snowflake-connector-python/blob/4384345c3aa72ca2070a88e10cbb16af75af4c5e/src/snowflake/connector/result_batch.py#L208). The S3 object URLs [expire after 6 hours](https://github.com/snowflakedb/snowflake-connector-python/blob/4384345c3aa72ca2070a88e10cbb16af75af4c5e/src/snowflake/connector/result_batch.py#L221). Result batches are either JSON or arrow binary data (see [ArrowResultBatch](https://github.com/snowflakedb/snowflake-connector-python/blob/4384345c3aa72ca2070a88e10cbb16af75af4c5e/src/snowflake/connector/result_batch.py#L541)).

## Client session keep alive

`client_session_keep_alive = True` is for an individual session/connection... normally [the session master token](https://community.snowflake.com/s/article/Authentication-token-has-expired-The-user-must-authenticate-again) expires with a "Authentication token has expired" error if the client's session has been idle for 4 hours. This keeps it alive with a heartbeat from the client.

## Troubleshooting

> snowflake.connector.network.ReauthenticationRequest: 390195 (08001): The provided ID Token is invalid.

May occur when using a stale token. Try again. See [#1415](https://github.com/snowflakedb/snowflake-connector-python/issues/1415#issuecomment-1414927724)

> snowflake.connector.errors.InterfaceError: 252005: Failed to convert current row, cause: [Snowflake Exception] unknown arrow internal data type(1113013152) for TIMESTAMP_NTZ data

May occur when using incompatible versions of pyarrow and snowflake-connector-python. Reinstall both, eg: `pip install --force-reinstall 'snowflake-connector-python[pandas]'`

> Failed to convert current row, cause: year 53682749 is out of range

When a naive seven-part datetime (eg: `datetime.utcnow()`) is written using `write_as_dataframe` it will end up out of range, eg: `53682274-05-20T12:04:46Z`. Add a timezone, eg: `datetime.utcnow().replace(tzinfo=timezone.utc)`
