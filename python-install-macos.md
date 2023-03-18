# Python Install macOS

## xcode

The macOS xcode command line tools install:

- `python` executable at _/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/Resources/Python.app/Contents/MacOS/Python_
- no `python2` or `python3` executable
- system site-packages at _/Library/Python/3.9/site-packages_
- _/usr/bin/pip3_ binary
- The following versions of pip, all with shebang `#!/Library/Developer/CommandLineTools/usr/bin/python3`:
  - _/usr/local/bin/pip3_
  - _/usr/local/bin/pip3.9_
  - _/usr/local/bin/pip3.10_ (incorrectly pointing at python3 which is 3.9)

pip will install packages in the user site-packages dir above and executable scripts (eg: `virtualenv`) into _~/Library/Python/3.9/bin_. This script dir is not on PATH.

## brew

Brew supports multiple versions of python, eg: `python@3.9`, `python@3.10`, `python@3.11`. They install:

- `python3.Y` executable at _/opt/homebrew/bin/python3.Y_
- brew site-packages at _$(brew --prefix)/lib/pythonX.Y/site-packages_
- pip at _/opt/homebrew/bin/pip3.Y_

pip will install packages in the brew site-packages dir above and executable scripts (eg: `virtualenv`) into _$(brew --prefix)/bin_.

See also [Homebrew and Python](https://docs.brew.sh/Homebrew-and-Python).

### unversioned links

brew python does not version pip installed executable scripts. They use the version of python they were installed/upgraded with, eg: if you ran `pip3.10 install --upgrade pip` most recently, then _/opt/homebrew/bin/pip3_ would run with python 3.10.

_/opt/homebrew/bin/python3_ is an unversioned link installed by `python@3.11`.

## user site-packages sharing

xcode and brew-install python 3.9 both include the user site-packages dir, ie: _~/Library/Python/3.9/lib/python/site-packages_, on PYTHONPATH (ahead of their system user-packages dir).

Because xcode's pip3 will install packages into the user site-packages dir, they will appear when using brew's pip3.9 or python3.9.

## pyenv system

pyenv's `system` version will fall-through to the first version of the shim (eg: python3, pip, pip3 etc.) on the path. This is usually the brew-installed python.
