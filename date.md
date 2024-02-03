# date

## Linux + MacOS

Current date in millis

```
date +%s000
```

Current day in YYYY-MM-DD format:

```
date +%F
```

Current time in UTC

```
date -u
```

## MacOS (BSD) only

Convert millis to UTC

```
date -r $((1555472733198/1000)) -u
```

Convert literal UTC date to millis:

```
date -j -f "%Y-%m-%d %H:%M:%S %Z" "2018-12-04 00:00:00 GMT" +%s000
```
