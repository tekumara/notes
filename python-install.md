# Python Install

## Ubuntu versions

Ubuntu distros contain python 2.7 and the following python 3 versions:

| version                   | python 3 |
| ------------------------- | -------- |
| Ubuntu 20.04 LTS (focal)  | 3.8      |
| Ubuntu 18.04 LTS (bionic) | 3.6      |
| Ubuntu 17.10 (artful)     | 3.6      |
| Ubuntu 17.04 (zesty)      | 3.5      |
| Ubuntu 16.10 (yakkety)    | 3.5      |
| Ubuntu 16.04 LTS (xenial) | 3.5      |

## Ubuntu

To install the version of python 3 provided by the distro:

```
sudo apt-get update
sudo apt-get install -y python3 python3-dev python3-venv
```

Use [pyenv](pyenv.md) to install version newer than the default provided by the distro.

### Installing a newer version via the package manager (not recommended)

The Ubuntu package manager (apt) owns and manages the _/usr/bin_ and _/usr/lib_ dirs. apt will install the default (and usually outdated) version of python3 into _/usr/bin_ and point the _/usr/bin/python3_ symlink at it. Python packages installed via apt go into _/usr/lib/python3/dist-packages_ with wheels built for the default python version, and entry point binaries that use the _/usr/bin/python3_ symlink (ie: the default version). Do not change this symlink because it will lead to an incompatibility between the wheels, the default python interpreter, and packages installed by apt.

To install a later version, eg: the latest python 3.8 on an older ubuntu distro:

```
# install add-apt-repository
sudo apt-get install -y software-properties-common

# add deadsnakes ppa because it has the latest minor versions
sudo add-apt-repository ppa:deadsnakes/ppa

sudo apt-get install -y python3.8 python3.8-dev python3.8-venv
```

This will create a `/usr/bin/python3.8` interpreter. `/usr/bin/python3` will still point to the distro's default version of python 3.

Create a symlink in _/usr/local/bin_ which will take precedence on the path:

```
sudo ln -s /usr/bin/python3.8 /usr/local/bin/python3
# update hash table of paths
hash -r
```

You can now create virtualenvs (which include pip): `python3 -m venv`

**Caveat**: _/usr/lib/python3/dist-packages_ will be on the PYTHONPATH.

deadsnake/deb python packages contain a [modified version of site.py](https://github.com/deadsnakes/python3.7/blob/4dc651768517acccad5f5081fff2de3e4d5900cd/debian/patches/distutils-install-layout.diff#L243) which adds _/usr/lib/python3/dist-packages_ to PYTHONPATH. Any `python3-*` deb packages will install into _/usr/lib/python3/dist-packages_ and will appear on the PYTHONPATH of this version. To have a completely isolated version of python, install from source, eg: like [python-build](https://github.com/pyenv/pyenv/tree/master/plugins/python-build) or [docker-library/python](https://github.com/docker-library/python).

## Python builds

Python can be built with [profile guided optimizations (PGO)](https://github.com/deadsnakes/python3.7#profile-guided-optimization) by using the `--enable-optimizations` flag. This increases the build time but improves runtime performance. The [profiling workloads can be configured](https://github.com/docker-library/python/issues/160#issuecomment-509426916).

To see what args were used to build the interpreter:

```
import sysconfig; sysconfig.get_config_var('CONFIG_ARGS')
```

The default ubuntu python packages don't have `--enable-optimizations`. The deadsnakes ppa packages and the python docker images do.

`--enable-shared` builds a shared library (eg: libpython3.6m.so.1.0) that can be dynamically linked by programs that embed python. This is enabled in the ubuntu packages (distro default & deadsnakes ppa) and the official docker image.

## Install pip directly

```
# install pip directly, rather than installing the deb package which depends on and installs the distro's
# older python3 package
# use sudo to make sure it is installed into dist-packages ie: /usr/local/lib/python3.7/dist-packages/
curl -s https://bootstrap.pypa.io/get-pip.py | sudo -H /usr/bin/python3.7
```

pip will install system packages into _/usr/local/lib/python3.X/dist-packages_ and user packages into _~/.local/lib/python3.X/site-packages_ where X depends on the version of the python interpreter being run. Entrypoints will be created in the adjacent _bin/_ directory and reference the python3.X interpreter. When run as root using ie: `sudo pip` system packages will be installed.

Beware: _/usr/local/bin_ is a shared directory and can have entrypoints from different python versions.

To run a module (eg: `pip`) using a specific python version: `/usr/lib/python3.7 -m pip`

## Install pip via the pip package

NB: This is not recommended. For most use-case, use the approach above, virtualenvs or pipx.

Install pip3 (which installs python3):

```
sudo apt-get install -y python3-pip
```

This installs the pip package into _/usr/lib/python3/dist-packages_ and the `pip3` entry point binary at _/usr/bin/pip3_. The `pip3` binary uses the _/usr/bin/python3_ interpreter.

The `python3-pip` version of pip is outdated (ie: 9.0.1), if you want to install a newer version for a specific python interpreter:

```
sudo /usr/local/bin/python3 -m pip install --upgrade pip
```

This will install the latest version into _/usr/local/lib/python3.X/dist-packages_ and _/usr/local/bin/pip_ and _/usr/local/bin/pip3_ using the _/usr/local/bin/python3_ interpreter.

To install pip, which depends on python 2:

```
sudo apt-get install python-pip
sudo pip install virtualenv
```
