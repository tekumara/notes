# rust compiler errors

To explain errors:

```
rustc --explain E0716
```

```rust
method not found in `ClientSocket`
```

Check the visibility of the method.

```rust
    fn parse_message(src: &mut[u8]) -> &str {
        // skip over header
        src.advance(10);
        ...
```

```
error[E0599]: the method `advance` exists for mutable reference `&mut [u8]`, but its trait bounds were not satisfied
   --> src/main.rs:101:13
    |
101 |         src.advance(memchr::memmem::find(src, b"Content-Length").unwrap_or_default());
    |             ^^^^^^^ method cannot be called on `&mut [u8]` due to unsatisfied trait bounds
    |
    = note: the following trait bounds were not satisfied:
            `[u8]: Buf`
            which is required by `&mut [u8]: Buf`
```

[Impls of Buf](https://docs.rs/bytes/1.4.0/bytes/buf/trait.Buf.html#foreign-impls) are:

```rust

impl<T: Buf + ?Sized> Buf for &mut T

impl Buf for &[u8]
```

ie: Buf is implemented for `&mut T` if `Buf` is implemented for `T`. Above T is `[u8]`, but Buf is only implemented for `&[u8]`

```
error[E0599]: no method named `iter` found for enum `Status` in the current scope
...
note: the method `iter` exists on the type `Vec<Cow<'_, str>>`
```

Pattern match to narrow the enum down to the iterable variant.

```
error[E0515]: cannot return reference to temporary value
   --> crates/typos-lsp/src/main.rs:169:9
    |
169 |         format!("Content-Length: {}\r\n\r\n{}", msg.len(), msg).as_bytes()
    |         -------------------------------------------------------^^^^^^^^^^^
    |         |
    |         returns a reference to data owned by the current function
    |         temporary value created here
```
