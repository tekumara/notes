# BSD date (Mac OS X)

Current date in millis

```
date +%s000
```

Convert literal UTC date to millis on Mac OS X:

```
date -j -f "%Y-%m-%d %H:%M:%S %Z" "2018-12-04 00:00:00 GMT" +%s000
```

Current time in UTC

```
date -u
```

Convert millis to UTC

```
date -r $((1555472733198/1000)) -u
```
