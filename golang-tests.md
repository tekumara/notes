# golang tests

Run tests for all packages recursively in subdirectories of the current dir

```
go test -v ./...
```

## Troubleshooting

## not in GOROOT

Example:

```
go test -v cmd/entrypoints
package cmd/entrypoints is not in GOROOT (/usr/local/Cellar/go/1.16.4/libexec/src/cmd/entrypoints)
```

Instead:

```
go test -v ./cmd/entrypoints
```

## no test files

`go test` won't run test files with tags, eg:

```
// +build integration
```

Instead used `go test -tags=integration`
