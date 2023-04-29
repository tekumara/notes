# esbuild

## vscode

`npm run esbuild-base -- --sourcemap --watch` cannot be used as a pre-launch task because it doesn't complete. The spinner forever rotates and so the launch configuration doesn't start. See [#180641](https://github.com/microsoft/vscode/issues/180641)

Use esbuild without watch instead.
