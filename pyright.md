# pyright

pyright is Microsoft's Python type-checker, available as an extension in VSCode and a CLI tool. It has active support and deployment, is fast, and in strict mode detects a lot of issues other type-checkers miss.

## typeCheckingMode

pyright.typeCheckingMode can be:

* `off` = all type-checking rules are disabled, but Python syntax and semantic errors are still reported
* `basic` = can be used to ease into type checking on existing code-bases. Doesn't check for some things that mypy does, like [incompatible overrides](https://mypy.readthedocs.io/en/stable/common_issues.html#incompatible-overrides).
* `strict` = recommended starting point for new code-bases. Will error when type hints are missing from functions. Finds a lot of things mypy doesn't.

See [configOptions.ts](https://github.com/microsoft/pyright/blob/978baa47a55f056523174a00c11f3301a27e7062/server/src/common/configOptions.ts#L257) for the specific rules turned on and their level (eg: warning/error) for each mode.

In strict mode, individual rules can be disabled on a per file basis (see [#601](https://github.com/microsoft/pyright/issues/601)), eg:

```
# pyright: reportMissingTypeStubs=false
```

## Configuration

A *pyrightconfig.json* file in the root configures settings for the project. This is recommended so that everyone working on the project uses the same settings.

VSCode *settings.json* configures the default rules.

Pyright applies rules settings in the following order:

1. Default rule settings
1. Individual overrides in the pyrightconfig.json file
1. Strict (for all or for specific subdirectories)
1. File-level comments

Example *settings.json* for Pylance, using basic mode and enabling additional rules:

```json
  "python.languageServer": "Pylance",
  "python.analysis.typeCheckingMode": "basic",
  "python.analysis.diagnosticSeverityOverrides": {
    "reportIncompatibleMethodOverride": "error"
  }
```

See [Configuration](https://github.com/microsoft/pyright/blob/master/docs/configuration.md)

### Source code in sub-directories

By default, Pyright/Pylance adds the root directory of the workspace to the search path. It also adds `src/` if it's present, since it's a common convention.

You can add additional subdirectories to the search path by modifying `python.analysis.extraPaths` in `.vscode/settings.json`, eg: to add `./awesome_app/` to the search path ([ref](https://github.com/microsoft/pylance-release/issues/68#issuecomment-655072032)):

```json
{
    "python.pythonPath": "/Users/tekumara/.virtualenvs/myapp/bin/python",
    "python.analysis.extraPaths": [
        "awesome_app"
    ]
}
```

## Understanding Type Inference

See [Understanding Type Inference](https://github.com/microsoft/pyright/blob/master/docs/type-inference.md)

## Type Stubs

When pyright is run in strict mode and type stubs are missing, modules will generate a `reportMissingTypeStubs` error.

This can be fixed by generating type stubs which by default are stored in `typings/`, eg:

```
pyright --createstub botocore
```

See [Type Stub Files](https://github.com/microsoft/pyright/blob/master/docs/type-stubs.md)

## Import Resolution

Pyright [locates .pyi stubs in several locations](https://github.com/microsoft/pyright/blob/master/docs/import-resolution.md) including typeshed stubs it vendors, your project workspace, and *lib/site-packages*. To find *lib/site-packages* pyright needs to run inside your virtualenv, or have the `venv` and `venvPath` configured in *pyrightconfig.json*.

When Pyright can't find a `reportMissingImports` error is raised.

Source `.py` files can be used for resolution:

> If the pyright.useLibraryCodeForTypes is set to true (or the --lib command-line argument was specified), try to resolve using the library implementation (“.py” file). Some “.py” files may contain partial or complete type annotations. Pyright will use type annotations that are provided and do its best to infer any missing type information. If you are using Pyright, pyright.useLibraryCodeForTypes is false by default. If you are using Pylance, it is true.

I recommend enabling this. It will avoid issues like:

```
  12:32 - error: "client" is not a known member of module (reportGeneralTypeIssues)
  12:26 - error: Type of "client" is unknown (reportUnknownMemberType)
```
