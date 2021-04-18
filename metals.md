# Metals

Bloop is a build server that can runs build requests for clients via the build server protocol (BSP). See [What is Bloop](https://scalacenter.github.io/bloop/docs/what-is-bloop).

Metals is a BSP client that integrates with build servers. It is also a language server and integrates with IDEs and editors via the [language server protocol (LSP)](https://microsoft.github.io/language-server-protocol/) to provide code completion, go to definition, find references and more.

![BSP and LSP](https://www.scala-lang.org/resources/img/blog/bsp.png)

sbt also [implements the BSP](https://www.scala-lang.org/blog/2020/10/27/bsp-in-sbt.html). And so Metals can integrate with Bloop or [sbt](https://scalameta.org/metals/blog/2020/11/06/sbt-BSP-support.html).

## Running main

Bloop doesn't support native linking or running the main file. It will error in the following ways:

* `Metals: run main class in the current file` throws a BuildTargetContainsNoMainException
* Clicking the run code lens throws "scala.meta.internal.metals.MetalsBspException: BSP connection failed in the attempt to get: DebugSessionAddress. Unsupported platform: Native"

Switch from Bloop to sbt using `Metals: Switch build server`. If sbt isn't recognised then first generate a _.bsp/sbt.json_ config file using `Metals: Attempt to generate bsp config for build tool`.
