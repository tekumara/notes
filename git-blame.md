# git blame

While git blame primarily works on a single file, the `-C` option enables copy/move detection

If a line was moved or copied from another file, the blame output will often point to the commit and the original file where the line came from, rather than just the commit where it appeared in the current file.

eg: blame each line in the test_fetch_pandas_all function, showing the commit for the original file in which the line was last changed:

```
git blame -L ':test_fetch_pandas_all' -C  tests/test_cursor.py
```

`git blame -C -C -C` is even more aggressive in its search.
