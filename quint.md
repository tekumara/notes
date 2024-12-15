# quint

> Contrary to what engineers are likely to expect from programming languages, evaluation of expressions in TNT never advance the state (arguably with the exception of then?): evaluation of expressions only determines values which can be used to describe the properties of, or relations between, states.

https://github.com/informalsystems/quint/discussions/435

> In this case, all side effects (lazy assignments) produced by a*1, ..., a*{i+1} are erased, and the operator returns false. If all actions evaluate to true, all their side effects are applied, and the operator returns true.

https://quint-lang.org/docs/lang#block-conjunctions

## Troubleshooting

Given:

```
        match maybeMsg {
            | None => {
                false
            }
            | Some(msg) => {
                ui' = ui.append(msg)
            }
        }
```

Will error with the following because the branches of the match must return same type:

```
Expected [ui] and [] to be the same
Trying to unify entities ['ui'] and []
Trying to unify Read[_v137] and Read['ui'] & Update['ui']
Trying to unify (Read['ui']) => Read[_v137] and (Read[_v131]) => Read[_v131, 'ui'] & Update['ui']
Trying to unify (_e43, Pure, (_e43) => Read[_v135] & Update[_v136], Pure, (_e43) => Read[_v137] & Update[_v136]) => Read[_v135, _v137] & Update[_v136] and (Read['ui'], Pure, (_e39) => Pure, Pure, (Read[_v131]) => Read[_v131, 'ui'] & Update['ui']) => _e42
Trying to infer effect for operator application in matchVariant(maybeMsg, "None", ((_) => false), "Some", ((msg) => assign(ui, append(ui, msg))))
```

ie: match is an expression.

This works:

```
    match maybeMsg {
        | None => {
            ui' = ui
        }
        | Some(msg) => {
            ui' = ui.append(msg)
        }
    }
```

## Model checker

`quint verify` uses [apalache](https://github.com/apalache-mc/apalache). Limitations:

- limited supported for [liveness checking](https://github.com/apalache-mc/apalache/issues/488) - see also [verify: surprising temporal result](https://github.com/informalsystems/quint/issues/1501)
- [doesn't detect all deadlocks](https://github.com/apalache-mc/apalache/issues/711)

To avoid these [compile to TLA and use TLC](https://github.com/informalsystems/quint/issues/1424).

To run apalache on tla files compiled from quint:

```
apalache-mc check --config=genie.cfg genie.tla
```

## TLC

Run from quint:

```
java -cp ~/.quint/apalache-dist-0.46.1/apalache/lib/apalache.jar -XX:+UseParallelGC tlc2.TLC myapp.tla
```

See also [tlc](tlc.md).
