# rust-analyzer

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
