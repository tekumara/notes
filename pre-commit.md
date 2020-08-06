# pre-commit

## Why?

* Can automatically run hooks during commit
* Can run hooks only on the changed files
* Has some nice formatters for python, eg: [double-quote-string-fixer](https://github.com/pre-commit/pre-commit-hooks#double-quote-string-fixer) to convert double to single quotes.

## Gotchas

Hooks run in their own isolated virtualenv. If you need something to run inside your project's virtualenv (eg: pylint, pyright to identify valid imports) then run it as a local [system hook](https://pre-commit.com/#system).

pre-commit will automatically download and cache non-local hooks.

## Running hooks independently

`pip install pre-commit-hooks` then:

```
double-quote-string-fixer src/*.py tests/*.py setup.py || echo Fixed
requirements-txt-fixer requirements.* || echo Fixed
```

The hooks return an non-zero exit code when they make changes (hence the `|| echo Fixed`).
