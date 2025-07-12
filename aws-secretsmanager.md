# aws secrets manager

## vs SSM parameter store

[Preferred over SSM parameter store](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_CheatSheet.html#411-aws) because

- the steady limit for SSM GetParameter is 40 and burst is 100 transactions per second. You can enable the `high-throughput-enabled` setting to increase the limit to 1,000 TPS (which costs $0.05 per 10,000 Parameter Store API interactions)
- cross account access and resource policies

AWS Secrets Manager provide a built-in framework for rotating credentials! And allows more 'JSON'-y data instead of strictly a single 'parameter' (yes I know you can put json in there too)

SSM costs:

- Standard parameters free
- $0.05 per advanced parameter per month
- High throughput enabled: $0.05 per 10,000 Parameter Store API interactions

Secret Manager costs:

- $0.40 per secret per month.
- costs $0.05 per 10,000 API calls.

## Usage

Create secret encrypted using the account's default KMS key `aws/secretsmanager` (which means this secret can't be accessed from another account):

```
aws secretsmanager create-secret --name topsecret --description "top secret!" --secret-string file://topsecret.json
```

List

```
aws secretsmanager list-secrets | jq -C '.SecretList[] | {ARN, Name, Description, KmsKeyId}'
```

Get value

```
aws secretsmanager get-secret-value --secret-id topsecret | jq -r .SecretString
```

Set secret value from clipboard

```
pbcopy | aws secretsmanager put-secret-value --secret-id topsecret --secret-string "$(</dev/stdin)"
```

Mark secret for deletion in 30 days

```
aws secretsmanager delete-secret --secret-id topsecret
```

Force immediate deletion

```
aws secretsmanager delete-secret --secret-id topsecret --force-delete-without-recovery
```

Get resource policy

```
aws secretsmanager get-resource-policy --secret-id topsecret | jq '.ResourcePolicy | fromjson'
```

Describe secret. Will include a KmsKeyId field only if use a CMK (if using the default key this field won't be present)

```
aws secretsmanager describe-secret --secret-id topsecret
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

### Sharing secrets cross-account

You can't access a secret from a different AWS account if you encrypt the secret with the default KMS service key.

When accessing the secret use its ARN, otherwise you'll be trying to access a secret in the current account and will see:

```
.. not authorized to perform: secretsmanager:GetSecretValue on resource: myapp/top-secret because no identity-based policy allows the secretsmanager:GetSecretValue action
```

See [How do I share AWS Secrets Manager secrets between AWS accounts?](https://aws.amazon.com/premiumsupport/knowledge-center/secrets-manager-share-between-accounts/)

### AccessDeniedException ... No resource-based policy allows the secretsmanager:GetSecretValue action

Occurs when the `AWS_DEFAULT_REGION` env var doesn't match the key region, eg:

```
arn:aws:sts::123456789012:assumed-role/app-role/MySession is not authorized to perform: secretsmanager:GetSecretValue on resource: arn:aws:secretsmanager:us-east-1:111111122222:secret:top-secret because no resource-based policy allows the secretsmanager:GetSecretValue action
```

Adjust `AWS_DEFAULT_REGION` or explicitly provide the region when fetching the key, eg:

```python
client = boto3.client("secretsmanager", region_name="us-east-1")
```

### AccessDeniedException ... No identity-based policy allows the secretsmanager:GetSecretValue action

1. Make sure the arn in the policy ends in `-??????`.
1. Can occur when fetching a secret via its partial arn and the secret name contains a hyphen and six chars, eg:

   ```
   AccessDeniedException: User: arn:aws:sts::123456789012:assumed-role/awesome-app/good-session is not authorized to perform: secretsmanager:GetSecretValue on resource: arn:aws:secretsmanager:ap-southeast-2:123456789012:secret:awesome-app/newrelic-object because no identity-based policy allows the secretsmanager:GetSecretValue action
   ```

   Use the full ARN. See [An AWS CLI or AWS SDK operation can't find my secret from a partial ARN](https://docs.aws.amazon.com/secretsmanager/latest/userguide/troubleshoot.html#ARN_secretnamehyphen)

### creating Secrets Manager Secret: AccessDeniedException: Access to KMS is not allowed

Your role needs:

```
      "kms:Decrypt",
      "kms:GenerateDataKey*"
```

Also ensure that the kms key ARN is correct (not missing any chars etc.)
