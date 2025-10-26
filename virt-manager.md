# virt-manager

Uses spice or VNC to connect.

GUI-based configuration. XML-based virtual machine definitions.

Doesn't download ISO for you.

Can be used for LXC containers too.

Can connect over the network.

## virt-install

A CLI for creating XML-based VM definitions, eg:

```
virt-install --name alma9 --memory 1536 --vcpus 1 --disk path=$PWD/alma9.img,size=20 --cdrom alma9.iso --unattended
```

See also virt-builder

## Install

```
sudo pacman -S virt-manager dmidecode
```

## Troubleshooting

> Unable to connect to libvirt qemu:///system
> ..
> Failed to connect socket to '/var/run/libvirt/virtqemud-sock': No such file or directory

Start virtqemud and check its status:

```
sudo systemctl start virtqemud
sudo systemctl status virtqemud
```
