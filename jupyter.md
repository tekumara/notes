# jupyterlab

```
pip install jupyterlab
jupyter-lab
```

## classic jupyter

Install the manifest package which always installs the latest version of jupyter

```
pip install jupyter
```

Start jupyter, serving from the current directory

```
jupyter notebook # calls jupyter-notebook
```

jupyter additionally includes:

- [jupyter_console](https://github.com/jupyter/jupyter_console) a command line terminal, to start: `jupyter console`
- [ipywidgets](https://github.com/jupyter-widgets/ipywidgets) & widgetsnbextension extension for interactive HTML widgets
- entry points for: ipython, jupyter-bundlerextension, jupyter-nbextension, jupyter-serverextension, jupyter-kernel, jupyter-kernelspec

jupyterlab additionally includes:

- jupyterlab
- jupyterlab_server

## Config

See:

- _~/.jupyter/jupyter_notebook_config.py_
- /opt/conda/etc/jupyter/\_

Jupyter will use the user's default shell.

## Kernels

List kernels

```
jupyter kernelspec list
```

The default `Python3` kernel will use the current virtualenv:

```
Available kernels:
  python3          /Users/tekumara/.virtualenvs/my-venv/share/jupyter/kernels/python3
```

User kernels location:

- mac os: `~/Library/Jupyter/kernels/`
- linux: `~/.local/share/jupyter/kernels`

Virtualenv kernels:

- `.venv/share/jupyter/kernels/`

See [Kernelspec](https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernelspecs)

Create a kernel within the active virtualenv called `venv-wide`

```
python -m ipykernel install --sys-prefix --name=venv-wide
```

This creates kernel files inside the virtualenv, ie: in `.venv/share/jupyter/kernels/venv-wide`. It uses the currently active virtualenv.

Create a user kernel called `user-wide`

```
python -m ipykernel install --user --name=user-wide
```

This creates a user kernel file in `~/Library/Jupyter/kernels/user-wide/` that uses the currently active virtualenv.

To create a kernel spec in the active virtual env (ie:`.venv/share/jupyter/kernels/pypy`) pointing at a pypy kernel:

```
venv=/tmp/pypy
uv venv -p pypy@3.10 $venv
uv pip install --directory $venv ipykernel
/tmp/pypy/bin/python -m ipykernel install --prefix=.venv --name 'pypy'
```

Remove kernel `myenv`

```
jupyter kernelspec uninstall myenv
```

See [Installing the IPython kernel](https://ipython.readthedocs.io/en/latest/install/kernel_install.html).

## Extensions

List extensions

```
jupyter serverextension list
jupyter-labextension list
jupyter-nbextension list
jupyter-bundlerextension list
```

## Troubleshooting

> TqdmWarning: IProgress not found

`pip install ipywidgets`
