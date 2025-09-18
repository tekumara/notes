# git blame

While git blame primarily works on a single file, the `-C` option enables copy/move detection of lines.

ie: if a line was moved or copied from another file, the blame output will point to the commit and the original file that changed the line, rather than the commit that performed the copy/move.

eg: blame each line in the `test_fetch_pandas_all` function in the _tests/test_cursor.py_ file, showing the commit for the **original** file in which the line was **last changed**:

```
git blame -C -L ':test_fetch_pandas_all' tests/test_cursor.py
```

or for specific lines

```
git blame -C -L 58,59 infra/helm/app/values.yaml
```

`git blame -C -C -C` is even more aggressive in its search.

## history of changes to a file

To see the history of changes to a file across multiple commits, starting with the most recent commit in which a specific line was changed:

```
git log -C -L58,59:infra/helm/app/values.yaml
```

`--follow` follow renames.
`-C` detect copies as well as renames.
