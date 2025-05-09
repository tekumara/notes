# Python Install Ubuntu

## Ubuntu versions

Ubuntu distros contain python 2.7 and the following python 3 versions:

| version                   | python 3 |
| ------------------------- | -------- |
| Ubuntu 24.04 LTS (noble)  | 3.12     |
| Ubuntu 22.04 LTS (jammy)  | 3.10     |
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

This will create a `python3` executable at _/usr/bin/python3_. `python` will not be on the path. Ubuntu packages explicitly depend on python3 or python2. If you require `python` pointing at /usr/bin/python3, install [python-is-python3](https://launchpad.net/ubuntu/focal/+package/python-is-python3):

```
sudo apt-get install python-is-python3
```

This creates the symlink /usr/bin/python -> python3.

### Installing a newer version via the package manager

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

## Dist packages

The debian python package contains a [modified version of site.py](https://github.com/deadsnakes/python3.9/blob/ubuntu/focal/debian/patches/distutils-install-layout.diff#L270) which uses the dist-packages rather than site-packages subdirectory. This means _/usr/lib/python3/dist-packages_ appears on `sys.path`. _python3-\*_ deb packages will be installed into _/usr/lib/python3/dist-packages_. The `python3-distutils` debian package also points at dist-packages rather than site-packages.

Virtulenvs won't have _/usr/lib/python3/dist-packages_ on `sys.path`

References:

- [the site module](https://docs.python.org/3/library/site.html)

## Install pip directly

```
# install pip directly, rather than installing the deb package which depends on and installs the distro's
# older python3 package
# use sudo to make sure it is installed into dist-packages ie: /usr/local/lib/python3.7/dist-packages/
curl -s https://bootstrap.pypa.io/get-pip.py | sudo -H /usr/bin/python3.7
```

pip will install system packages into _/usr/local/lib/python3.X/dist-packages_ when run as root, 
and user packages into _~/.local/lib/python3.X/site-packages_ where X depends on the version of the python interpreter being run. Entrypoints will be created in the adjacent _bin/_ directory and reference the python3.X interpreter. When run as root using ie: `sudo pip` system packages will be installed.

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

## Installing multiple python versions

You can also install multiple python versions from the deadsnakes repo and have them live side by side.

eg: to install python 3.7 after having already installed a later version:

```
sudo apt-get install -y --no-install-recommends python3.7 python3.7-dev python3.7-venv
```

To create a virtualenv using python 3.7:

```
virtualenv -p /usr/bin/python3.7 .venv
```
