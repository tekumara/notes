# rust references

## mut a: &T vs a: &mut T

```
    a: &T      // immutable variable of immutable reference
mut a: &T      // mutable variable of immutable reference, ie: can change what it points to
    a: &mut T  // mutable reference, ie: can change its reference
mut a: &mut T  // mutable variable of mutable reference, ie: can change both
```

eg:

```rust
let mut val1 = 2;
val1 = 3; // OK

let val2 = 2;
val2 = 3; // error: re-assignment of immutable variable
```

```rust
let val1 = &mut 2;
*val1 = 3; // OK

let val2 = &2;
*val2 = 3; // error: cannot assign to immutable borrowed content
```
