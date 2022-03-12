# golang

A package is a directory. Files in the directory are part of the package by declaring at the top of the file:

```
package <packagename>
```

## main

"The package “main” tells the Go compiler that the package should compile as an executable program instead of a shared library. The main function in the package “main” will be the entry point of our executable program. When you build shared libraries, you will not have any main package and main function in the package." - see [Understanding Golang Packages](https://thenewstack.io/understanding-golang-packages/)

## exports

Variables starting with an uppercase letter will be exported from a package.
