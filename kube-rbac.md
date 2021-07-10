# kubernetes RBAC

A Role always sets permissions within a particular namespace.

A ClusterRole can define permissions on cluster-scoped resources and resources across multiple namespaces.

A RoleBinding or ClusterRoleBinding grants permissions defined in a Role/CusterRole to [subjects](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#referring-to-subjects). Subjects can be groups, users, or a [ServiceAccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/). A service account provides an identity for processes that run in a Pod.

See

- [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
