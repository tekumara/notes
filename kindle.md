# kindle

Connect via USB. It should auto-mount.

## Troubleshooting

If not auto-mounted:

1. Check connected: `system_profiler SPUSBDataType`. If not showing try a different cable.
1. Check appears as a disk: `diskutil list`
1. Manually mount: `diskutil mount /dev/disk4` - if you get "SUIS premount dissented" this may mean your organisation has disallowed mounting external storage via a [configuration profiles](https://developer.apple.com/documentation/devicemanagement) (see `sudo profiles show` or +SPACE "Configuration profiles" and look for profiles that disable media/storage)
