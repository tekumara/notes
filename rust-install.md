# Rust Install

On Ubuntu and Mac OS X, [install using rustup](https://www.rust-lang.org/tools/install):

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# To configure your current shell run
source $HOME/.cargo/env
```

To upgrade:

```
rustup update
```

To list available tags:

```
rustup target list
```

Add the apple x86 target:

```
rustup target add x86_64-apple-darwin
```

## Docker

```
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN source "$HOME/.cargo/env" && pip install -e .
```

## Windows

```
scoop install rustup
```

You will need [Microsoft C++ Build tools (MSVC)](ms-build-tools.md) or otherwise switch to the [GNU toolchain](https://stackoverflow.com/a/64121601/149412).
