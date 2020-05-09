# Rust

## Rust Install

In Ubuntu and Mac OS X, install using rustup: 
```
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
```

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

## Formating

```
cargo install rustfmt
cargo fmt
```

## Issues

No line numbers in stack traces on Mac OS X [#24346](https://github.com/rust-lang/rust/issues/24346)

## Error handling

`?` operator see https://m4rw3r.github.io/rust-questionmark-operator

## Debugging

For debugging, most people use VSCode+Rust+LLDB.

## lldb

eg: `rust-lldb ./target/debug/guessing-game`

`b main.rs:21` - set breakpoint  
`br list` - breakpoint list  
`r` - start execution  
`print guess` - print variable guess  
`n` - step over  
`c` - continue execution  
`fr v` - show all local variables  
`thread list` 

## Sublime Text 3 with Rust Enhanced + Rust Autocomplete

Pros 
* fast compilation on file save
* shows compilation errors inline

Cons
* requires the [YcmdCompletion package](https://packagecontrol.io/packages/YcmdCompletion) to see Types
* can't goto definition on variable method 


## Sublime Text 3 with RLS

https://github.com/rust-lang-nursery/rls/issues/214

## Intellij Rust

A plugin for Intellij and Clion.

Cons
* errors aren't inline
* no debugger. Clion has GDB support, which can be used for debugging, it's experimental but see [#535](https://github.com/intellij-rust/intellij-rust/issues/535#issuecomment-320866757)
Pros
* can join from struct/type to impl

`CTRL - SHIFT - A` Toggle parameter name hints (can also add a keyboard shortcut)


## Cargo

create a new application project called `myapp` including initialising a git repo: `cargo new myapp --bin`

cargo-edit will modify Cargo.toml for you, eg: to add reqwest to Cargo.toml
```
cargo install cargo-edit
cargo add reqwest
```

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

