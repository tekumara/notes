# consistency

> Linearizability: 1 operation, 1 object, and real-time order.
> Serializability: Multi-operation, Multi-object, arbitrary total order.
>
> Qq: is the real-time and arbitrary total order bit right?
>
> Yes
> In practice, any serializable thing you deal with probably won’t diverge too far from a time based ordering, but the strict definition is that the database state is equivalent to any sequential ordering of transactions committed.
> Also be aware that both don’t really put constraints on failed operations or aborted transaction. Majority quorums with read repair is only linearizable if you don’t implement a timeout on failed writes. Serializable transactions can observe massively non-serializable results during execution and that’d fine as long as they are later forced to abort.
