# jupyterhub k8s

Zero to JupyterHub Kubernetes (z2jh) uses [these helm charts](https://github.com/jupyterhub/zero-to-jupyterhub-k8s)

## Overview

JupyterHub consists of:

- multi-user Hub (tornado process + database)
- configurable http proxy (node-http-proxy)
- multiple single-user Jupyter notebook servers (Python/Jupyter/tornado)

<img src="https://jupyterhub.readthedocs.io/en/stable/_images/jhub-fluxogram.jpeg" alt="jupyterhub" width="404" height="303"/>

See [Technical Overview](https://jupyterhub.readthedocs.io/en/stable/index.html)

## Install

Create config.yaml

```bash
cat << EOF > config.yaml
proxy:
  secretToken: "<RANDOM_HEX>"
EOF
sed -i '' "s/<RANDOM_HEX>/"$(openssl rand -hex 32)"/" config.yaml
```

Add the JupyterHub chart repo:

```bash
helm repo add jupyterhub https://jupyterhub.gi  thub.io/helm-chart/
helm repo update
```

Deploy using helm 2:

```bash
RELEASE=jhub
NAMESPACE=jhub

helm upgrade \
  --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --version=0.9.0 \
  --values config.yaml
```

Deploy using helm 3:

```bash
RELEASE=jhub
NAMESPACE=jhub

helm upgrade --cleanup-on-fail \
  --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --create-namespace \
  --version=0.9.0 \
  --values config.yaml
```

For more info see [Setting up JupyterHub](https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-jupyterhub/setup-jupyterhub.html)

Login via [http://localhost](http://localhost). By default, JupyterHub runs with the dummy authenticator (`dummyauthenticator.DummyAuthenticator`) which allows any username and password combination.

## Components

Deployment

- hub: [jupyterhub](https://github.com/jupyterhub/jupyterhub) see [Hub pod](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/tools.html#hub-pod)
- proxy: [configurable-http-proxy](https://github.com/jupyterhub/configurable-http-proxy) see [Proxy pod](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/tools.html#proxy-pod)
- user-scheduler: kube-scheduler assigns new pods to nodes

DaemonSet

- continuous-image-puller: pulls images on new nodes so they are warm, see [Pulling images before users arrive](https://zero-to-jupyterhub.readthedocs.io/en/latest/administrator/optimization.html#pulling-images-before-users-arrive)

Service

- hub:
- proxy-api
- proxy-public

StatefulSet

- [user-placeholder](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/reference.html#scheduling-userplaceholder) a placeholder container used to avoid the startup time of a new node.

## Users pods

User pods run the single user notebook server. They will be created with the name `jupyter-username`. First the jupyterhub/k8s-network-tools image is started as an init container with name `block-cloud-metadata`.It [adds an iptables rule](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/commit/81c26138cbb6cf50c893b492391302dc8bcce180) to block access to the EC2 instance metadata endpoint (like [this](https://aws.amazon.com/premiumsupport/knowledge-center/ecs-container-ec2-metadata/)). Then the default [jupyterhub/k8s-singleuser-sample](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/tree/master/images/singleuser-sample) image runs. This can be configured to be a [custom image](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/user-environment.html#choose-and-use-an-existing-docker-image). The pod has a PersistentVolumeClaim.

By default, Jupyter will open with the classic UI. To use the JupyterLab UI instead, add the following to config.yaml:

```yaml
singleuser:
  defaultUrl: "/lab"
```

User pods with inactivity (ie: no connected browser) for 1 hour will be [culled](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/user-management.html#culling-user-pods).

[Multiple profiles](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/user-environment.html#using-multiple-profiles-to-let-users-select-their-environment) can be created to allow different user pod definitions (eg: CPU/GPU/memory or docker image).

## Storage

JupyterHub will provision storage using the default StorageClass for your cluster. On Docker Desktop, this will be `docker.io/hostpath` ie: a directory on the host. You can specify an alternate StorageClass, see [Customizing User Storage](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/user-storage.html).

To populate users storage see [About user storage and adding files to it](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/user-environment.html#about-user-storage-and-adding-files-to-it) and [Using nbgitpuller to synchronize a folder](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/user-environment.html#using-nbgitpuller-to-synchronize-a-folder).

## Hub database

See [hub.db](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/reference.html#hub-db)

## Authentication

JupyterHub supports a [number of authenticators](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/76dc891a64f770eb38ab4fa8e9accd69110cb688/jupyterhub/files/hub/jupyterhub_config.py#L266) including [jupyterhub/oauthenticator](https://github.com/jupyterhub/oauthenticator), as well as custom authenticators.

## Customization

config.yaml is used for customization, see the [Customization Guide](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/index.html) and [Configuration Reference](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/reference.html)

## Troubleshooting

`0/1 nodes are available: 1 Insufficient memory.`

Add more memory to your cluster (when using Docker for Mac, increase that beyond 2GB).
