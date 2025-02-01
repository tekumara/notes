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

## Updating deps

Update the dep in Cargo.toml and then run `cargo build` to update the lockfile and rebuild.

## Specifying deps

If you specify a dependency as `"0.1.12"` it allows for any compatible version according to semantic versioning (semver), eg: in this case it means anything in the range `>=0.1.12, <0.2.0`. Use the string `"=0.1.12"` to pin to only that version and not a range.

See [Specifying Dependencies](https://doc.rust-lang.org/nightly/cargo/reference/specifying-dependencies.html)

## Tests

To run tests (auto rebuilding if needed):

```
cargo test
```

Cargo will search your source file for tests and show `running 0 tests` when they [don't contain any tests](https://doc.rust-lang.org/cargo/guide/tests.html).

Run tests showing stdout on success:

```
cargo test -- --nocapture
```

Run test called test_me:

```
cargo test test_me
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
