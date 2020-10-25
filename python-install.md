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
sudo apt-get install python3 python3-dev python3-venv
```

Use [pyenv](pyenv.md) to install version newer than the default provided by the distro.

### Installing a newer version via the package manager (not recommended)

To install a later version, eg: python 3.8 on ubuntu 18.04:

```
sudo apt-get install python3.8 python3.8-dev python3.8-venv
```

This will create a `/usr/bin/python3.8` interpreter. `/usr/bin/python3` will still point to the distro's default version of python 3 (or won't exist if you haven't installed python3). Python packages installed via the python package manager go into _/usr/lib/python3/dist-packages_ with wheels built for the default python version. 

This only works if:

- you directly use _/usr/bin/python3.8_ eg:
  - when creating a virtualenv: `virtualenv --python=/usr/bin/python3.8 venv`
  - as python3 in your shell using `alias python3=/usr/bin/python3.8`
- AND you don't install packages, specifically ones with binaries, globally, eg: `export PIP_REQUIRE_VIRTUALENV=true`

## Updating /usr/bin/python3

Python packages installed via the python package manager go into _/usr/lib/python3/dist-packages_. This includes built wheels specific to the distro's default python version. While it is possible to symlink _/usr/bin/python3_ to a later version (eg: using the alternatives system) it is not recommended because it can break packages in _/usr/lib/python3/dist-packages_.

Use the alternatives system to symlink _/usr/bin/python_ to python3.8:

```
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
```

python3.8 has the higher priority and will be auto chosen. To manually change the selection: `sudo update-alternatives --config python3`

## pip3

`pip3` is installed via `python3-pip` into _/usr/bin/pip3_ and _/usr/lib/python3/dist-packages_. It runs using _/usr/bin/python_ and will install system packages into _/usr/local/lib/python3.X/dist-packages_ and user packages into _~/.local/lib/python3.X/site-packages_ where X depends on which version of python _/usr/bin/python_ points to.

The `python3-pip` version of pip is outdated, so you'll probably want to install a newer version:

```
/usr/bin/pip3 install --upgrade pip
```

This will install the latest version into _/usr/local/lib/python3.X/dist-packages_ and _/usr/local/bin/pip_ and _/usr/local/bin/pip3_.

## Install pip (python 2) on Ubuntu

```
sudo apt-get install python-pip
sudo pip install virtualenv
```
