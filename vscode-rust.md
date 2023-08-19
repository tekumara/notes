# vscode rust

## Test lens

rust-analyzer will provide code lenses above tests to run/debug them.
Environment variables can be set for Test and Debug launches, via the `rust-analyzer.runnables.extraEnv` setting, see [setting runnable environment variables](https://rust-analyzer.github.io/manual.html#setting-runnable-environment-variables).

## Test Explorer

See [swellaby.vscode-rust-test-adapter](https://marketplace.visualstudio.com/items?itemName=swellaby.vscode-rust-test-adapter) which depends on [hbenl.vscode-test-explorer](https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-test-explorer) which depends on [ms-vscode.test-adapter-converter](https://marketplace.visualstudio.com/items?itemName=ms-vscode.test-adapter-converter) to convert the legacy test explorer to the new native pane by setting `testExplorer.useNativeTesting: true`.

swellaby.vscode-rust-test-adapter [does not support debugging](https://github.com/swellaby/vscode-rust-test-adapter/issues/16).

May [eventually be replaced by rust-analyzer](https://github.com/swellaby/vscode-rust-test-adapter/issues/202).

## Debugger

Use `?` for expressions. Expressions can't include function calls.
