# jupyter ecosystem

## JupyterLab

JupyterLab gives you:

- Jupyter notebooks
- File explorer
- Launcher for terminals

## Jupyter Kernel Gateway

A HTTP REST and WebSockets proxy to a jupyter kernel.

## Jupyter Notebook Extension to Kernel Gateway (nb2kg)

nb2kg is a Jupyter Notebook server extension that enables the Notebook server to use remote kernels hosted by a Jupyter "Gateway" (i.e., Kernel Gateway or Enterprise Gateway).

nb2kg is part of jupyter notebook server 6+.

## Jupyter Enterprise Gateway

Enterprise Gateway manages the lifecycle of jupyter _kernels_ in a cluster. Kernels run independently of the notebook server (eg: jupyterlab). EG provides authz but not authn.

## JupyterHub

JupyterHub spawns jupyter notebook servers and provides authenticated access to them.
TLJH spawns servers locally, and Z2JH K8s spawns them on kubernetes.

## References

[JupyterHub vs Enterprise Gateway](https://discourse.jupyter.org/t/about-the-enterprise-gateway-category/539/7?u=tekumara)
[On-demand Notebooks with JupyterHub, Jupyter Enterprise Gateway and Kubernetes](https://blog.jupyter.org/on-demand-notebooks-with-jupyterhub-jupyter-enterprise-gateway-and-kubernetes-e8e423695cbf)
