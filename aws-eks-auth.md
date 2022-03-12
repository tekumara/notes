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

To allow an IAM role to be assumed by an EKS service account, add an `eks.amazonaws.com/role-arn` annotation to the role and establish a trust policy from the role to the service account. See [IAM roles for service accounts - Technical overview](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html).

## EKS tokens

The EKS API auths using a token which is a [signed STS GetCallerIdentityRequest](https://github.com/hashicorp/terraform-provider-aws/blob/9af0841a9fcafd84ae0a1309ec5c90f0b81015fa/internal/service/eks/token.go#L196)

To generate a token using current credentials:

```
aws eks get-token --cluster-name $clustername
```

or for a specific role you can assume:

```
aws eks get-token --cluster-name $clustername --role-arn $rolearn
```

## Assuming a role in a pod

When running in a pod, the AWS SDK will assume the role annotated on the service account automatically.

Troubleshooting:

```
$ aws sts get-caller-identity
Unable to locate credentials. You can configure credentials by running "aws configure".
```

The service account does not have an `eks.amazonaws.com/role-arn` annotation.

```
An error occurred (AccessDenied) when calling the AssumeRoleWithWebIdentity operation: Not authorized to perform sts:AssumeRoleWithWebIdentity
```

The annotated role cannot be assumed. Check the trust policy on the role.

### Manually assuming a role using the serviceaccount token

The AWS SDK will automatically using the web identity token file, but to use it manually:

```
AWS_ROLE_ARN=arn:aws:iam::ACCOUNT_ID:role/IAM_ROLE_NAME
AWS_WEB_IDENTITY_TOKEN_FILE=/var/run/secrets/kubernetes.io/serviceaccount/token
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

Troubleshooting:

```
An error occurred (InvalidIdentityToken) when calling the AssumeRoleWithWebIdentity operation: Missing a required claim: aud
```

The service account does not have an `eks.amazonaws.com/role-arn` annotation.
