# macOS linker

## dyld and LC_RPATH

`LC_RPATH` is a load command embedded in macOS Mach-O binaries that specifies runtime library search paths.

The behaviour of dyld may also be controlled this environment variables (see `man dyld`):

- `DYLD_LIBRARY_PATH`
- `DYLD_FALLBACK_LIBRARY_PATH`

However if System Integrity Protection (SIPS) is enabled, environment variables are ignored when executing binaries protected by SIP.

See:

- [@rpath what?](https://blog.krzyzanowskim.com/2018/12/05/rpath-what/)
- [Linking and Install Names](https://www.mikeash.com/pyblog/friday-qa-2009-11-06-linking-and-install-names.html)

### Example from Homebrew Python

```
# show all load commands
otool -l /opt/homebrew/Cellar/python@3.11/3.11.14/Frameworks/Python.framework/Versions/3.11/Python | grep -B 1 -A 3 "LC_RPATH"
Load command 14
          cmd LC_RPATH
      cmdsize 32
         path /opt/homebrew/lib (offset 12)
Load command 15
```

This tells the dynamic linker: "When loading libraries, also search in `/opt/homebrew/lib`."

Homebrew Python vs uv Python:

- **Homebrew Python** has `LC_RPATH` pointing to `/opt/homebrew/lib`, so it can find Homebrew libraries automatically.
- **uv Python** has no `LC_RPATH`, so it relies on environment variables or system default paths.

This is why `pyvips` works with Homebrew Python without extra configuration, but may need `DYLD_FALLBACK_LIBRARY_PATH` with uv Python.
