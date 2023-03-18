# pre-commit

## Why?

* Automatically run hooks during git commit or push. Particularly useful when you don't have CI.
* Run hooks only on the changed files
* Has some nice formatters for python, eg: [double-quote-string-fixer](https://github.com/pre-commit/pre-commit-hooks#double-quote-string-fixer) to convert double to single quotes.

## Cache

Non-local [non-system](https://pre-commit.com/#system) hooks are downloaded and cached in *~/.cache/pre-commit/repo**. They run in their own isolated virtualenv managed by pre-commit. `additional_dependencies` for local hooks will also be stored in the cache.  

## Languages

System language hooks do no setup and do not run in a pre-commit virtualenv. Script hooks are the same but run relative to the root of the hook repo (if local, this will be the current dir).

Python language hooks must point to a repository that can be installed using `pip install .`

## Gotchas

If you need something to run inside your project's virtualenv (eg: pylint, pyright to identify valid imports) then run it as a [local hook](https://pre-commit.com/#repository-local-hooks).

`--all-files` runs against all files in the index and working tree, ie: not untracked files.

## Config

`types: [python]` only run the hook when python files change.
`pass_filenames: false` don't pass file names to the hook entry point. By default, changed file names will be passed in batches. If there are lots of files, your hook entry point will run multiple times.

## Running hooks independently

`pip install pre-commit-hooks` then:

```
double-quote-string-fixer src/*.py tests/*.py setup.py || echo Fixed
requirements-txt-fixer requirements.* || echo Fixed
```

The hooks return an non-zero exit code when they make changes (hence the `|| echo Fixed`).

## Debugging hook install

See [Debug how pre-commit initializes its environment #1508](https://github.com/pre-commit/pre-commit/issues/1508#issuecomment-648874721)
