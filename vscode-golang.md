# vscode golang

## Troubleshooting

> Error loading workspace: You are outside of a module and outside of $GOPATH/src. If you are using modules, please open your editor to a directory in your module. If you believe this warning is incorrect, please file an issue: https://github.com/golang/go/issues/new.

This happens on repos where `go.mod` is not it root. Open vscode in the directory with go.mod, if it is a single-module repo.

For multi-module repos, use [go workspaces](https://github.com/golang/tools/blob/master/gopls/doc/workspace.md), eg:

```shell
# create go.work file
go work init

# add modules from directories module1/ and module2/
go work use module1 module2
```
