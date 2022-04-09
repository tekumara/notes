# Session Manager

Session Manager provides a websocket session to EC2 instances, audits access via cloudtrail, and can log the content of sessions to cloudwatch. It allows IAM-based authentication to a shell on an instance without the need to manage SSH keys.

Session Manager is low throughput, see [https://globaldatanet.com/blog/scp-performance-with-ssm-agent](https://globaldatanet.com/blog/scp-performance-with-ssm-agent). This could be a good thing if you'd like to limit data exfiltration.

## Usage

Install the [session manager plugin for the AWS CLI](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html):

```
brew install session-manager-plugin --no-quarantine
session-manager-plugin --version
```

Show managed instances that have SSM agent installed and are accessible:

```
aws ssm describe-instance-information
```

If your instance is not visible see the Troubleshooting section below.

Start a session as ssm-user with the Bourne shell (sh)

```
aws ssm start-session --target $instance_id
```

Port forward 8888 only (no ssh)

```
aws ssm start-session --target $instance_id --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["8888"],"localPortNumber":["8888"]}'
```

## About sessions

By default:

- sessions time out after 20 minutes of inactivity see [Specify an idle session timeout value](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-preferences-timeout.html)

- sessions are launched using the credentials of a system-generated ssm-user account, which has sudoers. To start sessions as an alternative user, see [Enable run as support for Linux and macOS instances](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-preferences-run-as.html)

## Session manager preference documents

Session Manager uses [session documents](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-ssm-docs.html) to determine which type of session to start, such as a port forwarding session, a session to run an interactive command, or a session to create an SSH tunnel.

A Session document can be of the following session types:

- `Standard_Stream` streams to the ssm-agent which handles login. A session started without a document creates a `Standard_Stream` session type.
- `Port` streams to the given port on the host. A session started with the `AWS-StartSSHSession` document streams to port 22 by default, or any other port specified by the parameter portNumber.
- `InteractiveCommands`
- `NonInteractiveCommands`

To see the content of the AWS-StartSSHSession document:

```
aws ssm get-document --name AWS-StartSSHSession --query 'Content' --output text
```

For more info see:

- [Create Session Manager preferences (command line)](https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-create-preferences-cli.html)
- [Session document schema](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-schema.html)

## SSH Tunnelling

Session Manager [supports SSH and SCP tunnelling](https://aws.amazon.com/about-aws/whats-new/2019/07/session-manager-launches-tunneling-support-for-ssh-and-scp/) using the AWS-StartSSHSession session document. This document starts a Port session to port 22 (can be changed) on the host. This allows you to connect to sshd and authenticate as any ssh enabled user.

To connect to port 22 on the instance:

```
aws ssm start-session --target $instance_id --document-name AWS-StartSSHSession
```

Connecting directly is not useful without an ssh client. To tell your ssh client to use this session as ProxyCommand, add the following to `.ssh/config`:

```
Host i-* mi-*
    User ec2-user
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    ForwardAgent yes
    ServerAliveInterval 120
    # also port forward 8888 on the host
    LocalForward 8888 localhost:8888
    IdentityFile ~/.ssh/ec2-pem
```

You can then use ssh directly as follows: `ssh i-040c0af6a7a4ba0a7`
Or, with port forwarding: `ssh -L 8888:localhost:8888 i-040c0af6a7a4ba0a7`

Time to first byte seems the same over tunneling as direct.

SSH tunnelling can be used with VSCode remote SSH.

## Troubleshooting

## Checking and managing the SSM agent

The SSM agent should be installed by default.

Is SSM installed on the instance, and which version?

Amazon Linux: `rpm -qa | grep ssm`
Ubuntu: `snap list`

Upgrade ssm

```
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
```

Restart the ssm agent

```
# Amazon Linux
sudo systemctl restart amazon-ssm-agent

# Ubuntu
sudo systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service
```

### Instance not visible

Instance does not appear as a target instance in `AWS Systems Manager - Session Manager - Start session` or `aws ssm describe-instance-information`?

- Check /var/log/amazon/ssm/amazon-ssm-agent.log for errors.
- Check the EC2 IAM Instance profile policy (see below).

### Can't connect from the command line

```
$ aws ssm start-session --target i-0850c1b15772106cc
An error occurred (TargetNotConnected) when calling the StartSession operation: i-0850c1b15772106cc is not connected.
ssh_exchange_identification: Connection closed by remote host
```

Check the ping status of your instance:

```
aws ssm describe-instance-information
```

If it is `ConnectionLost` the instance might have crashed.

Try to connect as `ssm-user` via the AWS Console - AWS Systems Manager - Session Manager - Start session - and select a target instance.
Try to connect as `ssm-user` via the CLI, eg: `aws ssm start-session --target i-0850c1b15772106cc`
Try to connect as `ec2-user` via SSH tunnelling, eg: `ssh -v -i ~/.ssh/ec2.pem ec2-user@i-0850c1b15772106cc`

Make sure you are in the right AWS region, as set in the environment variable `AWS_DEFAULT_REGION` or `~/.aws/config`

## EC2 IAM Instance profile policy

If the instance is not visible, or you get an `Unauthorized request` error when trying to start a session, make sure you the EC2 IAM instance profile has an [SSM policy attached](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html) with the right permissions.

To your instance profile, add `AmazonSSMManagedInstanceCore` or a custom policy with at least the following:

```json
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

The ssm-agent will probably need to be restarted after any IAM changes.

## References

- [EC2 Instance Connect vs. SSM Session Manager](https://carriagereturn.nl/aws/ec2/ssh/connect/ssm/2019/07/26/connect.html)
- [GitHub - aws/amazon-ssm-agent](https://github.com/aws/amazon-ssm-agent)
