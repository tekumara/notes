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

## Assuming a role

```
aws sts assume-role-with-web-identity \
 --role-arn $AWS_ROLE_ARN \
 --role-session-name mh9test \
 --web-identity-token file://$AWS_WEB_IDENTITY_TOKEN_FILE \
 --duration-seconds 3600 > /tmp/irp-cred.txt
export AWS_ACCESS_KEY_ID="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.AccessKeyId")"
export AWS_SECRET_ACCESS_KEY="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.SecretAccessKey")"
export AWS_SESSION_TOKEN="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.SessionToken")"
rm /tmp/irp-cred.txt
```