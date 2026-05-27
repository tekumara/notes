# Queues

## Prefer load shedding for interactive requests

Prefer load shedding to an internal queue for interactive requests, where users need a prompt response. When the service is overloaded, reject work quickly and let the caller retry with backoff rather than leaving the request queued for an unpredictable time. This keeps responsibility for end-to-end reliability with the caller.

## When to use a queue

Use a queue when:

- the service must take responsibility for retrying work on the caller's behalf
- the service must absorb spikes in traffic
- the user experience supports delayed results

The caller submits a request once, then either moves on or polls for the result. The service retains accepted requests and retries failed work. This provides an eventual result rather than an immediate failure response.

Queues are best suited to non-interactive work where users expect processing to take time and can return later for the results. Examples include batch processing, file extraction and background jobs.

A queue provides only local reliability between the caller and the queued service. It cannot guarantee that the wider operation succeeds end to end.

## Behaviour during traffic bursts

For synchronous requests, capacity determines availability. Requests above capacity fail or time out, so the service must scale quickly enough to meet request timeouts.

For queued work, capacity determines how quickly the backlog clears. Workers can scale more gradually because the queue buffers the work, trading immediate failure for a longer processing delay.

## Document extraction example

A bulk upload can submit many files for extraction at once. A queue accepts the files immediately and lets workers process them at a sustainable rate. If extraction fails, the service can retry without asking the user to upload the file again.
