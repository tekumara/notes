# fizbee

In addition to model checking like TLA+/PlusCal, Alloy, etc, FizzBee also has performance and probabilistic model checking.

> Actions indicate what may happen in the system, not what must happen. We need to specify what must happen. This is done by adding keyword fair to an action.

## Yields

Yields after each [simple python statement](https://fizzbee.io/tutorials/guard-clause/#implementation-detail) ie: assignment, etc. Crashes can happen at yield points.

Atomic = no yield point in the block. Either the whole block executes or none of the block, ie: can't crash halfway through. Also won't interleave with concurrent actions (of its own type or other types).

## Crash vs stutter

Crashes are represented as valid states when there are no safety or liveness assertions.

- Black node = safe
- Red node = unsafe, including nodes caused by a crash
- Green node = live nodes, ie: match assertions
- Green arrows = fair action that will occur

Stutters appear when there are liveness assertions, and no fair actions that make progress towards the live state. Stutter appears on the error graph and is equivalent to crash on the states graph, although the crash state occurs regardless of any liveness assertions.

## Deadlock

Means we have reached a state with no further transitions because there are no enabled actions. This can happen when, either:

- all actions are disabled, or
- some actions are waiting, and they consume all available concurrency and so enabled actions can't run (happens when `if` is the last statement see [here](https://github.com/fizzbee-io/fizzbee/issues/109#issuecomment-2509387638))

## States graph

Forks = tree depth
Actions = number of actions to this point in the tree
Threads: 0/2 - there are 2 active threads.

## Explorer

Stmt:0 = first in the oneof

Sequence diagrams only generated when there are roles. A role will appear on the sequence diagram if a function is called on it.

## Error states diff

Diff shows the current state on the right hand side and last state on left side.

The state on the left hand side is:

- diff link: the last state
- yield diff: the last yield. This is usually the same as diff link, except when the last state is a crash then this shows the yield before the crash.

## Vs TLA+

In TLA+ actions are atomic. Atomic actions have no yield points between the statements. In Fizzbee actions and blocks are no atomic unless explicitly stated as `atomic` and so can interleave.

See [FizzBee Quick Start for TLA+ Users](https://github.com/fizzbee-io/fizzbee/blob/8ea290d56e9d3d35baf9b710cadfd64fd1bab30a/docs/fizzbee-quick-start-for-tlaplus-users.md).

FizzBee can more succiently model parallel statements using `parallel`. See the equivalent [tla+ here](https://github.com/fizzbee-io/fizzbee/blob/8ea290d56e9d3d35baf9b710cadfd64fd1bab30a/docs/language_design_for_review.md#parallel).
