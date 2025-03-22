# macos virtualization utm

## Install

To install [utmapp/UTM](https://github.com/utmapp/UTM) and [CrystalFetch](https://github.com/TuringSoftware/CrystalFetch):

```
brew install utm crystalfetch
```

Use CrystalFetch to download Windows ISOs see the [guide](https://docs.getutm.app/guides/windows/#crystalfetch).

When the VM starts press any key to boot from the installer CD/DVD otherwise the UEFI boot loader will appear.

## Configuration

To reverse mouse scrolling: UTM -> Settings -> Input -> Invert scrolling.

VM specific config can only be accessed when the VM is topped. Switch windows to access the VM configuration using `⌘+~` because the config widow doesn't appear in the menu bar.

## Sharing

Install the guest tools for your OS, eg: [Windows](https://docs.getutm.app/guest-support/windows/). NB: must be run as administrator.

Select the folder to share from the Shared Folder icon on the top right of the running VM. This can be changed at any time.

This folder will be now available as Z:\

## Disk space

The qcow2 image isn't preallocated and will grow and shrink automatically as the VM disk usage changes.

To reclaim Windows disk space, within Windows go to System - Storage - Temporary Files - Remove files.

## Troubleshooting

### Keyboard not working

Sometimes the `c` key press is not recognised. Move the mouse out of the window and back again.

Seems to happen a lot when in a VS Code window within Windows. Try switching to other windows apps first and typing.

### Z:\ is not accessible

1. Check if you can access the directory via [http://localhost:9843/](http://localhost:9843/). If so this means you have connectivity.
1. If you have connectivity then the problem is the mount. To manually mount: `net use * http://localhost:9843/`
1. If the mount succeeds but no files are found when listing the directory then there are file names Windows doesn't like. Check for file names containing a `%` or other special characters.

### No internet access from guest

1. Switch the VM from [Shared to Bridged networking](https://github.com/utmapp/UTM/issues/3245#issuecomment-1076833025). See also [#3802](https://github.com/utmapp/UTM/issues/3802).
1. For `Bridged Interface` change `Automatic` to your stable network interface. If left as `Automatic` it may select an ephemeral interface (eg: a VPN).
