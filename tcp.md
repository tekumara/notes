# tcp (quotes from others - WIP)

TCP does not guarantee reliable communication

TCP guarantees that if the receiver's app receives byte n, then bytes 1..n were sent (in that order) by the sender's app.

A post hoc guarantee. That’s it.

Unless, of course, your definition of reliability is stream integrity

In that case, sure

TCP's philosophy is not centered around message passing but is centered on connections

Yes, you are correct, the RFC defines reliability in terms of stream integrity and adds a conditional(*) to "guarantee" liveness

But I argue that unless you look deeper, the term reliable  motivates engineers to believe in guarantees TCP does not provide 


Isn’t that how reliability is defined? What am I missing? According to the RFC 793:

Section 1. Introduction:

TCP is intended to provide a reliable communications path between pairs of processes executing on hosts communicating via an internet protocol.

TCP is a connection-oriented, end-to-end reliable protocol designed to fit into a layered hierarchy which supports multi-network applications. The TCP provides for reliable inter-process communication between pairs of processes in host computers attached to distinct but interconnected computer communication networks.

Later …

Section 1.5. Overview:

The TCP is able to recover from data that is damaged, lost, duplicated, or delivered out of order by the Internet communication system. It achieves this by assigning a sequence number to each octet transmitted, and requiring a positive acknowledgment (ACK) from the receiving TCP. If the ACK is not received within a timeout interval, the data is retransmitted. At the receiver, the sequence numbers are used to correctly order segments, replace missing segments, and eliminate duplicate segments.

—-

I’m not arguing your main point, which I think is that one should design protocols around some higher level abstraction (whatever that is).

Hmmm ... but the RFC explicitly claims that it's reliable provided peers are connected. That is the foundation on which TCP makes its claims of reliability.

Partition implies (at least to me) that the connection is lost. ie., partitioning breaks TCP connectivity. TCP will attempt retransmissions but cannot recover if no route exists to the peer. 

I can only assume it's this that you are claiming, applications using TCP must implement higher-level retry, failover, or session resumption if they want resilience to network partitions. I thought this was obvious from the RFC.

Anyway, thanks for replying, all good.

Guaranteeing FIFO between nodes, especially one that's relatively fast in most circumstances, should not be underestimated in terms of implementation difficulty or application utility.   That said, I personally dislike the resulting conn mgmt and am excited for tech such as Homa

--
## Connection (sync) vs Message passing (async)


The simplicity of connection-based coordination and supervision is a big reason for the popularity of Sync RPC like gRPC.

But in the age of agentic apps, with long-running agents and tools, Sync just doesn’t cut it.

You can’t hold a connection forever

A tale of reliability: Sync RPC vs Async RPC

Sync RPC relies on a tcp connection for supervision. Connection failure? Caller retries.

Async RPC? No connection. No baked in supervision.

Knowing when to retry shifts: From connection-level to protocol-level

Whether sync or async, eventually a caller waits for the callee's completion. The caller suspends

Soft Suspend

The caller is both logically and physically present

It remains "in memory"

Hard Suspend

The caller is logically but not physically present

It resides "on disk"

Without exception, in distributed applications, a soft suspend is a liability

## Message passing

Message Passing is the ability to send messages without knowing if/how they'll be received.

Message Passing is agnostic to the underlying protocol in this case; It doesn't rely on the "reliability" features provided by TCP like ordering, de-duplication, etc.

Such a system could then work over both UDP or TCP, ignoring fragmentation. Consensus algs, for example, do this

Protocols like QUIC, VSR, Raft, etc. then build upon it to achieve a certain communication goal.

Other apps/protocols like HTTP3 can be built on those as well

