# uv

## Pypy

```
uv python install pypy@3.10

# create venv in folder pypy_venv
uv venv -p pypy@3.10 pypy_venv
```

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

If these don't match pyproject.toml the lock file is considered out of date. Updating the lock file, via `uv lock` or `uv sync` or `uv run`, will update the `package.*` keys and make a _minimal_ update to the lock file, ie: packages will only change if pyproject.toml has changed, or dependency constraints [now exclude the previous locked version](https://docs.astral.sh/uv/concepts/projects/sync/#upgrading-locked-package-versions).

To bump all packages to the latest version within the version constraints of pyproject.toml use `uv lock --upgrade` or `uv sync --upgrade`.

## uv sync

uv sync will include the `dev` dependency group. Use `--all-groups` for all groups and `--all-extras` for all extras (ie: optional dependencies).

## uv run

Will use the virtualenv of the current project, if any. The virtualenv will be created and updated before invoking the command.
