# CSV tools

## [q](http://harelba.github.io/q/)

For executing SQL queries on csv files. Backed by sqlite.

Older version (1.4) available in repo but it doesn't quoted field chars ([ref](https://github.com/harelba/q/issues/56)). To install: `sudo apt-get install q-text-as-data`

Latest version (1.6.3, recommend):

- download from http://harelba.github.io/q/install.html and run `sudo dpkg -i ~/Downloads/q-text-as-data*`
- if `python` is python 3, and you get `SyntaxError: invalid syntax` when running `q`, to fix:`sudo sed -i 's/env python$/env python2/' /usr/bin/q`

eg:

```
q -H -d, "select [cat code] from TestQueries.csv where [cat code] is not null"
q -H -d, -O "select [query], [location], gs.[cat code], gs.[cat name] from goldset_with_location.csv gsl left join goldset.csv gs on (gsl.query = gs.[query term])"
```

-H = csv has header row
-d, = delimiter is comma
-A = show type of columns
-O = output header

eg:

```
q -H -d, -O 'select a.viewtimestamp,a.jobid,a.source,a.sessionid,b."min(ASPXAUTH)" from missing-events-with-sessionid.csv a left join missing-events-with-sessionid-auth-cookie-uniq.csv b on a.jobid = b.jobid and a.sessionid = b.sessionid' > results.csv
wc -l results.csv
# 11199
grep ASPXAUTH results.csv | wc -l
# 4147
echo 'scale=2;4147/11198' | bc
# .37
```

## vs

5x faster than [csvkit](http://csvkit.readthedocs.io/en/1.0.2/) (which is also backed by sqlite)
Has a SQL syntax, unlike [Miller](http://johnkerl.org/miller/doc/) and [xsv](https://github.com/BurntSushi/xsv)

xsv has sample and regex functionality tho.
