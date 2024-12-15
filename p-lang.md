# p lang

## State machines

[P State Machines](https://p-org.github.io/P/manual/statemachines/)

`defer` = ignore event, and move on to the next
`ignore` = drop event from queue

## Interleaving

> A way to think about it is that each state machine is executing concurrently and the only shared state in the system (for which there can be race condition) is the inbox or message buffers. So, when any event handler in any state machine is executed, then yield or scheduling points are only inserted just before each send and receive operation so that the scheduler can interleave all sends and receives. Everything else thats executed between these sends is atomic as it only accesses local state.

## Statements

[Goto](https://p-org.github.io/P/manual/statements/#goto) changes state.

[Insert into a sequence](https://p-org.github.io/P/manual/statements/#insert) using the current size as the insertion index.

## Checking runs forever

The checker will run a single schedule forever if your machines don't have a terminal state. A terminal state has no transitions, ie: does not send any events.

If you can't add a terminal state (recommended) then check with a fixed number of steps, eg:

```
p check -ms 10
```

This will detect any bugs including liveness bugs.

## Bug finding

When `p check` finds a bug, check the verbose log to see more detail:

```
cat PCheckerOutput/BugFinding/trace_0_0.txt
```

## Peasy doesn't find project

If the Peasy vscode extension doesn't find your .pproj file on startup, open the command palette `Peasy: Show Project Files` and select it.

## Schedule points

See [Scheduler.ScheduleNextEnabledOperation](https://github.com/p-org/P/blob/65042fe63f0da89a60d6e91c8f25289ac7eee168/Src/PChecker/CheckerCore/SystematicTesting/OperationScheduler.cs#L110)

## References

- [What exactly does defer do?](https://github.com/p-org/P/discussions/515)
- [Questions about FailureInjector.p](https://github.com/p-org/P/issues/691)
- [resonatehq/p-resonate-workers](https://github.com/resonatehq/p-resonate-workers) - example
