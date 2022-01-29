# traefik

## Traefik dashboard

The traefik dashboard is defined as a ingressroute crd:

```
kubectl get ingressroutes.traefik.containo.us -n kube-system
```

The traefik dashboard is enabled on port 9000, to access:

```
kubectl -n kube-system port-forward $traefik-pod-name 9000:9000
curl http://localhost:9000/dashboard/
```

## Traefik Kubernetes support

[Traefik 2.5](https://github.com/traefik/traefik/commit/29908098e47f0458b5d5f50a59fe3583f63874c7) introduced support for the `networking.k8s.io/v1` api, introduced in Kubernetes 1.19 (see [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)). Prior versions support the older extensions/v1beta1 and networking.k8s.io/v1beta1 [apis](https://kubernetes.io/docs/reference/using-api/deprecation-guide/#ingress-v122).

To check the traefik version (including helm chart version):

```
kubectl get pod -l app.kubernetes.io/name=traefik -n kube-system -o yaml
```

## gRPC

gRPC uses HTTPS by default which requires setting up certs. Alternatively, Traefik can use h2c (essentially HTTP/2 but without TLS) to communicate with a GRPC backend in cleartext. Add the `traefik.ingress.kubernetes.io/service.serversscheme: h2c` annotation to your **Service** object.

See [gRPC Examples](https://doc.traefik.io/traefik/user-guides/grpc/).

## Troubleshooting

### No router for kubernetes ingress

Traefik won't create a router if the service has no endpoints. If this is the case you'll see `Skipping service: no endpoints found` in the traefik pod logs.

Remove any annotations and try again.

### 500 Internal Service Error

Enable the DEBUG [log level](https://doc.traefik.io/traefik/observability/logs/) (eg: `--log.level=DEBUG`) for more info.
