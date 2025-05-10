# logfire

```sql
select trace_id, span_id, message, attributes->>'gen_ai.tool.name', exception_type, exception_stacktrace from records
where  attributes->>'gen_ai.tool.name' is not null or exception_type is not null
```
