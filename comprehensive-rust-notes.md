# comprehensive rust notes

## [Functions](https://google.github.io/comprehensive-rust/basic-syntax/functions.html)

The last expression in a function body (or any block) becomes the return value. Simply omit the ; at the end of the expression.

## [Standard Library](https://google.github.io/comprehensive-rust/std.html)

In fact, Rust contains several layers of the Standard Library: core, alloc and std.

- core includes the most basic types and functions that don’t depend on libc, allocator or even the presence of an operating system.
- alloc includes types which require a global heap allocator, such as Vec, Box and Arc.

Embedded Rust applications often only use core, and sometimes alloc.

## Deref

When a type implements `Deref<Target = T>`, the compiler will let you transparently call methods from T.
String implements `Deref<Target = str>` which transparently gives it access to str’s methods.
Write and compare let `s3 = s1.deref();` and `let s3 = &*s1;`

## Box

Box is like std::unique_ptr in C++, except that it’s guaranteed to be not null.

A Box can be useful when you:

- have a type whose size that can’t be known at compile time, but the Rust compiler wants to know an exact size.
- want to transfer ownership of a large amount of data. To avoid copying large amounts of data on the stack, instead store the data on the heap in a Box so only the pointer is moved.

## Trait objects

Trait objects are a way to use dynamic dispatch with Rust’s type system. `dyn Greet` is a way to tell the compiler about a dynamically sized type that implements Greet.

Types that implement a given trait may be of different sizes. Therefore trait objects are dynamically sized types. Like all DSTs, trait objects are used behind some type of pointer; for example `&dyn Greet` or `Box<dyn Greet>`. Each instance of a pointer to a trait object includes:

- a pointer to the actual object
- a pointer to the virtual method table for the trait implementation (eg: `Greet`) of that particular object.

These are also known as fat pointers, because they contain more than just a pointer to the data.

The purpose of trait objects is to permit "late binding" of methods. Calling a method on a trait object results in virtual dispatch at runtime: that is, a function pointer is loaded from the trait object vtable and invoked indirectly.

To be used as a trait object a trait must be [object safe](https://doc.rust-lang.org/reference/items/traits.html#object-safety).

## Into

When declaring a function argument input type like “anything that can be converted into a String”, the rule is opposite, you should use Into. Your function will accept types that implement From and those that only implement Into.

## Associated types

```rust
pub trait Add<Rhs = Self> {
    type Output;

    fn add(self, rhs: Rhs) -> Self::Output;
}
```

Why is Output an associated type? Could it be made a type parameter?
Short answer: Type parameters are controlled by the caller, but associated types (like Output) are controlled by the implementor of a trait.

## [Impl trait](https://google.github.io/comprehensive-rust/generics/impl-trait.html)

`T: Trait` and `impl Trait` are similiar, except `impl Trait` is an anonymous type. When used as parameter the caller cannot specific the generic parameter, ie: it cannot be used with the `::<>` turbo fish syntax.

See also [The Rust Reference - Impl trait](https://doc.rust-lang.org/reference/types/impl-trait.html)

## [Closures](https://google.github.io/comprehensive-rust/generics/closures.html)

`Fn`, `FnOnce`, `FnMut` are traits that are implemented by closures. They are used to specify the type of a closure.

## Arc

No DerefMut, eg:

> cannot borrow data in an `Arc` as mutable
> trait `DerefMut` is required to modify through a dereference

This doesn't matter though if the it's wrapping a Mutex, because you can use the mutex's guard to get a mutable reference.

## Send

A type `T` is `Send` if it is safe to move a `T` value to another thread.

The effect of moving ownership to another thread is that destructors will run in that thread. So the question is when you can allocate a value in one thread and deallocate it in another.

## Sync

A type `T` is `Sync` if it is thread-safe, ie: safe to access a `T` value from multiple threads at the same time.
More precisely, the definition is:

> T is Sync if and only if &T is Send

This statement is essentially a shorthand way of saying that if a type is thread-safe for shared use, it is also thread-safe to pass references of it across threads.

This is because if a type is `Sync` it means that it can be shared across multiple threads without the risk of data races or other synchronization issues, so it is safe to move it to another thread. A reference to the type is also safe to move to another thread (ie: `Send`), because the data it references can be accessed from any thread safely (ie: `Sync`).

## `Send + !Sync`

These types can be moved to other threads, but they're not thread-safe.
Typically because of interior mutability:

- `mpsc::Sender<T>`
- `mpsc::Receiver<T>`
- `Cell<T>`
- `RefCell<T>`

## `!Send + Sync`

These types are thread-safe, but they cannot be moved to another thread:

- `MutexGuard<T>`: Uses OS level primitives which must be deallocated on the
  thread which created them.

## `!Send + !Sync`

These types are not thread-safe and cannot be moved to other threads:

- `Rc<T>`: each `Rc<T>` has a reference to an `RcBox<T>`, which contains a
  non-atomic reference count.
- `*const T`, `*mut T`: Rust assumes raw pointers may have special
  concurrency considerations.
