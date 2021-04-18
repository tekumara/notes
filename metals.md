# Metals

Bloop is a build server that can runs build requests for clients via the build server protocol (BSP). See [What is Bloop](https://scalacenter.github.io/bloop/docs/what-is-bloop).

Metals is a BSP client that integrates with build servers. It is also a language server and integrates with IDEs and editors via the [language server protocol (LSP)](https://microsoft.github.io/language-server-protocol/) to provide code completion, go to definition, find references and more.

![BSP and LSP](https://www.scala-lang.org/resources/img/blog/bsp.png)

## Linking and running Scala Native projects

Bloop doesn't support running Scala Native projects. `Metals: run main class in the current file` or clicking the run code lens with throw:

```
Caused by: scala.meta.internal.metals.MetalsBspException: BSP connection failed in the attempt to get: DebugSessionAddress.  Unsupported platform: Native
```

Switch to sbt instead, as follows.

## Using sbt with Metals

sbt also [implements the BSP](https://www.scala-lang.org/blog/2020/10/27/bsp-in-sbt.html) but Metals uses Bloop by default.

To switch to sbt:

1. Generate a _.bsp/sbt.json_ config file using `Metals: Attempt to generate bsp config for build tool`.
1. Switch from Bloop to sbt using `Metals: Switch build server`.

See [sbt BSP support](https://scalameta.org/metals/blog/2020/11/06/sbt-BSP-support.html) for more information (and also a good description of Metals, BSP, LSP)l
