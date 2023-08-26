# versioning, conventional commits, release notes

## versioning

- Live at head, rolling releases (arch linux, brew), apis - see [Software Engineering at Google (Flamingo Book)](https://abseil.io/resources/swe-book/html/ch21.html#live_at_head)
- [Semver](https://semver.org/)
- Trade-offs with version constraints
  - tighter = more stable, less frequent updates. Favoured by deployed applications.
  - looser = more compatible, more frequent updates. Favoured by libraries.
  - alternatively use a lock file and update regularly to break this tradeoff.
- Definitions of compatible version for major version zero:
  - [Semver](https://semver.org/#spec-item-4): Major version zero (0.y.z) is for initial development. Anything MAY change at any time. The public API SHOULD NOT be considered stable.
  - [Cargo semver](https://doc.rust-lang.org/cargo/reference/resolver.html#semver-compatibility): Versions are considered compatible if their left-most non-zero major/minor/patch component is the same.
- [ZeroVer](https://0ver.org/) and when to move to v1
- Other versioning systems: [CalVer](https://calver.org/), [Sentimental versioning](http://sentimentalversioning.org/)

## conventional commits

[conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) are good for

- categorising release notes
- automatically bumping the version based on commits since last version

## release notes generators

- [.github/release.yml](https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes) built into Github, no GHA required. Creates release notes categorised by label
- [release-drafter](https://github.com/release-drafter/release-drafter) labels PRs based on [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) , and creates a draft Github release with release notes from PRs and suggests the next semver version. Commits without PRs are ignored.
- [release-please](https://github.com/googleapis/release-please) creates a PR with a CHANGELOG.md from prior commits grouped by [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/), and bumps to the next semver version. On merge creates a Github Release with release notes.
