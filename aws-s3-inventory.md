# aws s3 inventory

Describe inventory config

```
aws s3api get-bucket-inventory-configuration --bucket $bucket --id $name
```

## table creation

parquet example:

```
CREATE EXTERNAL TABLE inv(
         bucket string,
         key string,
         size bigint,
         last_modified_date bigint,
         encryption_status string,
         storage_class string,
         intelligent_tiering_access_tier string
) PARTITIONED BY (
        dt string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
  STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.SymlinkTextInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat'
  LOCATION 's3://inventory-bucket/source-bucket/config-name/hive/'
  TBLPROPERTIES (
    "projection.enabled" = "true",
    "projection.dt.type" = "date",
    "projection.dt.format" = "yyyy-MM-dd-HH-mm",
    "projection.dt.range" = "2022-01-01-00-00,NOW",
    "projection.dt.interval" = "1",
    "projection.dt.interval.unit" = "DAYS"
  );
```

See [this page](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-inventory-athena-query.html) to create the athena tables.

```sql
--- top level prefixes (3 deep) with objects older than 215 days
WITH inventory AS (
	select url_decode(
			-- remove suffix
			substr(
				key,
				1,
				length(key) - strpos(reverse(key), '/') + 1
			)
		) as base,
		url_decode(key) as key,
		cast(size as bigint) / 1000 as "size_kb",
		from_unixtime(last_modified_date/1000) as last_modified_date,
		-- partition key
		dt
	from inv
),
inventory_fragments AS (
	select *,
		slice(split(base, '/'), 1, 3) as fragments
	from inventory
)
select reduce(
		fragments,
		'',
		(s, x)->s || x || '/',
		-- strip trailing double slash when last fragment is empty
		s->if(
			length(element_at(fragments, -1)) > 0,
			s,
			substr(s, 1, length(s) -1)
		)
	) as prefix,
	sum(size_kb) as sum_size_kb,
	min(last_modified_date) as min_last_modified_date
from inventory_fragments
where last_modified_date < date_add('day', -35, now()) and last_modified_date > date_add('day', -215, now())
	and dt = '2022-05-22-00-00'
group by fragments
order by fragments asc
```

When the data is in CSV format, `last_modified_date` is a string so use `from_iso8601_timestamp(last_modified_date) as last_modified_date` instead.
