# pre-commit

## Why?

- Automatically run hooks during git commit or push. Particularly useful when you don't have CI.
- Run hooks only on changed files of given type
- Don't fail fast, ie: run all hooks independently regardless of failure in previous hooks
- Succinct output - only show output when hooks fail
- Run single hooks in parallel across batches of files
- Installs hooks from github repos
- Has some nice formatters for python, eg: [double-quote-string-fixer](https://github.com/pre-commit/pre-commit-hooks#double-quote-string-fixer) to convert double to single quotes.

## Languages

System language hooks do no setup and do not run in a pre-commit virtualenv. Script hooks are the same but run relative to the root of the hook repo (if local, this will be the current dir).

Python language hooks must point to a repository that can be installed using `pip install .`

## Config

`types: [python]` only run the hook when python files change.
`pass_filenames: false` don't pass file names to the hook entry point. By default, changed file names will be passed in batches. If there are lots of files, your hook entry point will run multiple times in parallel.

`--all-files` runs against all files in the index and working tree, ie: not untracked files.

## Running hooks independently

`pip install pre-commit-hooks` then:

```
double-quote-string-fixer src/*.py tests/*.py setup.py || echo Fixed
requirements-txt-fixer requirements.* || echo Fixed
```

The hooks return an non-zero exit code when they make changes (hence the `|| echo Fixed`).

## Debugging hook install

See [Debug how pre-commit initializes its environment #1508](https://github.com/pre-commit/pre-commit/issues/1508#issuecomment-648874721)

## Cache

Non-local [non-system](https://pre-commit.com/#system) hooks are cloned into their own [temp dir](https://github.com/pre-commit/pre-commit/blob/48f0dc9615488b583b11f2d90bd4a332701c6b6a/pre_commit/store.py#L161) under _~/.cache/pre-commit/repoXXXXXXXX_.

Python hooks run in their own isolated virtualenv managed by pre-commit and created in the `py_env-python3.X` directory in the cache dir. `additional_dependencies` for local hooks will also be stored in the virtualenv. The virtualenv is created using the active version of python at the time the hook is installed. The python version can be [overridden using `language_version`](https://pre-commit.com/#overriding-language-version).

To identify the cache directory for every hook:

```
sqlite3 ~/.cache/pre-commit/db.db 'select * from repos;'
```

Or for just black

```
sqlite3 ~/.cache/pre-commit/db.db "select * from repos where repo like '%black%';"
```

## Issues

pre-commit is tightly coupled to git and requires a git repo to run.
It also isn't designed to run multiple stages, see [run multiple hook stages](https://github.com/pre-commit/pre-commit/issues/3037).

## Gotchas

If you need something to run inside your project's virtualenv (eg: pylint, pyright to identify valid imports) then run it as a [local hook](https://pre-commit.com/#repository-local-hooks).

### running hooks on a repo backed up to Dropbox

pre-push hooks will first move unstaged files to a pre-commit stash and restore them, eg:

```
[WARNING] Unstaged files detected.
[INFO] Stashing unstaged files to /Users/tekumara/.cache/pre-commit/patch1690587194-72601.
typos....................................................................Passed
[INFO] Restored changes from /Users/tekumara/.cache/pre-commit/patch1690587194-72601.
[master 92a70b0] add mount-fsx/md
 1 file changed, 189 insertions(+)
 create mode 100644 mount-fsx.md
```

This causes a weird interaction when the repo is backed up to Dropbox. The stashed files are restored as conflicted copies:

```
❯ gs
# On branch: master  |  +1  |  [*] => $e*
#
➤ Changes not staged for commit
#
#        deleted:  [1] github-releases.md
#        deleted:  [2] typescript.md
➤ Untracked files
#
#      untracked: [3] github-releases (tekumara's conflicted copy 2023-07-29).md
#      untracked: [4] typescript (tekumara's conflicted copy 2023-07-29).md
```

Use pre-commit hooks instead.

### Linter not excluding files

Linters like `typos` can be configured to exclude certain files. For typos, you would add the file patterns to exclude in the `.typos.toml` config file. However, when typos is executed via a pre-commit hook, pre-commit passes the files to check explicitly on the command line. This overrides any exclusions specified in the linter's own config file. If you want to exclude files from `typos` when run via a pre-commit hook, use the `exclude` config key in `.pre-commit-config.yaml` instead.
