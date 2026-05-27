# P language notes

## Event handling

### `announce`

Publishes an event for P specification monitors to observe. It does not deliver
that event to another machine.

```p
announce eDocumentRequestStatusChanged, payload;
```

Use it to expose an internal fact for a safety or liveness specification.

### `defer`

Postpones an event while the machine is in the current state. The event stays
pending rather than being handled or discarded. A later event that the current
state accepts may be processed first. Once the machine transitions to a state
that handles the deferred event, it can be processed.

```p
defer eWorkflowWake;
```

### `ignore`

Deliberately discards an event while the machine is in the current state.

```p
ignore eWorkflowWake;
```

Unlike `defer`, an ignored event is not retained for a later state.
