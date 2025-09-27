# git ignore

.gitignore prevents new files from being added. If a file is already tracked and committed, .gitignore will have no effect.

To ignore local work tree changes to a file that has been committed, use the `skip-worktree` bit.

## skip-worktree

The skip worktree bit tells git to skip checking a file out, and ignore and changes made to the file in the worktree. If the file isn't present in working tree it won't be created, and if it has changed in the work tree or in the repo these changes will be ignored.

Used by a [sparse checkout](https://git-scm.com/docs/git-sparse-checkout#_internalssparse_checkout) to work on a subset of files.

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

## no assume unchanged

An alternative is to set the `assume-unchanged` bit. This indicates the file will never change, and is meant for performance to avoid checking the file. `skip-worktree` is used for files that will change, but those changes should be ignored. It tries a lot harder to preserve local changes in the working tree. With the `assume-unchanged` bit, local changes can be more easily lost.

See [Git - Difference Between 'assume-unchanged' and 'skip-worktree'](https://stackoverflow.com/questions/13630849/git-difference-between-assume-unchanged-and-skip-worktree).
