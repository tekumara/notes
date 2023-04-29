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
