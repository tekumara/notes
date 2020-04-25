# kube docker desktop

Docker desktop bundles Kubernetes with RBAC.

## Install the metrics server

```
kubectl apply -f $(curl -s https://api.github.com/repos/kubernetes-sigs/metrics-server/releases/latest | jq '.assets[0].browser_download_url')
```
Because self-signed certificates are used out of the box, you need to enable insecure TLS by starting metrics-server with the `--kubelet-insecure-tls` arg:
```
kubectl patch deployment metrics-server -n kube-system --type json -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/0", "value":"--kubelet-insecure-tls"}]' 
```
Otherwise metrics won't be collected and the logs will show the error *Unable to authenticate the request due to an error: x509: certificate signed by unknown authority*

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
