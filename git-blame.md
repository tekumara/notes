# git blame

While git blame primarily works on a single file, the `-C` option enables copy/move detection of lines.

ie: if a line was moved or copied from another file, the blame output will point to the commit and the original file that changed the line, rather than the commit that performed the copy/move.

eg: blame each line in the test_fetch_pandas_all function in the tests/test_cursor.py file, showing the commit for the original file in which the line was last changed:

```
git blame -C -L ':test_fetch_pandas_all' tests/test_cursor.py
```

`git blame -C -C -C` is even more aggressive in its search.

NB: `git log -C -L` works on whole file copies/renames, not individual lines, so is not as useful here.
