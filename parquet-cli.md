# Parquet cli

[Apache java parquet cli](https://github.com/apache/parquet-java/tree/master/parquet-cli)

## Alternatives

- [pqrs](https://github.com/manojkarthick/pqrs) (Rust - parquet-cpp-arrow) is better at decoding parquet files, doesn't require java, but has less meta info.
- [hangxie/parquet-tools](https://github.com/hangxie/parquet-tools) - Go: `brew install go-parquet-tools`

## Install

```
brew install parquet-cli
brew install manojkarthick/tap/pqrs
```

## Usage

```
parquet schema <file>

parquet meta <file>

# show first record
parquet head -n1 <file>

# show all in json format
parquet cat -j <file>

# first example in json
parquet -j <file> | head -n1
```

To see row counts:

```
❯ parquet meta cities.parquet

File path:  cities.parquet
Created by: parquet-mr version 1.5.0-cdh5.7.0 (build ${buildNumber})
Properties: (none)
Schema:
message hive_schema {
  optional binary continent (STRING);
  optional group country {
    optional binary name (STRING);
    optional group city (LIST) {
      repeated group bag {
        optional binary array_element (STRING);
      }
    }
  }
}


Row group 0:  count: 3  155.33 B records  start: 4  total(compressed): 466 B total(uncompressed):466 B
--------------------------------------------------------------------------------
                                type      encodings count     avg size   nulls   min / max
continent                       BINARY    _ RBR     3         31.00 B    0
country.name                    BINARY    _ RB_     3         24.67 B    0
country.city.bag.array_element  BINARY    _ RR_     21        14.24 B    0
```
