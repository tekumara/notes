# python build

Python can be built with [profile guided optimizations (PGO)](https://github.com/deadsnakes/python3.7#profile-guided-optimization) by using the `--enable-optimizations` flag. This increases the build time but improves runtime performance. The [profiling workloads can be configured](https://github.com/docker-library/python/issues/160#issuecomment-509426916).

To see what args were used to build the interpreter:

```
import sysconfig; sysconfig.get_config_var('CONFIG_ARGS')
```

NB: this is loaded from _<sys.prefix>/python3.X/\_sysconfigdata_m_linux_x86_64-linux-gnu.py_

The default ubuntu python packages aren't built with `--enable-optimizations`. The deadsnakes ppa packages and the [python docker images](https://github.com/docker-library/python) do.

## shared library

`--enable-shared` builds a shared library (eg: libpython3.6m.so.1.0) that can be dynamically linked by programs that embed python. This is enabled in the ubuntu packages (distro default & deadsnakes ppa) and the official docker image. The python docker images used `--enable-shared`.

When building a sharded library is it also good to set RPATH so LD_LIBRARY_PATH doesn't need to be updated.

For more info on RPATH see:

- pyenv python-build which [sets the RPATH](https://github.com/pyenv/pyenv/issues/65#issuecomment-30998608)
- [Building Portable Binaries](https://developer.squareup.com/blog/building-portable-binaries/)
- [setting RPATH for python not working](https://stackoverflow.com/questions/43616505/setting-rpath-for-python-not-working)

## python-build

[python-build](https://github.com/pyenv/pyenv/tree/master/plugins/python-build) (part of pyenv) will build python from source.
