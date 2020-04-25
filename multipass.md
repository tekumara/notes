# multipass

Install:
```
brew cask install multipass
```

Launch an Ubuntu LTS instance with defaults of 1 CPU, 1G mem, 5G disk:
```
multipass launch -n test
```

NB: The minimum disk size for an Ubuntu LTS image is 2G

## Shell

`multipass shell <name>` will start a shell as user ubuntu

Ssh can be used with the ssh keys stored under /var/root which requires sudo, eg:
```
sudo ssh -i /var/root/Library/Application\ Support/multipassd/ssh-keys/id_rsa ubuntu@192.168.64.4
```
Alternatively install your own keys using cloud-init

## Non ubuntu images

Only the Linux version supports non Ubuntu images ([#737](https://github.com/canonical/multipass/issues/737))

## Changing CPU/memory

```
sudo launchctl unload /Library/LaunchDaemons/com.canonical.multipassd.plist
sudo vim /var/root/Library/Application\ Support/multipassd/multipassd-vm-instances.json
sudo launchctl unload /Library/LaunchDaemons/com.canonical.multipassd.plist
```

## Troubleshooting

### timed out waiting for initialization to complete

During launch, multipass will time out the cloud-init after 5 mins. When [#1039](https://github.com/canonical/multipass/issues/1039) is fixed the timeout will be configurable.  

