# CSV tools

## [dsq](https://github.com/multiprocessio/dsq)

SQLite based engine for querying CSV, parquet, and other file formats. The CLI for [datastation](https://github.com/multiprocessio/datastation)

```
brew install dsq
```

## [duckdb](https://github.com/duckdb/duckdb)

Custom engine for querying CSV and parquet.

## [datafusion](https://arrow.apache.org/datafusion/user-guide/cli.html)

Custom engine but requires multiple commands to ingest and work on CSV, so not great for one-liners.

## [q](http://harelba.github.io/q/)

For executing SQL queries on csv files. Backed by sqlite.

Older version (1.4) available in repo but it doesn't quote delimiter chars ([ref](https://github.com/harelba/q/issues/56)). To install: `sudo apt-get install q-text-as-data`

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

### q vs

5x faster than [csvkit](http://csvkit.readthedocs.io/en/1.0.2/) (which is also backed by sqlite)
Has a SQL syntax.

## [miller](https://github.com/johnkerl/miller)

Non-sql syntax. Support JSON and JSON Lines too.

Install

```
brew install miller
```

## [xan](https://github.com/medialab/xan)

Successor to xsv. Non SQL syntax with sample and regex functionality.

Install

```
brew install xan
```

Row count

```
xan count logs.csv
```

Count number of rows matching the regex

```
xan search "(root-7920f013|job-38f944ae)" logs.csv | xan count
```

Sort by time asc

```
xan sort -s _messagetime logs.csv
```

## [qsv](https://github.com/dathere/qsv)

..
