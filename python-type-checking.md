# python type checking

Pyre can't find modules ([#279](https://github.com/facebook/pyre-check/issues/279)) without specifying the `search_path` pointing to site-packages. It's slow (11 secs) and doesn't find any issues out-of-the-box.

Mypy has > 1k open issues.

Pyright strict mode detects the most errors. Issues in pyright are quickly addressed. It runs of node and doesn't have a pypi distribution [#819](https://github.com/microsoft/pyright/issues/819).
