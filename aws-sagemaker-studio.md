# AWS SageMaker Studio

A customised version of jupyterlab v1.2.17 (as of Oct 2020) with panes for git, [experiment tracking](https://docs.aws.amazon.com/sagemaker/latest/dg/gs-studio-end-to-end.html) and endpoints.

Notebooks and terminals (aka image terminals) are started in docker containers and accessed by a kernel gateway. Several docker images are provided eg: Data Science, TensorFlow 2. By default the containers start on a ml.t3.medium.

There is one SageMaker domain per account. A domain can have multiple users, each with their own workspace. Anyone with access to the account can open an user's workspace.

User workspaces are persisted to EFS. They are mounted at _/home/sagemaker-user_

## Studio setup

The system terminal is a command line for Studio itself. Studio runs on Amazon Linux with miniconda python 3.7.7 installed in _/opt/conda/bin/python_

Studio runs in a container with internet egress, which can be disabled when running [Studio in a VPC](https://aws.amazon.com/about-aws/whats-new/2020/10/now-launch-amazon-sagemaker-in-your-amazon-vpc/).

Studio starts Jupyter lab with:

```
/opt/conda/bin/python /opt/conda/bin/jupyter-lab --ip 0.0.0.0 --port 8888                       \
  --NotebookApp.kernel_manager_class=sagemaker_nb2kg.managers.RemoteKernelManager               \
  --NotebookApp.kernel_spec_manager_class=sagemaker_nb2kg.managers.RemoteKernelSpecManager      \
  --NotebookApp.token= --NotebookApp.base_url=/jupyter/default --NotebookApp.allow_origin=*     \
  --debug --no-browser /home/sagemaker-user
```

This delegates kernel management to SageMaker in a fashion [similar to Enterprise Gateway](https://jupyter-enterprise-gateway.readthedocs.io/en/latest/getting-started.html#nb2kg-server-extension).

No access to the ec2 metadata endpoint.

## jupyterlab extensions

- @jupyter-widgets/jupyterlab-manager
- [@jupyterlab/celltags](https://github.com/jupyterlab/jupyterlab-celltags)
- [@jupyterlab/git](https://github.com/jupyterlab/jupyterlab-git)
- @amzn/sagemaker-ui - The primary UI module that ties all the components together for AWS' SageMaker UI JupyterLab plugin
- @amzn/sagemaker-ui-theme-dark-jupyterlab
- [nbdime-jupyterlab](https://github.com/jupyter/nbdime)
- sagemaker-forked-extensions - SageMaker customized jupyterlab extensions for [notebook](https://github.com/jupyterlab/jupyterlab/tree/master/packages/notebook-extension), [console](https://github.com/jupyterlab/jupyterlab/tree/master/packages/console-extension) and - [terminal](https://github.com/jupyterlab/jupyterlab/tree/master/packages/terminal-extension).
- sagemaker_notebooks_extension - A JupyterLab extension to enable SageMaker Notebooks functionality
- sagemaker_session_manager - A JupyterLab extension.
- sagemaker_sharing_extension - A JupyterLab extension to enable sharing of files within SageMaker

Located at _/opt/conda/share/jupyter/lab/extensions_

## jupyter server extensions

- [aws_jupyter_proxy](https://github.com/aws/aws-jupyter-proxy)
- jupyter_server_proxy
- jupyterlab
- jupyterlab_git
- nbdime
- sagemaker_sharing
- sagemaker_nb2kg
- sagemaker_ui_proxy

## Conda packages

- awscli
- aws-jupyter-proxy
- sagemaker-jupyter-server-tools
- sagemaker-nb2kg
- sagemaker-sharing
- sagemaker-ui-proxy (depends on jupyter-server-proxy and jupyter-telemetry )

## Logs

/var/log/studio/nb2kg.log
