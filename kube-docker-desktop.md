# kube docker desktop

Docker Desktop bundled Kubernetes. To enable it, Docker Desktop -> Preferences -> Kubernetes -> Check `Enable Kubernetes`.

By default, `docker` commands don't show kubernetes containers. To enable visibility, Docker Desktop -> Preferences -> Kubernetes -> Check `Show system containers (advanced)` -> Apply & Restart.

`docker stats` will now show kubernetes container stats

## RBAC

Docker desktop installs a ClusterRoleBinding that grants cluster-admin to all service accounts in the kube-system namespace, including the default service account. It allows tiller to be installed without creating a service account, see [#3694](https://github.com/docker/for-mac/issues/3694). It's arguably not best practice.

To inspect the binding: `kubectl describe clusterrolebinding docker-for-desktop-binding`

More about [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

## Install metrics server

The metrics server for CPU/memory monitoring isn't installed out-of-the-box. To install:

```shell
kubectl apply -f $(curl -s https://api.github.com/repos/kubernetes-sigs/metrics-server/releases/latest | jq '.assets[0].browser_download_url')
```

Because self-signed certificates are used out of the box, you need to enable insecure TLS by starting metrics-server with the *--kubelet-insecure-tls* arg:

```shell
kubectl patch deployment metrics-server -n kube-system --type json -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/0", "value":"--kubelet-insecure-tls"}]' 
```

Otherwise metrics won't be collected and the logs will show the error: *Unable to authenticate the request due to an error: x509: certificate signed by unknown authority*

## Troubleshooting

If you see the following when connecting to a local Docker Desktop cluster: 

```shell
$ kubectl get deployments
Unable to connect to the server: EOF
```

Turn it on and off again: Docker Desktop -> Preferences -> Kubernetes -> Uncheck `Enable Kubernetes`, apply, then recheck.

To view etcd logs

```shell
kubectl --context docker-desktop --namespace kube-system logs -f etcd-docker-desktop
```
