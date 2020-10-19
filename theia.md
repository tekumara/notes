# theia

## Usage

Using the docker container with python plugin:

```
docker run -it --init -p 3000:3000 -v "$(pwd):/home/project:cached" theiaide/theia-python:latest
```

Run the latest master version:

```
git@github.com:eclipse-theia/theia.git
yarn start:browser
```

The above works with node v12.18.3, npm 6.14.6, yarn 1.22.10. The master version doesn't always contain the latest plugins.

Theia will start on [localhost:3000](http://localhost:3000) by default.

## State

Theia stores state in _~/.theia/_ including logs, workspace state, and user installed extensions.

## Plugins and Extensions

Theia can be extended with plugins which run in an isolated environment. They can be added at [build or runtime](https://eclipsesource.com/blogs/2019/10/17/how-to-add-extensions-and-plugins-to-eclipse-theia/). The [plugin api](https://eclipsesource.com/blogs/2020/05/04/how-to-create-develop-an-eclipse-theia-ide-plugin/) mirrors the vscode extension api which along with [@theia/plugin-ext-vscode](https://github.com/eclipse-theia/theia/blob/master/packages/plugin-ext-vscode/README.md) makes it possible to install and run vscode extensions.

Theia also offers an [extension API](https://eclipsesource.com/blogs/2019/10/10/eclipse-theia-extensions-vs-plugins-vs-che-theia-plugins/) for extensions which can only be included at build time and need deep un-isolated access to the core.

Built-in (aka build time) plugins exist in the _plugins/_ directory. In the Extensions View UI they appear under "Built-in". They can be specified in _package.json_ under the `theiaPlugins` key and yarn will download and extract them. Or built-in plugins can be manually downloaded and extracted into _plugins/_.

Plugins can also be added at runtime via the Extensions View. Runtime-added plugins appear under "Installed" and are downloaded and stored in _~/.theia/extensions_. Alternatively you can use the command `Plugin: Deploy Plugin by Id` and enter the id, eg: `vscode:extension/ms-python.python`, to download from the Open VSX registry. Plugins can also be manually installed by downloading and extracting them into _~/.theia/extensions_.

## Registry vs Marketplace

The VS Code Marketplace [TOS](http://aka.ms/VSMarketplace-TOU) prohibit use of marketplace plugins in non-Microsoft VS Code:

> Marketplace Offerings are intended for use only with Visual Studio Products and Services and you may only install and use Marketplace Offerings with Visual Studio Products and Services.

The [Open VSX Registry](http://open-vsx.org/) is an open-source registry for VS code extensions. Since many of the VS Code marketplace extensions are available open-source, it builds and publishes these for use in in Theia and other non-Microsoft VS code offerings.

## Python Plugins

Theia ships with the "Python Language Basics" (`vscode.python`) [built-in](https://github.com/theia-ide/vscode-builtin-extensions). This only provides syntax highlighting, and no language server (for "go to definition") or tests.

`ms-python.python` can be installed from the [open vsx registry](https://open-vsx.org/extension/ms-python/python). It usually has a slightly older version than the [official vs code marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.python).

## Features missing compared to VS Code

- [Show breadcrumbs](https://github.com/eclipse-theia/theia/pull/6371)

## References

[eclipse-theia/theia](https://github.com/eclipse-theia/theia)
[theia python docker image](https://github.com/theia-ide/theia-apps/blob/master/theia-python-docker/latest.package.json)
