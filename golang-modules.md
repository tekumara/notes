# golang modules

To run a main package inside a go module:

```
go run git.sr.ht/~emersion/gqlclient/cmd/gqlclientgen@latest
```

If the `@latest` suffix is not provided, the go.mod file in the current directory will be used to determine the version of the module and it's dependencies.

## Troubleshooting

### missing go.sum entry for module providing package

run `go mod tidy`
