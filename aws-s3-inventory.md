# aws s3 inventory

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
		from_iso8601_timestamp(last_modified_date) as last_modified_date,
        -- partition key
		dt
	from inventory_my_bucket
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
where last_modified_date < date_add('day', -215, now())
	and dt = '2022-05-19-00-00'
group by fragments
order by fragments asc
```
