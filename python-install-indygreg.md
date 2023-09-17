# python install indygreg

eg: on Amazon linux x86

```
yum install -y tar gzip
arch=$(uname -m)
curl -fsSLO "https://github.com/indygreg/python-build-standalone/releases/download/20230826/cpython-3.10.13+20230826-${arch}-unknown-linux-gnu-install_only.tar.gz"
tar --strip-components=1 -C /usr/local -xvf *.tar.gz
export PATH=/usr/local/bin:$PATH
```

`install_only` is the most performant build, but doesn't have pgo on aarch64, see [#104](https://github.com/indygreg/python-build-standalone/issues/104#issuecomment-1053110325).

## Compiler

For aarch64 builds, because the [GHA runners aren't arm64](https://github.com/indygreg/python-build-standalone/issues/104#issuecomment-1014053951), the python binaries were cross-compiled with `aarch64-linux-gnu-gcc`, eg:

```
$ python3 -m sysconfig | grep -E '^\s+(CC|CPP|CXX|LDSHARED|CFLAGS|CPPFLAGS|LDFLAGS)\b'
        CC = "/usr/bin/aarch64-linux-gnu-gcc"
        CFLAGS = "-Wno-unused-result -Wsign-compare -DNDEBUG -g -fwrapv -O3 -Wall -fPIC -I/tools/deps/include -I/tools/deps/include/ncursesw -I/tools/deps/libedit/include"
        CPPFLAGS = "-I. -I./Include -fPIC -I/tools/deps/include -I/tools/deps/include/ncursesw -I/tools/deps/libedit/include"
        CXX = "c++"
        LDFLAGS = "-L/tools/deps/lib -Wl,--exclude-libs,ALL -L/tools/deps/libedit/lib"
        LDSHARED = "/usr/bin/aarch64-linux-gnu-gcc -shared -L/tools/deps/lib -Wl,--exclude-libs,ALL -L/tools/deps/libedit/lib"
```

Whereas for x64_84 they were compiled using clang:

```
$ python3 -m sysconfig | grep -E '^\s+(CC|CPP|CXX|LDSHARED|CFLAGS|CPPFLAGS|LDFLAGS)\b'
        CC = "clang -pthread"
        CFLAGS = "-Wno-unused-result -Wsign-compare -Wunreachable-code -DNDEBUG -g -fwrapv -O3 -Wall -fPIC -I/tools/deps/include -I/tools/deps/include/ncursesw -I/tools/deps/libedit/include"
        CPPFLAGS = "-I. -I./Include -fPIC -I/tools/deps/include -I/tools/deps/include/ncursesw -I/tools/deps/libedit/include"
        CXX = "clang++ -pthread"
        LDFLAGS = "-L/tools/deps/lib -Wl,--exclude-libs,ALL -L/tools/deps/libedit/lib"
        LDSHARED = "clang -pthread -shared -L/tools/deps/lib -Wl,--exclude-libs,ALL -L/tools/deps/libedit/lib"
```

## Troubleshooting

### Unsupported compiler -- at least C++11 support is needed

Because aarch64 builds were built with _/usr/bin/aarch64-linux-gnu-gcc_ (see above) we run into the [problem outlined here](https://github.com/nmslib/hnswlib/issues/505#issuecomment-1713585753) when trying to use the binaries on Amazon Linux.
