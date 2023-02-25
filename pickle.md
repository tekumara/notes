# pickle

To debug a failing unpickle, look at the disassembly:

```python
import pickletools

pickletools.dis(picked_bytes)
```

If you get `AttributeError` you could try mocking out the missing attributes and seeing how far you can get with the unpickling.
