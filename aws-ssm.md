# aws ssm

## Parameter Store

List all parameters

```
aws ssm describe-parameters
```

To see which key was used for encryption, check the history:

```
aws ssm get-parameter-history --name my-awesome-param
```

Create/update parameter using the value in the clipboard:

```
aws ssm put-parameter --name=my-awesome-param --description "so awesome" --type SecureString --value /tmp/foo --key-id alias/aws/ssm --overwrite --value $(pbpaste)
```

## Session manager

Describe instances

```
aws ssm describe-instance-information | jq -r '.InstanceInformationList[] | .InstanceId'
```

### Run Commands

Orchestration logs for commands that are run on the instance are located in _/var/lib/amazon/ssm/INSTANCE-ID/document/orchestration/RUN-COMMAND-EXECUTION-ID_ ([ref](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-troubleshooting.html#patch-manager-troubleshooting-contact-support))

References:

- [Understanding command statuses](https://docs.aws.amazon.com/systems-manager/latest/userguide/monitor-commands.html)
