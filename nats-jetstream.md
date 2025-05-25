# nats jetstream

Also ordered consumers have ack policy set to none - so the acks have no effect

ack is to record the state of the consumer on the server, ordered consumers, don’t record state, they simply watch messages and insure the ordering guarantees.

yea, certainly depends on the audience. its roots are certainly in subject-based messaging. this style of messaging provides decoupling of space between publishing and subscribing clients. Combine that with the clustering capabilities, now you have regional, multi-region (global), and/or edge spatial decoupling (since it handles subject interest propagation automatically).
beyond messaging, persistence (via streams) exists in the JetStream subsystem which decouples time between publishing and subscribing clients (among other things).
kv and object store are client abstractions on top of the stream to handle the basic needs that would otherwise necessitate Redis or S3 (for example).
it has evolved to be a spectrum of developer APIs backed by one server with a consistent security and operational model.

Because KV is stored in a single stream for all keys in the bucket AND a key can have max history of lets say 5, once you have more than 5 values for a key it has to delete the oldest one. so say you have 10 keys and the 4th is hitting its max history, to delete that 1 message a gap needs to be made in the stream - we have to tell the server that message is now orphaned. When this happens not as the first or last message in a stream then its an interior delete - a gap in the stream. ah ok, this makes thing a bit more clear.
i was looking at it like a map of keys with an array of values
but i need to look at it like a single array with an internal management of which key is related to which items, yeah pretty much, in upcoming 2.10 we improved the tracking of these deleted messages so they should have a lower impact

see https://github.com/nats-io/nats-architecture-and-design/blob/main/adr/ADR-8.md#deleting-values

There shouldn’t be a significant difference in latency push vs pull.

ordered consumers are not durable and they cannot be shared by 2 clients either, its just a way to like "tail -f" a stream into your client.. ... ordered consumers are efficient ... they are push based in the python api but can be pull in the new api.. push consumers give you a sequence number and delta

see https://github.com/nats-io/nats.py/blob/3434d58/nats/js/client.py#L292

see also

