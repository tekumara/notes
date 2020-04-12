# jupyter

Install
```
pip install jupyter
```

Create a kernal called `pytorch-start` that uses the currently activate virtualenv
```
python -m ipykernel install --user --name=pytorch-start
```
This creates the user kernel files in `~/Library/Jupyter/kernels/pytorch-start/kernel.json`

Start jupyter, serving from the current directory
```
jupyter notebook
```
