# Exactly-once delivery is impossible but exactly-once processing is possible

Exactly-once delivery at the network communication layer is impossible. But exactly-once processing in the application layer is possible, if you design your system to tolerate duplicates through idempotency.

Idempotency means that even if a message is delivered multiple times, the processing logic ensures the effect happens only once. However, this does not mean you achieve exactly-once delivery — the message itself may still arrive more than once.

## Why Exactly-Once Delivery Is a Problem

The fundamental problem with network communication, is when something fails, there's no way to know with 100% certainty what happened on the other end. Exactly-once delivery is impossible because of this inherent ambiguity in determining delivery status during failures.

For exactly-once delivery to work, the sender must know with certainty whether a message was delivered exactly once. The process involves the receiver acknowledging receipt of the message. However, if this **acknowledgment fails to return** (e.g., due to a crash or network issue), the sender faces ambiguity:

- **The message may not have been delivered**: If the receiver crashed before processing the message, it never got through.
- **The message may have been delivered, but the acknowledgment was lost**: In this case, the sender doesn’t know the message was already processed.

This uncertainty forces the sender to make a choice:

1. **Re-deliver the message**: This ensures the message is processed but risks processing it multiple times.
2. **Drop the message**: This avoids duplicate processing but risks the message never being processed.

## But Exactly-Once Processing is Possible

While **exactly-once delivery** is impossible, **exactly-once processing** is achievable in many real-world applications.
The trick is to design processing in a way that it can handle duplicate deliveries safely. This is done by making processing **idempotent**. No matter how many times a message is processed, the outcome is the same as if it were processed just once.

eg: If the message is "Add $10 to Account A" we can add a unique ID to each transaction so duplicates are detected and ignored.

### The Memory Trade-off

This solution requires keeping track of which messages we've processed.
Theoretically, we need to store this information forever to guarantee perfect idempotency.
In practice, systems often compromise by storing this information for a reasonable time period.

## The Bottom Line

Many real-world applications that appear to have exactly-once delivery actually implement exactly-once processing through idempotency. This is good enough for most business needs, even if it's not technically "exactly-once delivery."
