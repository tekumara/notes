# Git Ignore Strategies

## Overview

The `.gitignore` file prevents new files from being added to version control. However, if a file is already tracked `.gitignore` will have no effect on it.

To ignore local working tree changes to files that have are tracked, use the `skip-worktree` bit.

## skip-worktree

The `skip-worktree` bit tells Git to skip checking a file out and ignore any changes made to the file in the working tree. When this bit is set:

- If the file isn't present in the working tree, it won't be created on checkout
- If the file has changed in either the working tree or the repository, these changes will be ignored

This feature is used by [sparse checkout](https://git-scm.com/docs/git-sparse-checkout#_internalssparse_checkout) to work on a subset of files in a repository.

### Examples

To ignore changes to files (e.g., all files in notebooks/ directory)

```bash
git update-index --skip-worktree notebooks/*
```

To stop ignoring changes:

```bash
git update-index --no-skip-worktree notebooks/*
```

If you try to force add a file with `skip-worktree` enabled, you'll see this message:

```bash
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

## Alternative: assume-unchanged

An alternative approach is to set the `assume-unchanged` bit on files. However, this serves a different purpose and some key differences:

- `assume-unchanged`: Indicates the file will never change and is meant for performance optimization (Git avoids checking the file for changes)
- `skip-worktree`: Used for files that will change, but those changes should be ignored

skip-worktree is usually better. It tries much harder to preserve local changes in the working tree. With the `assume-unchanged` bit, local changes can be more easily lost during Git operations like merges or rebases.

### Further Reading

For a detailed comparison, see

- [Git - Difference Between 'assume-unchanged' and 'skip-worktree'](https://stackoverflow.com/questions/13630849/git-difference-between-assume-unchanged-and-skip-worktree)
- [git assume-unchanged vs skip-worktree](https://web.archive.org/web/20200604104042/http://fallengamer.livejournal.com/93321.html)

## Inspection

To see which bits are set use `git ls-files -v`:

- `h` = assume-unchanged
- `S` = skip-work-tree
