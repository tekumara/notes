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

## Install pip

NB: This is not recommended. For most use-case, virtualenvs and pipx are better.

Install pip3 (which installs python3):

```
sudo apt-get install -y python3-pip
```

This installs the pip package into _/usr/lib/python3/dist-packages_ and the `pip3` entry point binary at _/usr/bin/pip3_.
It's a rather old version (ie: 9.0.1) so you'll want to upgrade it.

pip will install install system packages into _/usr/local/lib/python3.X/dist-packages_ and user packages into _~/.local/lib/python3.X/site-packages_ where X depends on the version of the python interpreter being run. When using the `pip3` binary, this is the default interpreter, ie: _/usr/bin/python3_

To use pip with a specific interpreter, run pip as a module:

```
# install into /usr/local/lib/python3.8/dist-packages/
sudo python3.8 -m pip install pipx
```

Or as non-root:

```
# install into ~/.local/lib/python3.8/site-packages
python3.8 -m pip install pipx

# add ~/.local/bin_ to your PATH if its not already
python3.8 -m pipx ensurepath
```

Binaries will be created in the adjacent _bin/_ directory and reference the python3.8 interpreter.

The `python3-pip` version of pip is outdated, if you want to install a newer version for a specific python interpreter:

```
sudo /usr/local/bin/python3 -m pip install --upgrade pip
```

This will install the latest version into _/usr/local/lib/python3.X/dist-packages_ and _/usr/local/bin/pip_ and _/usr/local/bin/pip3_ using the _/usr/local/bin/python3_ interpreter.

To install pip, which depends on python 2:

```
sudo apt-get install python-pip
sudo pip install virtualenv
```
