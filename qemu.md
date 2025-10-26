# qemu

qemu-base is headless

qemu-desktop = qemu-base + UI, audio, spice
qemu-full = qemu-desktop + multiple archs

## Install

Use qemu-desktop + the git master branch to get latest fixes:

```
yay -Sy qemu-desktop quickemu-git
```

## quickget

Download Windows ISO, create unattended install with virtio drivers and spice, and a qemu conf file:

```
quickget windows 11
```

Automatically logs in as `Quickemu` user (password is `quickemu`).

If you see

> Microsoft blocked the automated download request based on your IP address.

Then manually download the latest ISO using the [direct download links for Windows 11 25H2](https://pureinfotech.com/windows-11-25h2-enablement-package-iso-direct-download/).

Windows 11 will consume 8G RAM and 14GB qcow2 disk space (~35GB in Windows) on a fresh install.

## quickemu

Start:

```
quickemu --vm windows-11.conf
```

Kill:

```
quickemu --vm windows-11.conf --kill
```

Full-screen (sdl display): `CTRL+ALT+F`

To share clipboard requires using spice (nb: has a higher resolution display)

```
quickemu --vm windows-11.conf --display splice
```
