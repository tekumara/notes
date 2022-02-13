# python loops

If you modify the list you are looping (or enumerating) through whilst looping, you'll end up [skipping the next element](https://docs.python.org/3/reference/compound_stmts.html#the-for-statement):

> There is a subtlety when the sequence is being modified by the loop (this can only occur for mutable sequences, e.g. lists). An internal counter is used to keep track of which item is used next, and this is incremented on each iteration. When this counter has reached the length of the sequence the loop terminates. This means that if the suite deletes the current (or a previous) item from the sequence, the next item will be skipped (since it gets the index of the current item which has already been treated).

Try this snippet to see the behaviour:

```
l = [100, 200, 300, 400]
for index, e in enumerate(l):
    print(f"{index}: {e}")
    if index == 1:
        _ = l.pop(index)
```

If that's not what you want you can use a slice in the loop.
