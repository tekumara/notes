# jupyterhub k8s

Zero to JupyterHub Kubernetes uses the [z2jh helm charts](https://github.com/jupyterhub/zero-to-jupyterhub-k8s)

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
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
```

If using helm 2:

```bash
RELEASE=jhub
NAMESPACE=jhub

helm upgrade \
  --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --version=0.9.0 \
  --values config.yaml
```

If using helm 3:

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

See [Setting up JupyterHub](https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-jupyterhub/setup-jupyterhub.html)

Login via http://localhost. By default you'll be able to specify any username, and the password is ignored.

## Troubleshooting

0/1 nodes are available: 1 Insufficient memory.

Add more memory to your cluster (when using Docker for Mac, increase that beyond 2GB).

## Components

Deployment

- hub: [jupyterhub](https://github.com/jupyterhub/jupyterhub) see [Hub pod](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/tools.html#hub-pod)
- proxy: [configurable-http-proxy](https://github.com/jupyterhub/configurable-http-proxy) see [Proxy pod](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/tools.html#proxy-pod)
- user-scheduler: kube-scheduler assigns new pods to nodes

DaemonSet

- continuous-image-puller: pulls images on new nodes so they are warm, see [Pulling images before users arrive](https://zero-to-jupyterhub.readthedocs.io/en/latest/administrator/optimization.html#pulling-images-before-users-arrive)

Service

- hub
- proxy-api
- proxy-public

StatefulSet

- [user-placeholder](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/reference.html#scheduling-userplaceholder) used to keep nodes warm for real users

Users pod will be created with the name `jupyter-username`. The _jupyterhub/k8s-network-tools_ image is started as an init container and then the _jupyterhub/k8s-singleuser-sample_ image runs. The pods have a PersistentVolumeClaim.

## Customization

config.yaml is used for customization, see the [Customization Guide](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/index.html) and [Configuration Reference](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/reference.html)
