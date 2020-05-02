# aws ec2 metadata endpoint

Instance profile
```
curl -s http://169.254.169.254/latest/meta-data/iam/info | jq -r .InstanceProfileArn
```

Role credentials
```
role=my-top-secret-role
curl "http://169.254.169.254/latest/meta-data/iam/security-credentials/$role" > /tmp/iam-security-credentials
export AWS_ACCESS_KEY_ID=$(jq -r '.AccessKeyId' /tmp/iam-security-credentials)
export AWS_SECRET_ACCESS_KEY=$(jq -r '.SecretAccessKey' /tmp/iam-security-credentials)
export AWS_SESSION_TOKEN=$(jq -r '.Token' /tmp/iam-security-credentials)
```

Region & AZ
```
curl http://169.254.169.254/latest/meta-data/placement/availability-zone
```

Instance type
```
curl http://169.254.169.254/latest/meta-data/instance-type
```

## Reference

See [Retrieving instance metadata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html)