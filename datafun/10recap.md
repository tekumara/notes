# recap

- SELECT is the best for memory usage
- Batches help with IO
- Anything else you need external memory (disk) at scale, varies by batch size and parallelism
- Idempotency is your friend
