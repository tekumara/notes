# Zerotier

Zerotier uses NAT traversal over UDP, falling back to TCP (see [Router configuration tips](https://zerotier.atlassian.net/wiki/spaces/SD/pages/6815768/Router+Configuration+Tips))

## Install

* macOS
  * macOS: `brew cask install zerotier-one`
  * Linux `curl -s https://install.zerotier.com | sudo bash`
  * See https://www.zerotier.com/download.shtml
* Create a network via https://my.zerotier.com/
* Join network: eg: `sudo zerotier-cli join 8056c2e21c000001`. Access will be denied until you authorize the member.
* From the network page on https://my.zerotier.com/ under Members, check Auth on the member. It will be assigned an IP address, which you can see on the network page under Members - Managed IPs, or via `ifconfig zt0`

Network status: `sudo zerotier-cli listnetworks` 

ACCESS_DENIED means the peer hasn't been authorized on the network.
PORT_ERROR might occur after install on MacOS - a restart should fix it

## zerotier-cli: missing authentication token and authtoken.secret not found (or readable) in /var/lib/zerotier-one

must run as root, eg: `sudo zerotier-cli info`

## Reference

https://github.com/zerotier/ZeroTierOne