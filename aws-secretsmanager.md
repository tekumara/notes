# aws secrets manager

## vs SSM parameter store

Prefered over SSM parameter store because 
* the steady limit for SSM GetParameter is 40 and burst is 100 transactions per second.
* provides the ability to perform resource level access control

## Usage 

Create secret encrypted using the account's default KMS key `aws/secretsmanager` (which means this secret can't be accessed from another account):
```
aws secretsmanager create-secret --name topsecret --description "top secret!" --secret-string file://topsecret.json
```

```
aws secretsmanager list-secrets
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


# Troubleshooting

```
An error occurred (InvalidRequestException) when calling the CreateSecret operation: You can’t perform this operation on the secret because it was deleted.
```

Wait until the secret is deletion (even when deleting with `--force-delete-without-recovery` the deletion happens asynchronously so you may need to wait a minute or so).

