# duckdb-rs

[Hello world extension](https://github.com/duckdb/duckdb-rs/tree/9af377a19ab271e4cc054199438484b0b202bf2c/examples/hello-ext)

```
cargo build --example hello-ext --features="extensions-full vtab-loadable"
duckdb -unsigned
load "target/debug/examples/libhello_ext.dylib";
select * from hello("world");
```
