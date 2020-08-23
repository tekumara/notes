# make troubleshooting

## Debug

Show debug

```
make --debug=v install
```

## Missing separator

Make sure the target line begins with a tab.

## make build errors with cat build.sh > build

When I run `make build` on my macOS laptop it gets right to the end and then errors with:

```
cat build.sh >build
/bin/sh: build: Is a directory
make: *** [build] Error 1
```

This is because the `build` target has no recipe, and since there's a build.sh file, make runs [a weird SCCS built-in rule](https://stackoverflow.com/questions/43264686/why-does-calling-make-with-a-shell-script-target-create-an-executable-file).

`.PHONY: build` will fix this. Alternatively, add a recipe for the `build` target, or rename `build.sh`

## undefined variable

eg:

```
awk '/^##.*$/,/^[~\/\.a-zA-Z_-]+:/' $(MAKEFILE_LIST)
```

`Makefile:17: warning: undefined variable /'` - need to use `$$` instead of `$`