- [ADR-13: Pull Subscribe internals](https://github.com/nats-io/nats-architecture-and-design/blob/main/adr/ADR-13.md)
- [ADR-17: Ordered Consumer](https://github.com/nats-io/nats-architecture-and-design/blob/main/adr/ADR-17.md)

Pull is much easier to use and understand in general... it also scales better.

By default `MaxDeliver` is infinite.

## Consumer

eg:

```python
    psub = await js.pull_subscribe(
        subject="$KV.dwatch.>",
        durable="psub",
        stream="KV_dwatch",
        # will redeliver if not acked within 1 second
        config=nats.js.api.ConsumerConfig(ack_wait=1,deliver_policy=nats.js.api.DeliverPolicy.LAST_PER_SUBJECT),
    )
```

### Consumer config

Config is only used when the consumer is first created. Use `nats consumer edit` to update [editable fields](https://docs.nats.io/nats-concepts/jetstream/consumers#configuration) on an existing consumer. To change non-editable fields, the consumer needs to be recreated, which will cause redelivery of all messages.

## Troubleshooting

### consumer filter subject is not a valid subset of the interest subjects

Check subject is correct.

### no message being received on stream

eg:

```python
    psub.fetch(100, timeout=None)
```

Will return then it has 100 messages, or times out.
In the case there is no timeout, so it won't return until there are 100 messages in the stream.

### no previous revisions for a kv store

By default the [history of buckets is set to 1](https://docs.nats.io/using-nats/developer/develop_jetstream/kv#getting-the-history-for-a-key), meaning that only the latest value/operation is stored. Can be changed on creation.

### limits

the current observed bound of a single replicated stream is about 200k msgs/s (depending on hardware and network of course), so given the 1 mil msgs/s throughput requirement, there could be ~5 streams behind that partitioning mapping

On the publish side, using subject mapping partitioning would make it transparent for published messages to get routed to physical streams behind the scenes (see https://docs.nats.io/nats-concepts/subject_mapping#deterministic-subject-token-partitioning) as the number of subjects increase over time. On the consumption side, there a couple options.

right now im thinking i might configure N leaf nodes behind an NLB to handle client connections, as well as stream mirroring and distribution to consumers. That way, the cluster nodes responsible for writes arent additionally burdened with network mesh activity and forwarding. that might be overthinking it though

To get that 1M/s throughput you’re going to need to use more than one stream (and then spread them around your cluster using placement tags) since I don’t think doing batching of messages at the client is for your use case. So you can do account-level Core NATS subject mapping to insert a partition number and assign a stream/partition. But you have the added complication of the client just to ‘it’s own subject’ and now that you have the data split into partitions the client would have to search for it’s messages on all the partitions which obviously won’t scale.
I think in your use case I would simply do the partitioning at your application level. Meaning you store the number of partitions in a KV bucket (or hard code a large enough number of partitions), you agree on any kind of consistent hashing to get a partition number given a subject (i.e. hash to a value and modulo by the number of partitions). If you’re publishing you can insert the partition token in the subject and more importantly if you want to get the messages for a particular subject the client app can calculate the partition for it and use that to identify a single stream on which to create it’s consumer.

In 2.10 you can do subject transforms such as adding a partition token within the stream itself. Which is all you need if you just need to scale the consumers, but it doesn’t help scale writes. In order to reach a sustained 1M/s throughput if you want replication you will have to use more than one stream because then you can spread them out over the nodes in the cluster.

Given lax constraint on ordering across subjects, my thought was utilizing the cross-region stream sourcing pattern. Multiple streams accepts writes, but sourcing across (if need be)

cluster-local subject mapping + cluster-specific streams + sourcing

I do have the thought of trying to expose inserting a partition number at the client level
Ah yes the globally distributed eventually consistent stream

## Consistency

We don’t have read after write consistency nor do we have point in time consistent  multi key reads (I have a design that will work) (ed
We are adding some native support for lists and maps - still these complex multi key or ranged operations are quite expensive so you would want to minimise their use today
Oh interesting, when you say there’s no read after write consistency do you mean across multiple keys?
As based on this answer I was under the impression that compare and set (ie: read after write) was possible, at least for a single key.
CAS is different, its not implemented as a client read but rather server managed
However even after a CAS you cant expect to read the new value and get it - you can never expect to read after write and get what you wrote
with CAS the server writes or doesnt and if it does you get the revision as per the leader - but replicas could still give old info when reading
Ah gotcha thanks for clarifying how CAS works.
I’m wondering though, if you can’t read your writes then how is JetStream linearizable as mentioned in the above GitHub discussion?
Storage is linearised but obviously there is a syncing between nodes going on. They sync to the raft log and then replay into the stream
When there is lag between these 2 steps or when 1 replica is unhealthy or whatever then Get() can still be served from that lagged replica.
It’s only Get() that’s affected really


### Connecting to the leader

[JetSteam: New API that returns new *nats.Conn connected to Stream's Leader
#1407](https://github.com/nats-io/nats.go/issues/1407)

but - . One typically wouldn't want to drop and re-establish a connection when a leader changes.

True, it'd be optimal. Leaders will most commonly change during a rolling upgrade, and clients may reconnect to other servers after a network partition.  That said, you could use the administrative APIs to find the server with the leader and initially connect there. However, unless there's some extreme edge case there, the added complexity/effort there wouldn't likely pay off imo. 

What's driving your use case here?  Low latency, minimize cluster traffic, etc? Low latency


## NATS as an event store

- OCC per-stream or per-subject for concurrent appends, and for consistency with the application's read view from the beginning of the transaction.
- Loading current state - can fetch latest version of each subject efficiently, using indexed subjects.
- Better latency than Kafka
- More fine-grained [retention policies](https://docs.nats.io/nats-concepts/jetstream/streams#retentionpolicy) that allow up to N messages per subject to be kept vs Kafka which guarantees at least one.

See [Using Nats Jetstream as an event store #3772](https://github.com/nats-io/nats-server/discussions/3772)

## vs Kafka

A single Kafka partition is comparable to a NATS stream, as it is the unit of total ordering and replication.
[Subject mapping](https://docs.nats.io/nats-concepts/subject_mapping#deterministic-subject-token-partitioning) in NATS can be used to emulate a multi-partition subject space.
