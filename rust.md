# Rust

## Syntax

```
    let mut body = String::new();
```

The `::` syntax in `::new` indicates that `new` is an associated function of the `String` type

```
arg.parse::<i32>().map_err(|err| err.to_string()))
```

The `::` syntax in `parse::<i32>` indicates the return type so that the compiler knows the type of err. Without it, the compiler can only infer that `err` is `<F as FromStr>`, not the specific type `<i32 as FromStr>`, and so will generate `error[E0619]: the type of this value must be known in this context`

Expressions vs statements

`let x = 1;` - statement, has type of ()  
`x + 1;` - statement, has type of ()  
`x + 1` - expression, has type of i32

## Misc

Shadowing - can have two variables with the same name (they'll occupy different memory slots)

## Slices

```
let parsed = Url::parse("https://httpbin.org/cookies/set?k2=v2&k1=v1")?;
let cleaned: &str = &parsed[..Position::AfterPath];
```

## Error handling

`?` operator see https://m4rw3r.github.io/rust-questionmark-operator

## Traits

```
trait Eq {
    fn eq(&self, other: &Self) -> bool;
}
```

The reference to `Self` here will resolve to whatever type we implement the trait for; in `impl Eq for bool` it will refer to bool.

```
trait ClickCallback {
    fn on_click(&self, x: i64, y: i64);
}

struct Button {
    listeners: Vec<Box<ClickCallback>>,
    ...
}
```

In Rust, traits are types, but they are “unsized”, which roughly means that they are only allowed to show up behind a pointer like `Box` (which points onto the heap) or `&` (which can point anywhere).
