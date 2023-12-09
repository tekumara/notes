# rust options

To convert a `Option<T>` to `Option<&T>`:

```rust
opt.as_deref()

// or

match opt {
            Some(ref x) => Some(x),
            None => None,
        }

```
