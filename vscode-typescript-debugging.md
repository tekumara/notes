# vscode typescript debugging

Run/debug existing tasks by adding a launch configuration and selecting the task from the dropbox.

To create a launch config for a specific files open the ts file in the editor and press F5.

Breakpoint bindings will be a hollow circle until you start the node process.

## Mocha test explorer

VS Code doesn't have a built in test explorer for js/ts. For mocha tests there is the [Mocha Test Explorer](https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-mocha-test-adapter).

By default it looks for for test files in `test/**/*.js`. To support typescript add the following settings to _.vscode/settings.json_ or _package.json_ and restart:

```json
{
  "mochaExplorer.files": "out/test/**/*.js",
  "mochaExplorer.require": "source-map-support/register",
  "mochaExplorer.watch": "out/**/*.js"
}
```

To view logs of Mocha Test Explorer set:

```json
  "mochaExplorer.logpanel": true
```
