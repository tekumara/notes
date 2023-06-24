# terraformer

## Troubleshooting

```
❯ terraformer import aws -r s3
2023/05/30 15:20:02 aws importing default region
2023/05/30 15:20:07 aws importing... s3
2023/05/30 15:20:12 aws error initializing resources in service s3, err: failed to refresh cached credentials, no EC2 IMDS role found, operation error ec2imds: GetMetadata, request canceled, context deadline exceeded
2023/05/30 15:20:12 aws Connecting....
```

Set the AWS env vars and then trick it into using an empty profile, eg:

```
terraformer import aws -r s3 --profile ""
```

This also works if you get

```
AWS Error: failed to refresh cached credentials, the SSO session has expired or is invalid: failed to read cached SSO token file
```
