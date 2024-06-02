# git sparse checkout

A sparse checkout will skip checking out paths and ignore any changes to the skipped files (independently of .gitignore).

To ignore any changes to notebooks/\*:

```
git update-index --skip-worktree notebooks/*
```

To no longer ignore:

```
git update-index --no-skip-worktree notebooks/*
```

If you try to force add a skipped file you'll see:

```
❯ git add -f notebooks/fakesnow.ipynb
The following paths and/or pathspecs matched paths that exist
outside of your sparse-checkout definition, so will not be
updated in the index:
notebooks/fakesnow.ipynb
hint: If you intend to update such entries, try one of the following:
hint: * Use the --sparse option.
hint: * Disable or modify the sparsity rules.
hint: Disable this message with "git config advice.updateSparsePath false"
```
