# kube networking

## Resources

[Service](https://kubernetes.io/docs/concepts/services-networking/) exposes a set of pods via a network address, either internally with the cluster or externally. When a Service object has a selector, the Service controller will maintain an Endpoints object of internal pod IP addresses targeted by the service. See [Defining a Service](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service). To access a service within the cluster use:
- http://service-name (within same namespace)
- http://service-name.namespace
- http://service-name.namespace.svc.cluster.local
- 

A `ClusterIP` type will expose the service internally. A ClusterIP is made routable within the cluster with iptables, and is not routable from outside the cluster. The name of a `ClusterIP` service will resolve to its IP address, and its fully qualified name includes the namespace as a domain.

[`NodePort`](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) and [`LoadBalancer`](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) exposes the service externally via TCP/UDP. Creating a NodePort will open that port on every node in your cluster and route from that port to your service. A `LoadBalancer` will map external IPs to services in the cluster. It is typically used to program an external cloud load balancer.

An [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) resource configures an [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) with a path-based/virtual host routing rule, and optional SSL/TLS termination. It can be used to expose HTTP/S routes from outside the cluster to services within the cluster. It does not expose non-HTTP/S protocols or ports other than 80 and 443. [cert-manager](https://github.com/cert-manager/cert-manager) can be used to automatically provision and renew TLS certs from LetsEncrypt for use in Ingress (among other things).

[Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) control ingress and egress to a pod. A Kubernetes cluster may have partial, full, or no support for network policies. Kubernetes will silently ignore policies that aren’t supported.

A Pod may specify a [containerPort](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#ports). This is informational only. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network.

See also:

- [Connecting Applications with Services](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
- [What is Gateway API? ](https://kubernetes.io/blog/2022/07/13/gateway-api-graduates-to-beta/#what-is-gateway-api)
