# python requirements

## requirements.txt

A requirements.txt has the advantage that its hash or timestamp can be used as a cache key. setup.py can also, but may change for reasons unrelated to dependencies changing (eg: if the version is hard-coded in setup.py and bumped).

The disadvantage is it needs to be specified in MANIFEST.in so it gets packaged into source distributions.

Also [GitHub Insights - dependencies does not parse setup.py](https://github.com/isaacs/github/issues/1846).

Black will format dependencies in setup.py into a single line, which will cause conflicts on that line when dependabot goes to update multiple dependencies at once.

## requirements.txt vs setup.py

Requirements.txt are recommended for applications (and should contain pinned versions), setup.py is recommended for libraries. Rule of thumb: requirements.txt should contain only ==, while setup.py should be liberal and use anything except ==.

- [setup.py vs requirements.txt](https://caremad.io/posts/2013/07/setup-vs-requirement/)

## Specifying git repos

eg:

```
awesome_lib @ git+ssh://git@github.com/tekumara/awesome-lib.git
```

or on a branch:

```
awesome_lib @ git+ssh://git@github.com/tekumara/awesome-lib.git@feature1
```

or using http:

```
awesome_lib @ git+https://github.com/tekumara/awesome-lib.git@feature1
```

or locally:

```
my_package @ file:///absolute/path/my_package
```

NB: if you have already the package, delete it first so pip will detect the missing and install the version from the branch

See also [PEP 508 – Dependency specification for Python Software Packages](https://peps.python.org/pep-0508/)

## Compatible release versions

The [compatible release clause](https://peps.python.org/pep-0440/#compatible-release) `~= X.Y.Z` is roughly equivalent to `>= X.Y.Z`, `== X.Y.*`

`V.*` matches any version with the prefix `V.`
