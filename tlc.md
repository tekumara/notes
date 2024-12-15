# tlc

## Trouble-shooting

> Error: In evaluation, the identifier x is either undefined or not an operator.

Unprime the vars in the `init` step see [#2863](https://github.com/apalache-mc/apalache/issues/2863)

> Error: The invariant X is not a state predicate (one with no primes or temporal operators).

In the .cfg file change `INVARIANTS` to `PROPERTY`.
