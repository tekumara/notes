# pyright

[pyright](https://github.com/microsoft/pyright) is Microsoft's Python type checker (requires node). It has active support and deployment, is fast, and detects a lot of issues other type checkers miss. It improves on the python vscode extension with type-checking and the detection of invalid imports.

[pylance](https://github.com/microsoft/pylance-release) is a VS Code language server extension that bundles pyright and other goodies like auto-imports, code completion and additional stubs (eg: pandas, matplotlib)

## typeCheckingMode

`pyright.typeCheckingMode` (or `python.analysis.typeCheckingMode` for pylance) can be:

- `off` = all type-checking rules are disabled, but Python syntax and semantic errors are still reported and in pylance auto-complete suggestions are made
- `basic` = use when easing into type checking on existing code-bases, or on code-bases that use libraries with poor quality stubs (eg: pandas). Doesn't check for some things that mypy does, like [incompatible overrides](https://mypy.readthedocs.io/en/stable/common_issues.html#incompatible-overrides).
- `strict` = new code-bases with high quality stubs should use this. Will error with `reportUnknownParameterType` when type hints are missing from functions. Finds a lot of things mypy doesn't.

See [configOptions.ts](https://github.com/microsoft/pyright/blob/978baa47a55f056523174a00c11f3301a27e7062/server/src/common/configOptions.ts#L257) for the specific rules turned on and their level (eg: warning/error) for each mode.

In strict mode, individual rules can be disabled on a per file basis via a comment (see [#601](https://github.com/microsoft/pyright/issues/601)), eg:

```
# pyright: reportMissingTypeStubs=false
```

## Configuration

A _pyrightconfig.json_ file in the root configures settings for the project. This is recommended so that everyone working on the project uses the same settings.

VSCode _settings.json_ configures the default rules.

Pyright applies rules settings in the following order:

1. Default rule settings
1. Individual overrides in the pyrightconfig.json file
1. Strict (for all or for specific subdirectories)
1. File-level comments

Example _settings.json_ for Pylance, using basic mode and enabling additional rules:

```json
  "python.languageServer": "Pylance",
  "python.analysis.typeCheckingMode": "basic",
  "python.analysis.diagnosticSeverityOverrides": {
    "reportIncompatibleMethodOverride": "error"
  }
```

- See [Configuration](https://github.com/microsoft/pyright/blob/master/docs/configuration.md) for _pyrightconfig.json_ options
- See [Settings](https://github.com/microsoft/pyright/blob/master/docs/settings.md) for vscode settings

### PyCharm compatibility

To mimic PyCharm as closely as possible, use basic typeCheckingMode and set `"strictDictionaryInference": true` in _pyrightconfig.json_

### Source code in sub-directories (vscode)

By default, Pyright/Pylance adds the root directory of the workspace to the search path. It also adds `src/` if it's present, since it's a common convention.

You can add additional subdirectories to the search path by modifying `python.analysis.extraPaths` in `.vscode/settings.json`, eg: to add `./awesome_app/` to the search path ([ref](https://github.com/microsoft/pylance-release/issues/68#issuecomment-655072032)):

```json
{
  "python.pythonPath": "/Users/tekumara/.virtualenvs/myapp/bin/python",
  "python.analysis.extraPaths": ["awesome_app"]
}
```

## Understanding Type Inference

Lists with mixed types (eg: `[1, "a"]`):

- In basic mode with be inferred as `List[Unknown]` ie: ignored
- If `strictListInference: "true"`, will be inferred as as the union of the elements' types, eg: `List[int | str]`

See [List Expression](https://github.com/microsoft/pyright/blob/master/docs/type-inference.md#list-expressions)

`Unknown` is used whenever a type cannot be inferred. It is a special form of `Any` and so will create blind spots in type checking. Its distinct from `Any` so Pyright can warn when types are not declared when the `reportUnknown*` [diagnostics](https://github.com/microsoft/pyright/blob/master/docs/configuration.md#type-check-diagnostics-settings) are enabled.

For more info see [Understanding Type Inference](https://github.com/microsoft/pyright/blob/master/docs/type-inference.md).

## Import Resolution

Pyright [locates .pyi stubs in several locations](https://github.com/microsoft/pyright/blob/master/docs/import-resolution.md#resolution-order) including typeshed stubs it vendors, your project workspace, and _lib/site-packages_. To find _lib/site-packages_ pyright needs to run inside your virtualenv, or have the `venv` and `venvPath` configured in _pyrightconfig.json_.

### Use library code for types

Many libraries lack stubs. However their `.py` files can contain partial or complete type annotation. To use annotations in `.py` files, and infer any missing types, when stubs are missing:

- specify the `--lib` command-line argument
- set `"python.analysis.useLibraryCodeForTypes": true` for the pyright vscode extension. In Pylance this defaults to true.
- set `"useLibraryCodeForTypes": false` in _pyrightconfig.json_. NB: Setting this to `false` will override Pylance.

`useLibraryCodeForTypes` is a double-edged sword. On the one hand, it can avoid issues like:

```
  12:32 - error: "client" is not a known member of module (reportGeneralTypeIssues)
  12:26 - error: Type of "client" is unknown (reportUnknownMemberType)
```

But on the other hand, the type information is inferred and can be incorrect. Some of these problems can only be fixed by the third party library author, and/or a type stub. Inference from source files can also be slow and can result in a sluggish experience for complex libraries like [tensorflow](https://github.com/microsoft/pyright/issues/1404#issuecomment-765814403).

If you are using Pyright/pylance for type checking, `"useLibraryCodeForTypes": false` is recommended. The feature was added to provide completion suggestions when using Pylance (see [pyright/#945](https://github.com/microsoft/pyright/issues/945#issuecomment-674466348)). However, it will also disable "Go to Definition" behaviour (see [pylance-release/#278](https://github.com/microsoft/pylance-release/issues/278)).

## Missing Type Stubs

When pyright is run in strict mode and type stubs are missing it will generate a `reportMissingTypeStubs` error.

This can be fixed by generating draft type stubs which by default are stored in _typings/_, eg:

```
pyright --createstub botocore
```

These stubs are a first draft intended for type-checking and are meant to be manually improved. `--createstub` emits a comment with the return type for functions if it can be inferred. Whilst these may be incorrect they can reduce the manual work needed (see [#1916](https://github.com/microsoft/pyright/issues/1916)).

`--createstub` differ from `useLibraryCodeForTypes` which is intended to create low-quality type information that's usually insufficient for type checking but may be sufficient for completion suggestions. ([ref](https://github.com/microsoft/pyright/issues/1970#issuecomment-858669967))

Compared to [stubgen](https://mypy.readthedocs.io/en/stable/stubgen.html) from mypy:

- `--createstub` does a better job at inferring function return types
- stubgen does a better job at inferring some function args
- `--createstub` includes docstrings in the generated stubs

Reference:

- See [Type Stub Files](https://github.com/microsoft/pyright/blob/master/docs/type-stubs.md)

NB: `.pyi` stubs in _typings/_ take precedence over the same stubs in the virtualenv.

## Checking a subset of files

pyright can be supplied a set of files on the the command line, in which case it will ignore _pyrightconfig.json_ and use the default configuration. For this reason, when using pyright in a pre-commit hook you probably want to specify `pass_filenames: false`.

## Pylance bundled stubs

Pylance bundles stubs for pandas, matplotlib and [other libraries](https://github.com/microsoft/pyright/issues/861). This stubs are incomplete. If you encounter a type error using these libraries that looks incorrect, first check the open issues on [microsoft/pylance-release](https://github.com/microsoft/pylance-release) before reporting it.

## Exporting symbols from a typed library

Python doesn't have an explicit export keyword. Instead conventions has arisen on how to specify which modules and symbols in a library are its [public interface](https://github.com/microsoft/pyright/blob/main/docs/typed-libraries.md#library-interface). These include the following in in _\_\_init\_\_.py_:

- specifying exported symbols via the `__all__` symbol
- using a redundant module or symbol alias during the import, eg: `from . import box as box`. See [rich #1596](https://github.com/willmcgugan/rich/pull/1596/files).

[pyright 1.1.168](https://github.com/microsoft/pyright/releases/tag/1.1.168) and later errors with `reportPrivateImportUsage` when trying to import symbols that it considers private (ie: haven't be declared as above) from a type stubs or a py.typed library.

For more info see this [comment](https://github.com/microsoft/pyright/issues/2277#issuecomment-937468789).

## Alternatives to pyright

Pyre can't find modules ([#279](https://github.com/facebook/pyre-check/issues/279)) without specifying the `search_path` pointing to site-packages. It's slow (11 secs) and doesn't find any issues out-of-the-box.

Mypy has > 1k open issues.

Pyright strict mode detects the most errors. Issues in pyright are quickly addressed. One drawback is it requires node and doesn't have a pypi distribution [#819](https://github.com/microsoft/pyright/issues/819).
