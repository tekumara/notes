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

Temporary variables are destroyed when they go out of scope at the end of the statement. So returning a reference to a temporary variable is dangerous because the referenced object will no longer exist once the function exits.

The solution is to return the temporary value instead, or a reference to a longer lived variable.

## cannot return reference to function parameter

```
error[E0515]: cannot return reference to function parameter `v`
   --> crates/typos-lsp/src/lsp.rs:111:57
    |
111 |             let cli = try_new_cli(&path, config.map(|v| v.as_path()))?;
    |                                                         ^^^^^^^^^^^ returns a reference to data owned by the current function
```

This error occurs when trying to return a reference to a function parameter in Rust.

In Rust, function parameters are stored on the stack. When the function returns, the stack frame is popped and the parameter goes out of scope. So returning a reference to a parameter would result in returning a reference to invalid memory.

To fix this, you need to return data that has a lifetime extending beyond the function call, eg: returning an owned value instead of a reference.

## cannot move out of `self.config` which is behind a mutable reference

```
error[E0507]: cannot move out of `self.config` which is behind a mutable reference
    --> crates/typos-lsp/src/lsp.rs:110:26
     |
110  |               let config = self
     |  __________________________^
111  | |                 .config
     | |                       ^
     | |                       |
     | |_______________________help: consider calling `.as_ref()` or `.as_mut()` to borrow the type's contents
     |                         move occurs because `self.config` has type `std::option::Option<std::string::String>`, which does not implement the `Copy` trait
112  |                   .map(|v| PathBuf::from(shellexpand::tilde(&v).to_string()));
     |                    ---------------------------------------------------------- `self.config` moved due to this method call
     |
note: `std::option::Option::<T>::map` takes ownership of the receiver `self`, which moves `self.config`
    --> /Users/oliver.mannion/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/option.rs:1070:22
     |
1070 |     pub fn map<U, F>(self, f: F) -> Option<U>
     |                      ^^^^
help: you can `clone` the value and consume it, but this might not be your desired behavior
     |
112  |                 .clone().map(|v| PathBuf::from(shellexpand::tilde(&v).to_string()));
     |                  ++++++++

```

`map` is trying to move out of `self.config` but `self` is a mutable reference. Rust does not allow moving out of a mutable reference because that would invalidate the reference.

Instead convert it to a reference to borrow it, ie: `self.config.as_ref()...`

## Vector iteration

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

## Iterator - trait bounds were not satisfied

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

## Deserialize with a struct that has borrowed reference

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

### cannot borrow `*self` as mutable because it is also borrowed as immutable

```
error[E0502]: cannot borrow `*self` as mutable because it is also borrowed as immutable
   --> crates/typos-lsp/src/lsp.rs:101:13
    |
95  |         for folder in self.workspace_folders.iter() {
    |                       -----------------------------
    |                       |
    |                       immutable borrow occurs here
    |                       immutable borrow later used here
...
101 |             self.router_insert(&path_wildcard, &path)?;
    |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ mutable borrow occurs here


```

Context:

```rust
struct BackendState<'s> {
    severity: Option<DiagnosticSeverity>,
    config: Option<PathBuf>,
    workspace_folders: Vec<WorkspaceFolder>,
    router: Router<TyposCli<'s>>,
}

impl<'s> BackendState<'s> {
    ...
    fn router_insert(&mut self, route: &str, path: &PathBuf) -> anyhow::Result<(), anyhow::Error> {
        tracing::debug!("Adding route {} for path {}", route, &path.display());
        let cli = try_new_cli(&path, self.config.as_deref())?;
        self.router.insert(route, cli)?;
        Ok(())
    }

```

In this example `&mut` is only needed for `self.router` not `self`. When inlined Rust can determine which fields in a struct are being used immutably and which are used mutably and this error doesn't occur. But when passing the struct as a `&mut` to a method it doesn't extend its analysis to the method's implementation and only uses the signature.

Solutions

- inline
- free function - avoid passing `&mut self` to `router_insert` and instead pass each arg to a free function without `self`
- break the struct into smaller pieces
- extension trait

Ref
- [What is the best way of dealing with "cannot borrow self as mutable because it is also borrowed as immutable"?](https://www.reddit.com/r/rust/comments/q0uo6t/what_is_the_best_way_of_dealing_with_cannot/)
