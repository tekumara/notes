# aws cloud9

To show all users of a cloud9 environment, and when they last accessed it:

```
aws cloud9 describe-environment-memberships --environment-id $ENVIRONMENT_ID
```

## Preview

Use Tools -> Preview -> Preview Running Application to open a web browser to port 8080 of your cloud9 instance.
To view ports 8081 or 8082 append then to the URL, eg:

```
https://1234567890.vfs.cloud9.us-east-1.amazonaws.com:8081
```

See [Preview a running application](https://docs.aws.amazon.com/cloud9/latest/user-guide/app-preview.html#app-preview-preview-app)

## network access

When using SSH (as opposed to SSM) Cloud9 connects to your EC2 instance from the following CIDR ranges:

```
curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service=="CLOUD9" and .region=="us-east-1") | .ip_prefix'
35.172.155.192/27
35.172.155.96/27
```

For this to work, the EC2 instance's security group must allow ingress from these CIDR ranges. When using a no-ingress SSM Session Manager environment, this is not the case.

## tmux

cloud9 runs terminal sessions inside tmux so you can reconnect to them between browser sessions (if cloud9 is still running). If you use the cloud9 terminal to SSH to another machine running tmux, you'll have a nested tmux session and the default bind key will refer to the cloud9 tmux session. Change the bind key for the cloud9 tmux session so you can operate the remote tmux session. ([ref](https://www.freecodecamp.org/news/tmux-in-practice-local-and-nested-remote-tmux-sessions-4f7ba5db8795/))
