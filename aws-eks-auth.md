# aws eks auth

## Authenticating IAM users/roles with the Kubernetes API server

IAM users get mapped to a user and group in Kubernetes via the `aws-auth` ConfigMap in kube-system, eg:

```
apiVersion: v1
data:
  mapUsers: |
    - userarn: <arn:aws:iam::111122223333:user/ada.lovelace>
      username: ada.lovelace
      groups:
        - awesome-app-admin
kind: ConfigMap
```

Roles can be mapped via the `mapRoles` key, eg:

```
apiVersion: v1
data:
  mapRoles: |
    - rolearn: <ARN of instance role (not instance profile)>
      username: awesome.role
      groups:
        - awesome-app-admin
```

See [Managing users or IAM roles for your cluster](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)

## IAM roles for service accounts

To allow an IAM role to be assumed by an EKS service account, see [IAM roles for service accounts - Technical overview](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html).

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

If you do not provide the serviceAccountName value the deployment will utilise the default ServiceAccount in the namespace.
