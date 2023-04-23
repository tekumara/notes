# rust compiler errors

To explain errors:

```
rustc --explain E0716
```

## method not found

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

## trait bounds were not satisfied

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

## cannot return reference to temporary value

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

Return the temporary value.

### Vector iteration

```rust
        let actions: Vec<CodeAction> = params.context.diagnostics.iter().map(|&diag| {
            CodeAction::default
        }).collect();
```

```
error[E0277]: a value of type `Vec<tower_lsp::lsp_types::CodeAction>` cannot be built from an iterator over elements of type `fn() -> tower_lsp::lsp_types::CodeAction {<tower_lsp::lsp_types::CodeAction as Default>::default}`
    --> crates/typos-cli/src/lsp.rs:82:12
     |
82   |         }).collect();
     |            ^^^^^^^ value of type `Vec<tower_lsp::lsp_types::CodeAction>` cannot be built from `std::iter::Iterator<Item=fn() -> tower_lsp::lsp_types::CodeAction {<tower_lsp::lsp_types::CodeAction as Default>::default}>`
     |
     = help: the trait `FromIterator<fn() -> tower_lsp::lsp_types::CodeAction {<tower_lsp::lsp_types::CodeAction as Default>::default}>` is not implemented for `Vec<tower_lsp::lsp_types::CodeAction>`
     = help: the trait `FromIterator<T>` is implemented for `Vec<T>`
```

`CodeAction::default` is a function .... use `CodeAction::default()` instead

### Iterator - trait bounds were not satisfied

```
error[E0599]: the method `map` exists for struct `Vec<Cow<'_, str>>`, but its trait bounds were not satisfied
   --> crates/typos-cli/src/lsp.rs:112:41
    |
112 | ...                   corrections.map(|c| {
    |                                   ^^^ method cannot be called on `Vec<Cow<'_, str>>` due to unsatisfied trait bounds
    |
   ::: /Users/oliver.mannion/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs:400:1
    |
400 | pub struct Vec<T, #[unstable(feature = "allocator_api", issue = "32838")] A: Allocator = Global> {
    | ------------------------------------------------------------------------------------------------ doesn't satisfy `Vec<Cow<'_, str>>: Iterator`
    |
    = note: the following trait bounds were not satisfied:
            `Vec<Cow<'_, str>>: Iterator`
            which is required by `&mut Vec<Cow<'_, str>>: Iterator`
            `[Cow<'_, str>]: Iterator`
            which is required by `&mut [Cow<'_, str>]: Iterator`
```

Vec is not an Iterator... instead do

```rust
    corrections.iter().map( ...
```

### Deserialize with a struct that has borrowed reference

```
error[E0277]: the trait bound `&'c Vec<Cow<'c, str>>: Deserialize<'_>` is not satisfied
    --> crates/typos-lsp/src/lsp.rs:19:18
     |
19   |     corrections: &'c Vec<Cow<'c, str>>,
     |                  ^^^^^^^^^^^^^^^^^^^^^ the trait `Deserialize<'_>` is not implemented for `&'c Vec<Cow<'c, str>>`
     |
note: required by a bound in `next_element`
    --> /Users/oliver.mannion/.cargo/registry/src/github.com-1ecc6299db9ec823/serde-1.0.160/src/de/mod.rs:1729:12
     |
1729 |         T: Deserialize<'de>,
     |            ^^^^^^^^^^^^^^^^ required by this bound in `SeqAccess::next_element`
help: consider removing the leading `&`-reference
     |
19   -     corrections: &'c Vec<Cow<'c, str>>,
19   +     corrections: Vec<Cow<'c, str>>,
     |
```

[Deserialize](https://docs.rs/serde/latest/serde/trait.Deserialize.html) is not implemented for `&Vec`. Which makes sense, because you can't deserialize into a `&Vec`.
