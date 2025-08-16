# rate limiting

## adaptive retires

Retries

- Jitter is good
- Retries can introduce tipping point failures
- Using a token bucket avoids this failure mode
- Backoff isn’t very effective in open systems

[AWS re:Invent 2024 - Try again: The tools and techniques behind resilient systems (ARC403)](https://www.youtube.com/watch?v=rvHd4Y76-fs)

## concurrency control

This makes a good argument that concurrency control is better than rate limiting, because it creates backpressure when latency increases (eg: due to server overload).

["Stop Rate Limiting! Capacity Management Done Right" by Jon Moore](https://www.youtube.com/watch?v=m64SWl9bfvk)
