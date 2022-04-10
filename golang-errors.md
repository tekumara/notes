# golang errors

## UnaddressableOperand

```golang
    if t := util.ToTime(apikey.Expiration); t != nil {
        s = (*api.DateTime)(&t.UTC().Format(time.RFC3339))
    }
```

invalid operation: cannot take address of t.UTC().Format(time.RFC3339) (value of type string)compilerUnaddressableOperand

Solution:

```golang
    var expires_at *api.DateTime

    if t := util.ToTime(apikey.Expiration); t != nil {
        // place value in variable first so it can be addressed
        s := t.UTC().Format(time.RFC3339)
        expires_at = (*api.DateTime)(&s)
    }

```
