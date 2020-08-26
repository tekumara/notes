# AWS SSM

## SSM Parameter Store

List all parameter names starting with `/aws/service/ami-amazon-linux-latest/amzn2`:
```
aws ssm describe-parameters --filter "Key=Name,Values=/aws/service/ami-amazon-linux-latest/amzn2" --query "Parameters[*].{Name:Name}" --output text
```

## SSM sessions

SSM provides SSH access for instances based on IAM roles (no need to manage SSH keys), plus audits access via cloudtrail, and can log sessions to cloudwatch.


Install the session manager plugin

Show managed instances that have SSM agent installed and are accessible:
```
aws ssm describe-instance-information
```

Port forward 8888
```
aws ssm start-session --target i-0f9116c8efe421cd4 --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["8888"],"localPortNumber":["8888"]}'
```

## Checking and managing the SSM agent

Is SSM installed on the instance, and which version?
```
rpm -qa | grep ssm
```

Upgrade ssm
```
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
```

Restart the ssm agent
```
sudo systemctl restart amazon-ssm-agent
```

## SSH Tunnelling

Add the following to your `.ssh/config`:
```
Host i-* mi-*
    User ec2-user
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    ForwardAgent yes
    ServerAliveInterval 120
    IdentityFile ~/.ssh/ec2-pem
```

NB: You need ssm-agent 2.3.672.0 or greater for [SSH tunnelling support](https://aws.amazon.com/about-aws/whats-new/2019/07/session-manager-launches-tunneling-support-for-ssh-and-scp/) and the correct [aws cli + SSM plugin versions](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

You can then use ssh directory as follows: `ssh i-040c0af6a7a4ba0a7`
Or, with port forwarding: `ssh -L 8888:localhost:8888 i-040c0af6a7a4ba0a7`

Time to first byte seems the same over forwarding as direct.

## Troubleshooting

Try to connect as `ssm-user` via the AWS Console - AWS Systems Manager - Session Manager - Start session - and select a target instance.
Try to connect as `ssm-user` via the CLI, eg: `aws ssm start-session --target i-0850c1b15772106cc`
Try to connect as `ec2-user` via SSH tunnelling, eg: `ssh -v -i ~/.ssh/ec2.pem ec2-user@i-0850c1b15772106cc`

Instance does not appear as a target instance in `AWS Systems Manager - Session Manager - Start session` or `aws ssm describe-instance-information`?

Check /var/log/amazon/ssm/amazon-ssm-agent.log for errors.

Can't connect from the command line?
```
$ aws ssm start-session --target i-0850c1b15772106cc
An error occurred (TargetNotConnected) when calling the StartSession operation: i-0850c1b15772106cc is not connected.
ssh_exchange_identification: Connection closed by remote host
```

Make sure you are in the right AWS region, as set in the environment variable `AWS_DEFAULT_REGION` or `~/.aws/config`

## EC2 IAM Instance profile policy

If the instance is not visible, or you get an `Unauthorized request` error when trying to start a session, make sure you the EC2 IAM instance profile has an [SSM policy attached](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html) with the right permissions.

To your instance profile, add `AmazonSSMManagedInstanceCore` or a custom policy with at least the following:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ssm:UpdateInstanceInformation",
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
                "s3:GetEncryptionConfiguration"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowSessionManagerComms"
        }
    ]
}
```

The ssm-agent may need to be restarted after any policy changes.
