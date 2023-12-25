# rust default vs new

## default

Implement Default when there is a sensible default value for the type. This allows you to easily construct the type with `Default::default()` without having to specify all the fields, or to easily selectively override some, eg:

```rust
let options = SomeOptions { foo: 42, ..Default::default() };
```

Implementing Default also allows your type to be used easily with things like `Option::unwrap_or_default()` or `Result::unwrap_or_default()`.

## new

`new()` is a convention and is commonly expected but there's nothing special about it. Implement `new()` when there is no sensible default, or custom construction is needed based on arguments `new()` with no args may also be more appropriate when your type doesn't have a semantic default, or isn't a value type.

## new() vs default()

In many cases the expectation is that `new()` with no is args is equivalent to `default()`. To implement this, have `default()` call `new()`. If these are not the same, avoid the name `new()`.

NB: despite this, some value types have semantics that differ between new and default, eg: `Uuid::new()` vs `Uuid::default()` ([ref](https://users.rust-lang.org/t/should-foo-new-foo-just-be-impl-default-for-foo/69417/53)).

## References

- [Should `Foo::new() -> Foo` just be `impl Default for Foo`?](https://users.rust-lang.org/t/should-foo-new-foo-just-be-impl-default-for-foo/69417/8?u=y.e)
