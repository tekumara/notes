# python dependency groups

A mechanism for storing development package requirements in pyproject.toml files, as an alternative to requirements.txt

Similar to requirements.txt in that:

- they are not published as distinct metadata in any built distribution (unlike `project.optional-dependencies` aka extras in pyproject.toml)
- installation of a dependency group does not imply installation of a package's dependencies or the package itself. Part of their purpose is to support non-package projects.

Groups can include other groups, creating hierarchies.

eg:

```toml
[project]
name = "mypackage"
dependencies = ["required-dependency"]

[project.dependency-group.test]
description = "Dependencies for running tests"
dependencies = ["pytest>=7", "coverage>=6"]

[project.dependency-group.doc]
description = "Documentation building tools"
dependencies = ["sphinx>=5"]

[project.dependency-group.dev]
description = "Full development environment"
dependencies = []
includes = ["test", "doc"]
```

Refs:

- [PEP 735 Rationale](https://peps.python.org/pep-0735/#rationale)
- [PyPA specs page - Dependency Groups](https://packaging.python.org/en/latest/specifications/dependency-groups/)
