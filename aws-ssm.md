# AWS SSM

## SSM Parameter Store

List all parameter names starting with `/aws/service/ami-amazon-linux-latest/amzn2`:

```
aws ssm describe-parameters --filter "Key=Name,Values=/aws/service/ami-amazon-linux-latest/amzn2" --query "Parameters[*].{Name:Name}" --output text
```
