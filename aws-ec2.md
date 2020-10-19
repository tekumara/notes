# AWS EC2

## ec2 instance metadata

Get instance type

```
curl http://169.254.169.254/latest/meta-data/instance-type
```

Get instance credentials

```
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/local-credentials
```

Get system log. NB: there's a delay before this appears.

```
aws ec2 get-console-output --instance-id  $instance_id --output text
```

## Describe instances

Describe instances as a table, filtered by the `Name` tag

```
aws ec2 describe-instances --filters "Name=tag:Name,Values=super-duper-instance" --region=us-east-1 --output table
```

Describe instance state and public DNS name in a table:

```
aws ec2 describe-instances --filters "Name=tag:Name,Values=super-duper-instance" --region=us-east-1 \
        --query 'Reservations[].Instances[].[State.Name,NetworkInterfaces[].PrivateIpAddresses[].Association.PublicDnsName]' --output table
```

Describe instances (similar to the AWS EC2 console)

```
aws ec2 describe-instances --region us-east-1 | jq -r '.Reservations[].Instances[] | [ .State.Name, (.Tags | map(select(.Key == "Name"))? | .[0].Value), .InstanceType, .PublicDnsName, .LaunchTime] | @tsv' | sed $'s/\t\t/\t-\t/g' | column -t -s $'\t' | sort
```

## UserData

Show the UserData for a launched instance

```
aws ec2 get-launch-template-data --instance-id $INSTANCE_ID | jq -r '.LaunchTemplateData.UserData | @base64d'
```

## Describe subnets

List subnets with the Name tag (others ignored):

```
aws ec2 describe-subnets | jq '.Subnets[] | {SubnetId, VpcId, Name: (.Tags | .[]? | select(.Key == "Name") | .Value), CidrBlock}'
```

List all subnets (as csv sorted by vpc id)

```
aws ec2 describe-subnets | jq -r '.Subnets[] | [.SubnetId, .VpcId, (.Tags | .[]? | select(.Key == "Name") | .Value), .CidrBlock] | @csv' | sort
```

## Describe security groups

List instances using security group

```
aws ec2 describe-network-interfaces --filters Name=group-id,Values=sg-010794b2ac996e025
```

Describe security group

```
aws ec2 describe-security-groups --group-ids sg-071ce0236a26a309c
```

## Volumes

Create a volume

```
aws ec2 create-volume --size 10 --availability-zone us-east-1a --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=oliver-test}]'
```

## Launch templates

Allow you to supply values for AMI, IAM instance profile, instance type (including spot), subnet, security group, key pair and volumes. You can override these settings as needed when your launch an instance from the template.

## Status checks

Instance Status - software and network configuration, requiring your involvement to repair
System Status - AWS systems, requiring AWS involvement to repair

When an instance first starts these checks will be in the initializing phase. You'll be able to SSH into your instance being these checks pass.

See [Status checks for your instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/monitoring-system-instance-status-check.html)

## Troubleshooting

### Instance doesn't come up

Make sure the EBS volume is mounted with the correct [device name](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html)

### Client.InternalError: Client error on launch

In Cloudtrail look for `RunInstances` events, and then any events immediately afterwards that have errored, eg: `GenerateDataKeyWithoutPlaintext` events with errorCode `AccessDenied`.
