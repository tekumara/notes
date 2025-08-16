# logfire

## SQL

Tools or exception:

```sql
select trace_id, span_id, message, attributes->'gen_ai.tool.name', exception_type, exception_stacktrace from records
where  attributes->'gen_ai.tool.name' is not null or exception_type is not null
```

First two messages or exception:

```sql
select trace_id, span_id, duration, message,
attributes->'all_messages_events'->1->>'content' as '1user',
attributes->'all_messages_events'->2->>'content' as '2assistant',
attributes->'all_messages_events'->2->'tool_calls'->0->'function'->'name' as '2tool0',
exception_type, exception_stacktrace
from records
where message = 'agent run'
```

Unnest all_messages_events (one per row):

```sql
WITH message_events AS (
  SELECT
    span_id, duration, span_name,
    attributes->'all_messages_events'->unnest(generate_series(0, (json_length(attributes->'all_messages_events')-1)::int)) as message_event,
    exception_type, exception_stacktrace
  FROM records
  WHERE otel_scope_name = 'pydantic-ai'
    AND attributes->'all_messages_events' IS NOT NULL
)
SELECT
span_id, duration, span_name,
message_event->>'gen_ai.message.index' as "gen_ai.message.index", message_event->>'role' as message_role, message_event->>'name' as tool_name, message_event, exception_type, exception_stacktrace
FROM message_events
```

Logfire uses datafusion as its database with syntactic sugar to make it support a postgresql like dialect.

A Postgresql JSON like syntax is provided by [datafusion-contrib/datafusion-functions-json](https://github.com/datafusion-contrib/datafusion-functions-json).

### SQL Types

To get type of column use `arrow_typeof` see [Data Types](https://datafusion.apache.org/user-guide/sql/data_types.html)

[`Dictionary(Int64, Utf8)`](https://docs.rs/arrow/latest/arrow/datatypes/enum.DataType.html#variant.Dictionary) is a data type used in Apache DataFusion (and Arrow, which DataFusion builds upon) to efficiently represent columns with many repeated string values. This type is commonly referred to as a "dictionary-encoded" or "categorical" column.

- Int64: The key type. Each value in the column is stored as a 64-bit integer index (key).
- Utf8: The value type. The dictionary itself is an array of unique UTF-8 encoded strings.

## Metrics

Logfire sends metrics such as `gen_ai.client.token.usage` using the `OTLPMetricExporter`. It provides a `Token Usage (from metrics)` dashboard to visualise this data broken down by model and type (ie: input/output).

## Troubleshooting

```
select trace_id, span_id, message, (attributes->>'all_messages_events')[0], attributes->>'gen_ai.tool.name', exception_type, exception_stacktrace from records

Failed to coerce arguments to satisfy a call to 'array_element' function: coercion from [Dictionary(Int64, Utf8), Int64] to the signature ArraySignature(Array { arguments: [Array, Index], array_coercion: None }) failed No function matches the given name and argument types 'array_element(Dictionary(Int64, Utf8), Int64)'. You might need to add explicit type casts. Candidate functions: array_element(array, index)
```

`attributes->'all_messages_events'` is a JSON array not a SQL array. To query a JSON array use `->0` for the first element eg: `attributes->'all_messages_events'->0`.
