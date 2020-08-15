# pre-commit

## Why?

* Can automatically run hooks during commit
* Can run hooks only on the changed files
* Has some nice formatters for python, eg: [double-quote-string-fixer](https://github.com/pre-commit/pre-commit-hooks#double-quote-string-fixer) to convert double to single quotes.

## Cache

Non-system hooks are downloaded and cached in *~/.cache/pre-commit/repo**. `additional_dependencies` for local hooks will also be stored here.  

## Gotchas

If you need something to run inside your project's virtualenv (eg: pylint, pyright to identify valid imports) then run it as a local [system hook](https://pre-commit.com/#system).

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
