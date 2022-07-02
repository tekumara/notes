# aws athena

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
> SHOW CREATE TABLE `inventory`.`bucket-name`
> ```
>
> FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.DDLTask. java.lang.NullPointerException

Add the serde parameter `serialization.format=1` to your glue table.
