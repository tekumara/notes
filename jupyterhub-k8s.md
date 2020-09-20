# jupyterhub k8s

Zero to JupyterHub Kubernetes (z2jh) uses [these helm charts](https://github.com/jupyterhub/zero-to-jupyterhub-k8s)

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

Login via http://localhost. By default you'll be able to specify any username, and the password is ignored.

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

- [user-placeholder](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/reference.html#scheduling-userplaceholder) a placeholder container used to avoid the startup time of a new node.

Users pod will be created with the name `jupyter-username`. First the jupyterhub/k8s-network-tools image is started as an init container with name `block-cloud-metadata`.It [adds an iptables rule](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/commit/81c26138cbb6cf50c893b492391302dc8bcce180) to block access to the EC2 instance metadata endpoint (like [this](https://aws.amazon.com/premiumsupport/knowledge-center/ecs-container-ec2-metadata/)). Then the default [jupyterhub/k8s-singleuser-sample](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/tree/master/images/singleuser-sample) image runs. This can be configured to be a [custom image](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/user-environment.html#choose-and-use-an-existing-docker-image). The pod has a PersistentVolumeClaim.

## Customization

config.yaml is used for customization, see the [Customization Guide](https://zero-to-jupyterhub.readthedocs.io/en/latest/customizing/index.html) and [Configuration Reference](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference/reference.html)

## Troubleshooting

`0/1 nodes are available: 1 Insufficient memory.`

Add more memory to your cluster (when using Docker for Mac, increase that beyond 2GB).
