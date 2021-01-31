# AWS IAM

## IAM identifers

`arn:aws:iam::123456789012:root` the root user ie: the AWS account itself, in this case account `123456789012`

## InstanceProfile vs Role

InstanceProfile - associated with a Role, and can be attached to an EC2 instance so the EC2 instance assumes that role.

## Roles

Describe role ARN, MaxSessionDuration, trust relationships for assuming the role (ie: AssumeRolePolicyDocument) etc.

```
aws iam get-role --role-name $(ROLE_NAME)
```

List all roles

```
aws iam list-roles | jq -r '.Roles[].RoleName'
```

List all roles, and their trust policy (aka trusted entities)

```
aws iam list-roles | jq '.Roles[] | [.RoleName, .AssumeRolePolicyDocument]'
```

## Policies

Inline policies are embedded in the role. Managed policies are separate and can be attached to multiple roles.
The type of a policy is visible in the AWS console on the role to which it is attached.

Managed policies are [versioned](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-versioning.html). The default version is the currently active version, ie: the version in affect for all principal entities (users, groups, and roles) the managed policy is attached to.

See [Managed policies and inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)

## Managed policies

List managed policies attached to the role

```
aws iam list-attached-role-policies --role-name $(ROLE_NAME)
```

Get policy, which returns the default (ie: active) version

```
aws iam get-policy --policy-arn $(ARN)
```

Get managed policy document v1

```
aws iam get-policy-version --policy-arn $(ARN) --version-id v1
```

List all policy versions

```
aws iam list-policy-versions --policy-arn $(ARN)
```

## Inline policies

List names of inline policies

```
aws iam list-role-policies --role-name $(ROLE_NAME)
```

Get inline policy (cannot be used for managed policies)

```
aws iam get-role-policy --role-name $(ROLE_NAME) --policy-name $(POLICY_NAME)
```

## Roles + Policy

Create [AWSBatchServiceRole](https://docs.aws.amazon.com/batch/latest/userguide/service_IAM_role.html):

```
aws iam create-role --role-name "AWSBatchServiceRole" --description "Allows Batch to create and manage AWS resources on your behalf." --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["sts:AssumeRole"],"Principal":{"Service":["batch.amazonaws.com"]}}]}'

aws iam attach-role-policy --role-name "AWSBatchServiceRole" --policy-arn "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
```

List details of ec2InstanceRole (NB: make sure the policy version fetched is the default policy version and attached)

```
aws iam get-role --role-name ecsInstanceRole && aws iam list-attached-role-policies --role-name ecsInstanceRole && aws iam get-policy --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role && aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role --version-id v6
```
