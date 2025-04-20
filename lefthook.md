# lefthook

yaml anchors can be used to reuse commands across hooks ([example](https://github.com/evilmartians/lefthook/issues/911#issuecomment-2579565352)).

## vs pre-commit

- parallel hooks ([example](https://github.com/evilmartians/lefthook/issues/113#issuecomment-2558043917))
- golang so no python deps installed into virtualenv
- custom hooks not tied to git

When there are lots of files for a command they are [chunked and run sequentially](https://github.com/evilmartians/lefthook/issues/471#issuecomment-1722863317) but pre-commit can run chunks in parallel. Although for linters that are internally parallelised (like ruff) this is not necessary. See also the [run docs](https://lefthook.dev/configuration/run.html#:~:text=If%20your%20list%20of%20files%20is%20quite%20long%2C%20lefthook%20splits%20your%20files%20list%20to%20fit%20in%20the%20limit%20and%20runs%20few%20commands%20sequentially.).

## [files templates](https://lefthook.dev/configuration/run.html)

`{all_files}` = all files tracked by git. Does not include untracked files.
`{staged_files}` = staged files.

These are independent of the hook, ie: `{staged_files}` can be used in a pre-push hook.

If a files template is not present in the run command then no files will be passed and it will run as is.

[`glob`](https://lefthook.dev/configuration/glob.html) can be used to filter the set of files passed in the files template.
If nothing matches the glob the job will be skipped, even if it doesn't use a files template.
If no glob is present the job will be skipped if there are no staged files (pre-commit) or push files (pre-push).

The `--all-files` command line arg will override these templates with all files tracked by git, that match the glob filters if any.
The `--force` command line arg will run jobs even if skipped because no files match.

## Example

Runs the readonly commands (pyright and test) in parallel.

```yaml
#   Refer for explanation to following link:
#   https://lefthook.dev/configuration/
#

output:
  - summary # Print summary block (successful and failed steps)
  - empty_summary # Print summary heading when there are no steps to run
  - failure # Print failed steps printing
  - skips # Print "skip" (i.e. no files matched)

pre-push:
  jobs:
    - name: lint
      group:
        jobs:
          - name: ruff check
            glob: "*.py"
            run: uv run ruff check --fix --force-exclude {push_files}

          - name: ruff format
            glob: "*.py"
            run: uv run ruff format {push_files}

    - name: verify
      group:
        parallel: true
        jobs:
          - name: pyright
            run: node_modules/.bin/pyright

          - name: test
            run: uv run pytest
            tags:
              - test
```

## Troubleshooting

### No config files with names ["lefthook" ".lefthook"] have been found in

config is located relative to .git/ so make sure you have .git/ in the current dir

### error getting files

```
│  pyright (skip) error getting files: exit status 128
│  > git diff --name-only HEAD 4b825dc642cb6eb9a060e54bf8d69288fbee4904
│    fatal: ambiguous argument 'HEAD': unknown revision or path not in the working tree.
│    Use '--' to separate paths from revisions, like this:
│    'git <command> [<revision>...] -- [<file>...]'
```

caused by having no commits. Add commits or use `--force` to run the hooks anyway.

### no matching push files

```
lefthook run pre-push --all-files
╭──────────────────────────────────────╮
│ 🥊 lefthook v1.11.10  hook: pre-push │
╰──────────────────────────────────────╯
│  ruff (skip) no matching push files
│  ruff-format (skip) no matching push files
│  pyright (skip) no matching push files
│  test (skip) no matching push files

  ────────────────────────────────────
```

no files to check, this is expected if there are no commits to push.
use `--force` to run the hooks anyway, eg: `lefthook run pre-push --all-files --force`
