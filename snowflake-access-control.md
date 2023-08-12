# snowflake access control

## Hello World

```sql
use role securityadmin;
create role reader;

grant usage on warehouse compute_wh to role reader;
create user user1 password='abc123' default_role = reader default_secondary_roles = ('ALL') must_change_password = true;
// grant role reader to user user1;

use role sysadmin;

create database db1;
// database context is now db1
create schema s1;

create table table1 (message text);
insert into table1 (message) values ('Hello world!');

// makes db & schema visible to reader
grant usage on database db1 to role reader;
grant usage on schema s1 to role reader;

// makes table visible to reader
grant select on table s1.table1 to role reader;
```

## Future grants

[Security Privileges Required to Manage Future Grants](https://docs.snowflake.com/en/user-guide/security-access-control-configure.html#security-privileges-required-to-manage-future-grants):

> In standard schemas, the global MANAGE GRANTS privilege is required to grant or revoke privileges on future objects in the schema.
