# aws ec2 metadata endpoint

IMDSv2

```
token=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600") \
&& curl -H "X-aws-ec2-metadata-token: $token" -v http://169.254.169.254/latest/meta-data/
```

Instance profile

```
curl -s http://169.254.169.254/latest/meta-data/iam/info | jq -r .InstanceProfileArn
```

Get assumed role

```
curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

Role credentials

```
token=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
role=$(curl -sH "X-aws-ec2-metadata-token: $token" http://169.254.169.254/latest/meta-data/iam/security-credentials/)
curl -sH "X-aws-ec2-metadata-token: $token" "http://169.254.169.254/latest/meta-data/iam/security-credentials/$role" > /tmp/iam-security-credentials
export AWS_ACCESS_KEY_ID=$(jq -r '.AccessKeyId' /tmp/iam-security-credentials)
export AWS_SECRET_ACCESS_KEY=$(jq -r '.SecretAccessKey' /tmp/iam-security-credentials)
export AWS_SESSION_TOKEN=$(jq -r '.Token' /tmp/iam-security-credentials)
export AWS_DEFAULT_REGION=$(curl -sH "X-aws-ec2-metadata-token: $token" http://169.254.169.254/latest/meta-data/placement/region)
```

AZ

```
curl -H "X-aws-ec2-metadata-token: $token" http://169.254.169.254/latest/meta-data/placement/availability-zone
us-east-1a
```

Region

```
curl -H "X-aws-ec2-metadata-token: $token" http://169.254.169.254/latest/meta-data/placement/region
us-east-1
```

Export region

```
export AWS_DEFAULT_REGION=$(curl -H "X-aws-ec2-metadata-token: $token" http://169.254.169.254/latest/meta-data/placement/region)
```

Instance type

```
curl http://169.254.169.254/latest/meta-data/instance-type
```

## Reference

[Instance metadata categories](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-categories.html) lists whats available from the metadata endpoint.
