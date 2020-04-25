# kube docker desktop

Docker desktop bundles Kubernetes with RBAC.

## Install the metrics server

```
curl -L https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml > /tmp/components.yaml
```

When metrics-server starts the logs will show the following errors:
```
Unable to authenticate the request due to an error: x509: certificate signed by unknown authority
```
Because self-signed certificates are used, insecure TLS need to be enabled by starting metrics-server with the `--kubelet-insecure-tls` arg:
```
kubectl patch deployment metrics-server -n kube-system --type json -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/0", "value":"--kubelet-insecure-tls"}]' 
```

## Troubleshooting

When trying to connect to a local Docker Desktop cluster: 
```
$ kubectl get deployments
Unable to connect to the server: EOF
```
Turn it on and off again: Docker Desktop -> Preferences -> Kubernetes -> Uncheck `Enable Kubernetes`, apply, then recheck.

Docker desktop etcd logs
```
kubectl --context docker-for-desktop --namespace kube-system logs -f etcd-docker-desktop
```
