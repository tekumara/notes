# aws athena

Show partitions:

```
SHOW PARTITIONS `inventory`.`my-bucket`
```

Query from the cli:

```
aws athena start-query-execution \
   --query-string "select count(*) from tablename;" \
   --query-execution-context Database=default \
   --result-configuration OutputLocation=s3://results/
```

To run multiple queries from a file - see https://stackoverflow.com/a/44301541/149412ß

## Troubleshooting

> ```
> select * from `inventory`.`bucket-name` limit 10
> ```
>
> Queries of this type are not supported.

Use double quotes instead, eg: `select \* from "inventory"."bucket-name" limit 10`

> ```
> SHOW CREATE TABLE "inventory"."bucket-name"
> ```
>
> Queries of this type are not supported.

Use single quotes instead, eg:

```
SHOW CREATE TABLE `inventory`.`bucket-name`
```

> ```
> select * from extract
> where batch >= '2019-12-01'
> ```
>
> Queries of this type are not supported.

`extract` is a keyword, enclose it in double quotes.

> ```
> SHOW CREATE TABLE `inventory`.`bucket-name`
> ```
>
> FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.DDLTask. java.lang.NullPointerException

Add the serde parameter `serialization.format=1` to your glue table.
