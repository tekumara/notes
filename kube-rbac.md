# kubernetes RBAC

A [Role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) always sets permissions within a particular namespace.

A [ClusterRole](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) can define permissions on cluster-scoped resources and resources across multiple namespaces.

A [RoleBinding or ClusterRoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding) grants permissions defined in a Role/CusterRole to [subjects](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#referring-to-subjects). Subjects can be groups, users, or a [ServiceAccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/). A service account provides an identity for processes that run in a Pod.

Kubernetes users and groups are not resources. Instead they are [subjects](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#referring-to-subjects) of a RoleBinding or ClusterRoleBinding, or data in the [aws-auth configmap](aws-eks-auth.md). The aws-auth configmap is used to map AWS IAM roles/users to kubernetes users/groups.

See

- [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Service account

A [ServiceAccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) provides an identity for processes that run in a Pod. Every namespace has a default service account resource called `default`.

Specify a service account for your deployment, eg:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-cool-app
  labels:
    app: my-cool-app
spec:
  selector:
    matchLabels:
      app: my-cool-app
  template:
    metadata:
      labels:
        app: my-cool-app
    spec:
      serviceAccountName: my-cool-app-service-account
```

If you do not provide the serviceAccountName value the deployment will use the `default` ServiceAccount in the namespace.

## Troubleshooting

### attempting to grant RBAC permissions not currently held

Roles cannot be created with more permissions than the subject currently has. Restrict the rules in the Role to a smaller set, or increase the subject's permissions.
