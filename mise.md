# mise

## Install tools

Install a tool and add it to `config.toml` and the PATH:

```sh
mise use pipx:aec-cli
```

Install a tool without adding it to `config.toml`, or adding it to PATH:

```sh
mise install pipx:aec-cli
```

Upgrade or install tools in config.toml

```sh
mise upgrade
```

List installed tools:

```sh
mise ls
```

A tool installed without an entry in `config.toml` has no source in the output.

Show latest version of codex

```sh
mise latest codex --minimum-release-age 0
```

mise has a built-in 24 hour release delay. Releases younger that this are ignored. Using `--minimum-release-age 0` overrides this.

Show all versions of codex

```sh
mise ls-remote codex --minimum-release-age 0
```

Download the latest registry (without updating mise)

 ```bash
mise settings registry_floating=true
``` 

## Choose between `[tools]` and `[bootstrap.packages]`

Use `[tools]` for project and development tools. Mise:

- pins their versions by directory or globally
- adds shims and updates `PATH`

Examples include `rust`, `pipx:aec-cli` and `npm:…`.

Use `[bootstrap.packages]` for system-wide packages. Mise installs these once for the whole machine. It does not provide project-specific versions or shims.

## Install apps from DMG files

The `brew-cask:` backend can install app bundles from DMG files without requiring Homebrew. It downloads the DMG, extracts the app and puts it in `/Applications`.

Add the package to `config.toml`:

```toml
[bootstrap.packages]
"brew-cask:firefox" = "latest"
```

Then install it:

```sh
mise bootstrap packages apply
```

Mise gets cask metadata from the Homebrew or tap API at `api/cask/*.json`.

## Choose between a Brewfile and mise

[mise](https://mise.jdx.dev/) provides a unified interface across many registries for installing and upgrading command-line tools. Use mise when you need:

- different versions per project
- a specific version installed globally (ie: not just the latest)
- the same setup across macOS, Linux and Windows
- language runtimes and build tools
- simpler setup scripts because installation and upgrade is declarative via configuration or a single command
- to install binaries github or language specific registries (go, npm, pypi etc.)

mise-installed tools are available in a mise-activated shell.

Use Homebrew instead of mise for:
- foundational tools needed outside a mise-activated shell
- GUI applications and casks
- background services and launch agents
- system libraries, headers and native dependencies
- macOS-specific utilities or integrations
- software absent or poorly supported in mise (Homebrew has a bigger selection)
