# cargo

Create a new application project called `myapp` including initialising a git repo

```
cargo new myapp --bin
```

Add reqwest to Cargo.toml

```
cargo add reqwest
```

Build docs for package and view locally:

```
cargo doc -p tracing-subscriber --open
```

Run clippy on a package and not its dependencies:

```
cargo clippy --no-deps --package typos-lsp
```

Format:

```
cargo install rustfmt
cargo fmt
```

## Tests

Cargo will search your source file for tests and show `running 0 tests` when they [don't contain any tests](https://doc.rust-lang.org/cargo/guide/tests.html).

Run tests showing stdout:

```
cargo test -- --nocapture
```

## utils

Show features of a crate:

```
❯ cargo whatfeatures tokio
tokio = "1.27.0"
└─ features
├─ no default features
├─ bytes
├─ fs
├─ full
...
```
