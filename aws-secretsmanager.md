# aws secrets manager

## vs SSM parameter store

Prefered over SSM parameter store because

- the steady limit for SSM GetParameter is 40 and burst is 100 transactions per second.
- provides the ability to perform resource level access control

## Usage

Create secret encrypted using the account's default KMS key `aws/secretsmanager` (which means this secret can't be accessed from another account):

```
aws secretsmanager create-secret --name topsecret --description "top secret" --secret-string file://topsecret.json
```

```
aws secretsmanager list-secrets | jq '.SecretList[] | {ARN, Name, Description}'
```

```
aws secretsmanager get-secret-value --secret-id topsecret | jq -r .SecretString
```

Mark secret for deletion in 30 days

```
aws secretsmanager delete-secret --secret-id topsecret
```

Force immediate deletion

```
aws secretsmanager delete-secret --secret-id topsecret --force-delete-without-recovery
```

## Cross-account access

Secrets can be fetched cross-account using an ARN containing the secret's friendly name (ie: the name without the random suffix) eg:

```
aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-east-1:012345678901:secret:ssh/key
```

When granting access in an IAM policy we can use a wildcard:

```
arn:aws:secretsmanager:us-east-1:012345678901:secret:ssh/key-??????
```

## Troubleshooting

```
An error occurred (InvalidRequestException) when calling the CreateSecret operation: You can’t perform this operation on the secret because it was deleted.
```

Wait until the secret is deletion (even when deleting with `--force-delete-without-recovery` the deletion happens asynchronously so you may need to wait a minute or so).

```
You can't access a secret from a different AWS account if you encrypt the secret with the default KMS service key.
```
