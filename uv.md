# uv

## Tools

Tools installed into _~/Library/Application Support/uv/tools_ and added to _~/.local/bin_.

`uvx` = `uv tool run`

## Lock files

When uv.lock is generated from pyproject.toml it stores pyproject.toml dependencies in `package.*` keys eg:

```toml
[package.metadata]
requires-dist = [
    { name = "build", marker = "extra == 'dev'", specifier = "~=1.0" },
    { name = "dirty-equals", marker = "extra == 'dev'" },
 ...
]
```

If this don't match pyproject.toml the lock file is considered out of date. Updating the lock file, via `uv lock` or `uv sync` or `uv run` will make a _minimal_ update to the lock file, ie: packages will be adjusted to be within constraints that have changed, and the `package.*` keys updated. Packages will not be bumped to the latest version. That must be explicitly requested via `uv lock --upgrade` or `uv sync --upgrade`.
