# AWS SSM Parameter Store

Describe parameters

```
aws ssm describe-parameters
```

List all parameter names starting with `/aws/service/ami-amazon-linux-latest/amzn2`:

```
aws ssm describe-parameters --filter "Key=Name,Values=/aws/service/ami-amazon-linux-latest/amzn2" --query "Parameters[*].{Name:Name}" --output text
```

Put parameter:

```
aws ssm put-parameter \
    --name $key_name \
    --value "$TOP_SECRET" \
    --type "SecureString" \
    --key-id "$KMS_KEY_ID" \
    --overwrite
```
