# rust-analyzer

## Debug with args

Inside the main function use the command `rust-analyzer.newDebugConfig` to generate a debug run config and then modify `args`.

([ref](https://github.com/rust-lang/rust-analyzer/issues/10408))

## Troubleshooting

> file not included in module tree rust-analyzer (unlinked-file)

Can occur when you have a subdirectory that isn't mentioned in the root Cargo.toml.

If the subdirectory contains a Cargo.toml, then you need to add as a workspace in the root Cargo.toml, eg:

```
[workspace]

members = [
    "my-sub-directory",
]
```

Workspaces share the same _Cargo.lock_ file.

> rust-analyzer failed to load workspace: "cargo" "--version" failed: No such file or directory (os error 2)

Try restarting VS Code.
