# Formal methods

Can be used to specify state machines for

- concurrent systems
- nondeterministic algorithms, involving randomness or a chance of failure.

And then use a model checker to assert invariants and temporal properties, or properties on the entire lifetime on the system, like “eventually all servers come online”.

## Specs

> Writing a specification serves three main purposes:
>
> It provides clear documentation of the system requirements, behavior, and properties.
> It clarifies your understanding of the system.
> It finds really subtle, dangerous bugs.

## Model checking

> Once we’ve written a spec and properties, we feed them into a “model checker”. The model checker takes the spec, generates every possible behavior, and sees if they all satisfy all of our properties. If one doesn’t, it will return an “error trace” showing how to reproduce the violation.
>
> Now we can’t check every possible behavior. In fact there’s an infinite number of them, since we can also add more accounts and transfers to the system. So we instead check all the behaviors under certain constraints, such as “all behaviors for three accounts, of up to 10 dollars in each account, and two transfers, of up to 10 dollars in each transfer.” We call this set of runtime parameters, along with all the other model checker configuration we do, the model.
>
> There are three types of invariants: safety (conditions that must always be true), liveness (conditions that must eventually become true), and stability (conditions that must eventually become true and remain true).
>
> The model checker will then use breadth-first search (BFS) to churn through all possible states (& thus execution orders) of your system, validating your invariants. If one of your invariants fails, BFS gives you the shortest execution path reaching that state. It even checks for deadlock by finding states with no possible successor states.

## TLA

> TLA+ is the Temporal Logic of Actions, where the “actions” are descriptions of state changes in the system. It’s a powerful way of expressing mutation.

## Liveness & Fairness

Liveness is the property that something good eventually happens. Practically this means avoiding infinite loops or deadlocks and states that cannot be recovered from. A deadlock is a state from which all transitions are disabled.

> Liveness in the simplest sense is just specification of reachability properties - does your system always eventually reach some desired state? - using something called a temporal formula

Focuses on a sequence of infinite actions, rather a finite execution, ie: ongoing processes. Fair scheduling ensures that all processes or actions get a chance to execute eventually.

Guard clauses define whether an action is enabled. Fairness defines whether an action will be taken if enabled.

### Weak Fairness

Weak fairness guarantees that if an action is always enabled, it will eventually be executed. In practical terms:

- It ensures that no permanently enabled action is ignored indefinitely.
- It applies only to actions that remain enabled without interruption.
- It's easier to implement and verify compared to strong fairness.

Weak fairness means the action will eventually be taken, and repeated.

### Strong Fairness

Strong fairness provides a stronger guarantee: if an action is cyclically enabled (ie: has interruptions), it will eventually be executed. In practical terms:

- It ensures that no action that is repeatedly enabled is ignored indefinitely.
- It applies to actions that are intermittently enabled.
- It's more challenging to implement and verify than weak fairness.

Weak fairness is both a safer assumption and more realistically feasible.

## Temporal logic

- Eventually always: The condition eventually becomes true and stays true forever after

- Always eventually: No matter what state the system is in, the specified condition will be true at some point in the future. Repeats indefinitely - the condition keeps occurring over and over again.

## Concurrency

> Concurrency is evil. Synchronous algorithms have a single well-defined output for a given input. Concurrent algorithms have a set of possible outputs depending on the order of events.
> Fortunately, we have much a better tool for studying concurrency: formal methods. By creating a mathematical description of the system, we can explore its properties in abstract.

## Stutter

> In TLA+, any behavior is allowed to stutter, or make a new state where nothing happens and all variables are unchanged. This includes stutter-steps, meaning any behavior can stutter infinitely, aka crash.
> Stutter steps don’t change the values of anything, so a stutter step can never break an invariant.
> ([ref](https://www.learntla.com/core/temporal-logic.html?highlight=stutter))

Stutter's preserve safety properties. But a stutter step can repeat infinitely, preventing us from reaching a good state.

## Time

Algorithms don't care about time, just the progression of states.

## References

- [Learn TLA+](https://learntla.com/core/index.html)
- [TLA⁺ is more than a DSL for breadth-first search](https://ahelwer.ca/post/2024-09-18-tla-bfs-dsl/)
- [Using Formal Methods at Work](https://www.hillelwayne.com/post/using-formal-methods/)
