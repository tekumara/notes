# ssm patching

Patch now

```
aws ssm send-command --document-name "AWS-RunPatchBaseline" --parameters Operation="Install" \
    --output-s3-bucket-name $bucket  --output-s3-key-prefix $prefix \
    --cloud-watch-output-config CloudWatchLogGroupName=$name,CloudWatchOutputEnabled=true
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
aws ssm get-document --name AWS-RunPatchBaseline --query 'Content' --output text > AWS-RunPatchBaseline
```

View Patch Linux

```
jq -r '.mainSteps[1].inputs.runCommand[]' AWS-RunPatchBaseline
```

NB: if an instance is patched with the NoReboot option, and there are patches pending a reboot, then the instance will have a noncompliant status. Once the instance has been rebooted run the patch baseline scan has been run to update its patch summary to compliant.

https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-compliance-identify.html
