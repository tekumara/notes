# redis queues

## rsmq

Uses sorted set. Must poll for new messages.

### [sendMessage](https://github.com/smrchy/rsmq/blob/5c507c2ae97145fbdef7369da52dc69b105e0cc6/_src/index.ts#L527)

add message id with timestamp as score to sorted set (zadd)
add message to hash (hset)

```
key = queuename
uid = unique msg id
ZADD key,ts+delay, uid
HSET  key:Q, uid, message
HINCRBY key:Q, totalsent
```

uid is the time from the redis server base36 encoded + some randomness

- [javascript](https://github.com/smrchy/rsmq/blob/5c507c2ae97145fbdef7369da52dc69b105e0cc6/_src/index.ts#L151)
- [async python](https://github.com/federicotdn/aiorsmq/blob/ef66353a617932403382676313a39baef83dc185/aiorsmq/compat.py#L69)
- [sync python](https://github.com/mlasevich/PyRSMQ/blob/3cef17f73230dc82578953349e26000d7e9a4249/src/rsmq/cmd/utils.py#L72)
- [rust](https://github.com/DavidBM/rsmq-async-rs/blob/0fb83e9220bcd0225610326ce13e66f00fc901eb/src/functions.rs#L466)

### [receiveMessage](https://github.com/smrchy/rsmq/blob/5c507c2ae97145fbdef7369da52dc69b105e0cc6/_src/index.ts#L389)

Takes earliest message, then updates it with ts + vt

Returns `None` if no messages.

```

KEYS[1]: the zset key (aka queuename)
KEYS[2]: the current time in ms
KEYS[3]: the new calculated time when the vt runs out

# get first member < ts
msg = ZRANGEBYSCORE KEYS[1], -inf, KEYS[2], LIMIT, 0, 1

# msg[1] = id

# update ts
ZADD KEYS[1], KEYS[3], msg[1]

HINCRBY # increment totalrecv
HGET    # get body
HINCRBY # increment rc
HSET/HGET   # fr

returns:
msg[1]
mbody
rc
fr

```

### deleteMessage

Once done processing.

## [rmq](https://github.com/adjust/rmq)

Uses list. No polling but requires an second unacked list and a cleaner.

[publish](https://github.com/adjust/rmq/blob/2c434d4682b82179a15e2e79f08ff5c1b926acfe/queue.go#L110) - lpush
[consume](https://github.com/adjust/rmq/blob/2c434d4682b82179a15e2e79f08ff5c1b926acfe/queue.go#L226) - rpoplpush readyKey unackedKey

[cleaner](https://github.com/adjust/rmq/blob/2c434d4682b82179a15e2e79f08ff5c1b926acfe/cleaner.go#L20) moves unacked messages (aka deliveries) back to main queue for [connections](https://github.com/adjust/rmq/blob/2c434d4682b82179a15e2e79f08ff5c1b926acfe/connection.go#L46) that have no recent heartbeat.
