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

## Ubuntu 18.04+

To install python 3

```
sudo apt-get update
sudo apt-get install python3 python3-dev python3-venv
```

## Python 3.6 on < Ubuntu 17.10

To install python3.6 on Ubuntu 16.04 - 17.04 (more details [here](https://askubuntu.com/questions/865554/how-do-i-install-python-3-6-using-apt-get/865644#865644)):

```
sudo apt-get install python3.6 python3.6-dev
```

This will create a `/usr/bin/python3.6` interpreter. However, `/usr/bin/python3` will still point to `python3.5`. Python 3.5 is pretty baked into Ubuntu, so don't try and remove it.

Install pip3 and virtualenv:

```
sudo apt-get install python3-pip
pip3 install --upgrade pip
sudo pip3 install virtualenv
```

Because `pip3` uses `/usr/bin/python3` it will install packages into the python3.5 packages directory (to see which python interpreter pip3 is using: `pip3 -V`). But that's OK because virtualenv can be made to create python 3.6 envs (see below).

Alternatively, use [[Pyenv]]

## Install pip (python 2) on Ubuntu

```
sudo apt-get install python-pip
sudo pip install virtualenv
```
