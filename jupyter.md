# jupyter

Install
```
pip install jupyter
```

List kernels
```
jupyter kernelspec list
```

The default `Python3` kernel will use the current virtualenv:
```
Available kernels:
  python3          /Users/tekumara/.virtualenvs/my-venv/share/jupyter/kernels/python3
```  

Start jupyter, serving from the current directory
```
jupyter notebook
```

Create a kernel called `venv-wide` 
```
python -m ipykernel install --sys-prefix --name=venv-wide
```
This creates kernel files inside the virtualenv, ie: in `~/.virtualenvs/my-venv/share/jupyter/kernels/venv-wide`.

Create a user kernel called `user-wide`
```
python -m ipykernel install --user --name=user-wide
```
This creates a user kernel file in `~/Library/Jupyter/kernels/user-wide/` that uses the currently active virtualenv.

Remove kernel `torch-start`
```
jupyter kernelspec uninstall myenv
```