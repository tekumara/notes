# python dates

python <3.11 will fail on:

```
datetime.fromisoformat('2011-11-04 00:05:23.283Z')
```

use python 3.11, or this instead:

```
datetime.fromisoformat('2011-11-04 00:05:23.283+00:00')
```

See the [docs](<https://docs.python.org/3/library/datetime.html#datetime.datetime.fromisoformat:~:text=Changed%20in%20version%203.11%3A%20Previously%2C%20this%20method%20only%20supported%20formats%20that%20could%20be%20emitted%20by%20date.isoformat()%20or%20datetime.isoformat().>)
