# Scala native

Scala Native does not work with Java or Scala libraries. Scala Native supports a subset of the JDK with its own [native implementation](http://www.scala-native.org/en/v0.4.0/lib/index.html). It provides a subset of the [C standard library](http://www.scala-native.org/en/v0.4.0/lib/libc.html) and the [C POSIX library](http://www.scala-native.org/en/v0.4.0/lib/posixlib.html). It comes with its own [garbage collectors](http://www.scala-native.org/en/v0.4.0/user/sbt.html#garbage-collectors).

Scala Native doesn't provide libraries for [multi-threaded programming](http://www.scala-native.org/en/v0.4.0/user/lang.html#multithreading), although it may be possible to use C libraries for threading and synchronization primitives.

## Usage

Create a new scala native sbt project:

```
sbt new scala-native/scala-native.g8
```

Compile and link native code

```
# creates a binary at target/scala-*/project-name-out
sbt nativeLink
```

Compile, link and run:

```
sbt run
```
