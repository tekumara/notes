# golang syntax

if statement initialization

```go
if  var declaration;  condition {
    // code to be executed if condition is true
}
```

```go
    if sys, ok := fi.Sys().(*Header); ok {
        ...
    }
```

`&` = a pointer to the value
`*` = dereferences a pointer, returning the value it points to
`...` = arbitrary number of arguments, see [Variadic Functions](https://gobyexample.com/variadic-functions)

When two or more consecutive named function parameters share a type, you can omit the type from all but the last, eg:

```
func add(x int, y int) int { ...
```

can be shortened to

```
func add(x, y int) int { ...
```

## Type alias vs type definiton

An alias declaration has the form

```
type T1 = T2
```

as opposed to a standard type definition

```
type T1 T2
```

See [Type alias explained](https://yourbasic.org/golang/type-alias/)
