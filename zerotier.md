# Zerotier

Zerotier uses NAT traversal over UDP, falling back to TCP (see [Router configuration tips](https://zerotier.atlassian.net/wiki/spaces/SD/pages/6815768/Router+Configuration+Tips))

## Install

* See https://www.zerotier.com/download.shtml
  * macOS: `brew cask install zerotier-one`
  * Linux `curl -s https://install.zerotier.com | sudo bash`
* Create a network via https://my.zerotier.com/
* Join network: eg: `sudo zerotier-cli join 8056c2e21c000001`. Access will be denied until you authorize the member.
* From the network page on https://my.zerotier.com/ under Members, check Auth on the member. It will be assigned an IP address, which you can see on the network page under Members - Managed IPs, or via `ifconfig zt0`

Network status: `sudo zerotier-cli listnetworks` 
Show config (including whether falling back to tcp): `sudo zerotier-cli info -j`

ACCESS_DENIED means the peer hasn't been authorized on the network.  
PORT_ERROR might occur after install on MacOS - a restart should fix it
OK means you are good to go!  

##

 sudo zerotier-cli info -j

## vs sshuttle

Very unproven but zerotier seems to have higher throughput and lower latency than sshuttle.  

## Troubleshooting

### missing authentication token and authtoken.secret not found (or readable) in /var/lib/zerotier-one

You must run *zerotier-cli* as root, eg: `sudo zerotier-cli info`

### Error connecting to the ZeroTier service: connection failed

If you get this error when running *zerotier-cli*, check the service is up and inspect the logs:

```
systemctl status zerotier-one
journalctl -u zerotier-one
```

If everything still looks good, try a restart: `sudo systemctl restart zerotier-one`


### REQUESTING_CONFIGURATION

Can't talk to the network.


## Reference

https://github.com/zerotier/ZeroTierOne
