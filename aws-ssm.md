# aws ssm

Describe

```
aws ssm describe-instance-information | jq -r '.InstanceInformationList[] | .InstanceId'
```

## Run Commands

Orchestration logs for commands that are run on the instance are located in _/var/lib/amazon/ssm/INSTANCE-ID/document/orchestration/RUN-COMMAND-EXECUTION-ID_ ([ref](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-troubleshooting.html#patch-manager-troubleshooting-contact-support))

References:

- [Understanding command statuses](https://docs.aws.amazon.com/systems-manager/latest/userguide/monitor-commands.html)
