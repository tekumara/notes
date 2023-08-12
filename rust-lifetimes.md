# rust lifetimes

Lifetimes are named regions of code that a reference must be valid for, ie: for which a value is not moved or dropped. Lifetimes often coincide with scopes. Within a function, Rust has the information it needs and will create anonymous scopes and temporaries to make things work. However once you cross a function boundary, lifetime annotations can be needed. See [The Rustonomicon - Lifetimes](https://doc.rust-lang.org/nomicon/lifetimes.html)

Lifetimes are related to the stack. For a good overview see [Effective Rust - Understand lifetimes](https://www.lurklurk.org/effective-rust/lifetimes.html).

## Structs and lifetimes

> The lifetimes in the syntaxes `&'a Foo` and `Foo<'b>` mean different things. 'a in &'a Foo is the lifetime of Foo, or, at least the lifetime of this reference to Foo. 'b in Foo<'b> is a lifetime parameter of Foo, and typically means something like “the lifetime of data Foo is allowed to reference”.

`T<'a>` means that `T` contains references to data that has been stored elsewhere, outside of that object, and that data must have been created before the `T`. `T` has data that you can't own, but has been borrowed temporarily (ie: for the lifetime `'a`) for shared access.

References in structs are viral, and infect everything they touch ([ref](https://users.rust-lang.org/t/borrowed-value-does-not-live-enough-for-async-on-same-scope/60079/3)).

See [Encapsulating Lifetime of the Field](https://matklad.github.io/2018/05/04/encapsulating-lifetime-of-the-field.html).

## assignment requires that `'1` must outlive `'2`

```
error: lifetime may not live long enough
  --> src/lib.rs:19:9
   |
14 |     fn update_config(&mut self) {
   |                      ---------
   |                      |
   |                      let's call the lifetime of this reference `'1`
   |                      has type `&mut BackendState<'2>`
...
19 |         self.config = Config { engine };
   |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ assignment requires that `'1` must outlive `'2`
```

[playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=2be7b804cb1d0de083cbc620b2a6f7e9), [Rust user forum](https://users.rust-lang.org/t/assignment-requires-that-1-must-outlive-2/98050)

The error message suggests that `self` of lifetime `'1`, references a `BackendState` which contains references of lifetime `'2` (inferred from `impl BackendState<'_>`). NB: although `self` only exists in the scope of this function, the lifetime of `self` does not and will continue in the caller.

Why does the `self` reference have to live longer than the references in `BackendState` for the assignment to be valid? Because `BackendState` contains a reference (lifetime `'2`) to `self.storage`, `self` must live as long as the `'2'` for this to be valid. ie: this is a self-referential struct. To fix this, we can tell the borrow checker the [lifetimes are the same](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=8713dc1dbd0946b5c25d2a38555e05c4), which will make the object immovable.

```
error[E0521]: borrowed data escapes outside of method
  --> src/lib.rs:30:25
   |
29 |     async fn did_change_workspace_folders(&self, added: Vec<PathBuf>, removed: Vec<PathBuf>) {
   |                                           -----
   |                                           |
   |                                           `self` declared here, outside of the method body
   |                                           `self` is a reference that is only valid in the method body
   |                                           let's call the lifetime of this reference `'1`
30 |         let mut state = self.state.lock().unwrap();
   |                         ^^^^^^^^^^^^^^^^^
   |                         |
   |                         `self` escapes the method body here
   |                         argument requires that `'1` must outlive `'static`
```

[playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=393a89bb5a67376d5085a50fc67c81c8)

This is caused by state being passed to a function (not seen here) with a longer lifetime. This causes self to require a longer lifetime. Either tell the compile that `&self` is needed for a longer lifetime, or shorten the lifetime for which `state` (and therefore `self`) is required in the called function.

## does not live long enough

```
error[E0597]: `state` does not live long enough
  --> src/lib.rs:30:9
   |
28 |     async fn did_change_workspace_folders(&'s self, added: Vec<PathBuf>, removed: Vec<PathBuf>) {
   |                                           -------- lifetime `'1` appears in the type of `self`
29 |         let mut state = self.state.lock().unwrap();
   |             --------- binding `state` declared here
30 |         state.update_config()
   |         ^^^^^^^^^^^^^^^^^^^^^
   |         |
   |         borrowed value does not live long enough
   |         argument requires that `state` is borrowed for `'1`
31 |     }
   |     - `state` dropped here while still borrowed
```

[playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=f3bca15a784e55bf0e2cd7847ab8a59d)

[E0597](https://doc.rust-lang.org/error_codes/E0597.html) occurs because a value was dropped while it was still borrowed.

`update_config` expects `&'s mut self` .. whereas `state` is local. ie: we don't have a lifetime that lives as long as `'s`.

## Mutex

Each unlock of a Mutex provides a MutexGuard with a mut reference. So it introduces a lifetime.
