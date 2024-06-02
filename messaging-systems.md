# Messaging Systems

In general allow temporal decoupling, ie: connecting processes that operate at different throughputs that shouldn't speed up and slow down together. Queues act as a buffer between systems that vary in throughput and moderate busty load.

Semantics:

- pub/sub 1 to many fire and forget. Decoupled. You don't know which subscribers received the message, if any at all. Can't guarantee as response unless messages can be reliably persisted, and then acknowledged when there processing succeeds. If processing doesn't succeed within X attempts, then it moves to a DLQ.

- request/reply

Queues, ie: messages are stored when clients are offline

- DLQ

Streams
