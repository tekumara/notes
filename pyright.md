# pyright

## Incompatible overrides

By default pyright (ie: `"pyright.typeCheckingMode": "basic"`) doesn't check for [incompatible overrides like mypy](https://mypy.readthedocs.io/en/stable/common_issues.html#incompatible-overrides).

To enable incompatible overrides:

* pyright: use `"pyright.typeCheckingMode": "strict"` or `"pyright.reportIncompatibleMethodOverride": "true"`
* pylance: use `"python.analysis.typeCheckingMode": "strict"` or

```json
  "python.analysis.typeCheckingMode": "basic",
  "python.analysis.diagnosticSeverityOverrides": {
    "reportIncompatibleMethodOverride": "error"
  }
```

* pyrightconfig.json: use `"reportIncompatibleMethodOverride": true`

## typeCheckingMode

pyright.typeCheckingMode has modes off, basic, and strict. See the rulesets in [Added new pyright.typeCheckingMode setting](https://github.com/microsoft/pyright/commit/fa34df5306a64a19db0e96dcfdb4a621b7ae1c8e)

## Understanding Type Inference

See [Understanding Type Inference](https://github.com/microsoft/pyright/blob/master/docs/type-inference.md)

## Type Stubs

When pyright is run in strict mode and type stubs are missing, modules will generate a `reportMissingTypeStubs` error.

This can be fixed by generating type stubs which by default are stored in `typings/`, eg:

```
pyright --createstub botocore
```

See [Type Stub Files](https://github.com/microsoft/pyright/blob/master/docs/type-stubs.md)

## Use library code to infer types

From [import-resolution.md](https://github.com/microsoft/pyright/blob/5e4cbeca63cd8c56e930921247edece0c0e8e8c5/docs/import-resolution.md):

> If the pyright.useLibraryCodeForTypes is set to true (or the --lib command-line argument was specified), try to resolve using the library implementation (“.py” file). Some “.py” files may contain partial or complete type annotations. Pyright will use type annotations that are provided and do its best to infer any missing type information. If you are using Pyright, pyright.useLibraryCodeForTypes is false by default. If you are using Pylance, it is true.

It is recommended to enable this. It will avoid issues like:

```
  12:32 - error: "client" is not a known member of module (reportGeneralTypeIssues)
  12:26 - error: Type of "client" is unknown (reportUnknownMemberType)
```

## when source code isn't directly in the workspace root directory

By default, Pyright/Pylance adds the root directory of the workspace to the search path. It also adds `src/` if it's present, since it's a common convention.

You can add additional subdirectories to the search path by modifying `python.analysis.extraPaths` in `~/.vscode/settings.json`, eg: to add `./awesome_app/` to the search path:

```json
{
    "python.pythonPath": "/Users/tekumara/.virtualenvs/myapp/bin/python",
    "python.analysis.extraPaths": [
        "awesome_app"
    ]
}
```

([ref](https://github.com/microsoft/pylance-release/issues/68#issuecomment-655072032))