# jupyter

Install
```
pip install jupyter
```

Start jupyter, serving from the current directory
```
jupyter notebook
```

## Config

See `~/.jupyter/jupyter_notebook_config.py`

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
* mac os: `~/Library/Jupyter/kernels/`
* linux: `~/.local/share/jupyter/kernels`

Virtualenv kernels:
* `~/.virtualenvs/jupyter/share/jupyter/kernels/`

See [Kernelspec](https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernelspecs)

Create a kernel within the active virtualenv called `venv-wide`

```
python -m ipykernel install --sys-prefix --name=venv-wide
```

This creates kernel files inside the virtualenv, ie: in `~/.virtualenvs/my-venv/share/jupyter/kernels/venv-wide`. It uses the currently active virtualenv.

Create a user kernel called `user-wide`

```
python -m ipykernel install --user --name=user-wide
```

This creates a user kernel file in `~/Library/Jupyter/kernels/user-wide/` that uses the currently active virtualenv.

Remove kernel `myenv`

```
jupyter kernelspec uninstall myenv
```
