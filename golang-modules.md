# golang modules

To run a main package inside a go module:

```
go run git.sr.ht/~emersion/gqlclient/cmd/gqlclientgen@latest
```

If the `@latest` suffix is not provided, the go.mod file in the current directory will be used to determine the version of the module and it's dependencies.

To upgrade to the latest go modules:

```
go get -u ./...
go mod tidy
```

NB: this doesn't always upgrade everything in requires in go.mod

To see dependency graph:

```
go mod graph
```

## Troubleshooting

### missing go.sum entry for module providing package

run `go mod tidy`
