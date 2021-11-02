# ssm patching

Patch now

```
aws ssm send-command --document-name "AWS-RunPatchBaseline" --parameters Operation="Install" \
    --output-s3-bucket-name $bucket  --output-s3-key-prefix $prefix \
    --instance-ids $instance_id
```

If it fails, checks the S3 bucket for logs.

To list a command, and the output s3 bucket. The status is "FAILED" if any of the individual per-instance invocations has failed.

```
aws ssm list-commands --command-id $command_id
```

To get all per-instance invocations of a command, with the per-instance status, but no output s3 bucket:

```
aws ssm list-command-invocations --command-id $command_id
```

View document

```
aws ssm get-document --name AWS-RunPatchBaseline --query 'Content' --output text > AWS-RunPatchBaseline.json
```

View the PatchLinux step of the AWS-RunPatchBaseline document:

```
jq -r '.mainSteps[1].inputs.runCommand[]' AWS-RunPatchBaseline.json
```

## Patch baselines

[Patch baselines](https://docs.aws.amazon.com/systems-manager/latest/userguide/about-patch-baselines.html) define which patches are approved are so will be installed or scanned for.

Get the AWS Ubuntu default patch baseline id:

```
aws ssm get-default-patch-baseline --operating-system UBUNTU --region us-east-1
```

Download the AWS Ubuntu default patch baseline:

```
aws ssm get-patch-baseline --baseline-id arn:aws:ssm:us-east-1:075727635805:patchbaseline/pb-0c7e89f711c3095f4
```

This baselines immediately approves all operating system security-related patches that have a priority of "Required", "Important", "Standard," "Optional," or "Extra." There is no wait before approval because reliable release dates aren't available in the repos.

## Compliance

If an instance is patched with the NoReboot option, and there are patches pending a reboot, then the instance will have a noncompliant status. Once the instance has been rebooted run the patch baseline scan has been run to update its patch summary to compliant.

## Reference

- [Identifying out-of-compliance instances](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-compliance-identify.html)
- [tekumara/aws-ssm-patch-manager](https://github.com/tekumara/aws-ssm-patch-manager) Reverse engineering AWS Systems Manager Patch Manager
