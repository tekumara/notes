# AWS AMI

## Snapshots

An AMI is a registered snapshot and can be created using Create Image from the console.

Deregistering an AMI does not delete the snapshot.

An AMI can have Public visibility.

## Describe images

Latest image starting with `GAMI-AMZLinux2`

```
aws ec2 describe-images --filters "Name=name,Values=GAMI-AMZLinux2*" --query 'reverse(sort_by(Images, &CreationDate))[0].Name' --output text
```

List all images owned by your account (self) and account 137112412989 (ie: Amazon Linux base image)

```
aws ec2 describe-images --owners self 137112412989 --query 'reverse(sort_by(Images, &CreationDate))[].[Name,ImageId,CreationDate]' --output table
```

List images

```
aws ec2 describe-images --image-ids ami-66506c1c
```

## Accounts

amazon All Amazon images (windows, deep learning, eks etc.)
137112412989 Amazon Linux base
099720109477 Canonical Ubuntu
898082745236 Amazon Deep Learning

## Latest Amazon Linux Base AMIs (SSM)

To list all the latest amazon linux base AMIs, query parameter store ([ref](https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/)):

```
aws ssm get-parameters-by-path --path /aws/service/ami-amazon-linux-latest/
```

To filter to just the amazon linux 2 AMIs

```
aws ssm get-parameters-by-path --path /aws/service/ami-amazon-linux-latest/ | jq -r '.Parameters[] | select(.Name | contains("amzn2")) | [.Name, .Value] | @tsv'
```

To get the latest amazon linux 2 GP2 AMI:

```
aws ssm get-parameters --name /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2
```

## AMI types

- graphics - for use with the GPU instance types
- minimal - for use with the EBS storage type (see below)
- arm64 - ARM CPU
- x86_64 - Intel CPU

Storage types:

- ebs - backed by a magnetic EBS volume
- gp2/ssd - backed by a SSD EBS volume (recommended)
- s3 - instance-store backed (ie: temporary locally attached storage)

[Virtualization types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/virtualization_types.html):

- hvm - fully virtualized (recommended)
- pv - paravirtual (older instances only)

## Key pair

If you create an AMI from a source instance, it will contain authorization for the key pair used at the time the source instance was created.

Any instances created from that AMI, even with a different key pair, will still allow access from the source instance's key pair as well.
