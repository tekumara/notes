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

## Visualisation

Forks = tree depth
Actions = number of actions to this point in the tree

## Explorer

Stmt:0 = first in the oneof

Sequence diagrams only generated when there are roles.
