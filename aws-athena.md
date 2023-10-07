# aws athena

Show partitions:

```
SHOW PARTITIONS `my-database`.`my-table`
```

Query from the cli:

```
aws athena start-query-execution \
   --query-string "select count(*) from tablename;" \
   --query-execution-context Database=default \
   --result-configuration OutputLocation=s3://results/
```

To run multiple queries from a file - see https://stackoverflow.com/a/44301541/149412ß

To add partitions:

```
MSCK REPAIR TABLE `my-database`.`my-table`
```

A successful query will output:

- `Partitions not in metastore`
- `Partitions missing from filesystem` - partitions in the metastore that no longer exist, see below.
- `Added partition to metastore` - partitions not in the metastore that were added successfully. If this isn't present new partitions weren't added, see "Partitions not being added to glue table" below.

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

> Partitions not being added to glue table

This can happen if:

- the role doesn't have `glue:BatchCreatePartition`
- the s3 path is in camel case

See [here](https://repost.aws/knowledge-center/athena-aws-glue-msck-repair-table).

> Partitions missing from filesystem

Use [ALTER TABLE .. DROP PARTITION ..](https://docs.aws.amazon.com/athena/latest/ug/msck-repair-table.html#:~:text=Partitions%20missing%20from%20file%20system) to remove the partition.

> [ErrorCategory:USER_ERROR, ErrorCode:DDL_FAILED], Detail:FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.DDLTask

There may be some data that doesn't match the table definition.
