# iphone on linux

## libimobiledevice

Install

```
sudo pacman -S libimobiledevice usbmuxd
```

- [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice): The core library for communicating with iOS devices.
- [usbmuxd](https://github.com/libimobiledevice/usbmuxd): A daemon that manages connections to Apple devices via USB.

Test:

```
ideviceinfo
```

See the [other utilities](https://www.mankier.com/package/libimobiledevice-utils).

## pymobiledevice3

Similar to libimobiledevice but has some high level convenience commands and support for developer tools.

pymobiledevice3 needs usbmuxd (see above).

Install:

```
uv tool install pymobiledevice3
```

List devices:

```
pymobiledevice3 usbmux list
```

## Filesystem access

Media - /var/mobile/Media on the device. Includes photos in DCIM. Accessed via Apple File Connection (AFC).
Apps - Application documents or sandbox. The app must allow file sharing (UIFileSharingEnabled in Info.plist). Access via com.apple.mobile.house_arrest
Root - Requires jailbroken device with the AFC2 service.

### Mounting via ifuse

[ifuse](https://github.com/libimobiledevice/ifuse) allows you to mount the filesystem of an iOS device.

Supports Media, Apps, and Root access.

### Media

Via pymobiledevice3:

```
❯ pymobiledevice3 afc ls /
/
/Podcasts
/Airlock
/Downloads
/CloudAssets
/Books
/Photos
/Music
/EnhancedAudioSharedKeys
/Recordings
/PhotoStreamsData
/ManagedPurchases
/Espresso
/DCIM
/iTunesRestore
/iTunes_Control
/MediaAnalysis
/PhotoData
/Purchases
/AirFair
```

Via [afcclient](https://www.mankier.com/1/afcclient) repl:

```
afcclient
```

#### Media via gvfs

Creates a fuse mount in "$XDG_RUNTIME_DIR/.gvfs" and displayed in compatible file managers.

Install gvfs-afc (and gvfs-gphoto2?)

### Apps

Details of Google Maps:

```
pymobiledevice3 apps query com.google.Maps
```

Access Orion browser downloads via shell:

```
pymobiledevice3 apps afc --documents com.kagi.kagiiOS
```

Or mount:

```
ifuse --container com.kagi.kagiiOS /mnt/iphone
```

List apps that can be accessed via filesystem (ie: have UIFileSharingEnabled)

```
 ❯ ifuse --list-apps
"CFBundleIdentifier","CFBundleVersion","CFBundleDisplayName"
"com.apple.Fitness","1.0","Fitness"
"com.spotify.client","909101231","Spotify"
"com.kagi.kagiiOS","1","Orion"
```

InstallationLookupFailed means the appid is wrong or the app doesn't have UIFileSharingEnabled.

For more info see [ifuse Usage](https://github.com/libimobiledevice/ifuse?tab=readme-ov-file#usage).

To manage the installation of apps see [ideviceinstaller](https://github.com/libimobiledevice/ideviceinstaller).

## Developer Mode

Enable developer mode:

```
idevicedevmodectl enable

# or

pymobiledevice3 amfi enable-developer-mode
```

This only works if your [device doesn't have a passcode](https://github.com/doronz88/pymobiledevice3/issues/339#issuecomment-1266122808). Instead go to [Settings > Privacy & Security > Developer Mode on your device](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device#Enable-Developer-Mode) and enable it. This will restart the device. If this option isn't visible enable it using:

```
idevicedevmodectl reveal

# or

pymobiledevice3 amfi reveal-developer-mode
```

## Developer tools

On Developer mode is enabled, start a tunnel to use the developer tools:

```
sudo $(which pymobiledevice3) remote tunneld
```

List user installed application bundles (un-chrooted):

```
pymobiledevice3 developer dvt ls /private/var/containers/Bundle/Application --tunnel ''
```

### Developer Disk Image (DDI)

The DeveloperDiskImage (DDI) is a signed disk image provided by Apple that contains developer tools and services for iOS devices.

```
pymobiledevice3 developer core-device
Usage: pymobiledevice3 developer core-device [OPTIONS] COMMAND [ARGS]...

  Access features exposed by the DeveloperDiskImage

Options:
  -h, --help  Show this message and exit.

Commands:
  get-device-info         Get device information
  get-display-info        Get display information
  get-lockstate           Get lockstate
  launch-application      Launch application
  list-apps               Get application list
  list-directory          List directory at given domain-path
  list-processes          Get process list
  propose-empty-file      Write an empty file to given domain-path
  query-mobilegestalt     Query MobileGestalt
  read-file               Read file from given domain-path
  send-signal-to-process  Send signal to process
  sysdiagnose             Execute sysdiagnose and fetch the output file
  uninstall               Uninstall application
```

First download the correct DDI for your device's iOS version if it doesn't have it cached locally, and mount it:

```
pymobiledevice3 mounter auto-mount
```

List user-installed apps and their path

```
pymobiledevice3 developer core-device list-apps
[
     ...
        {
        "bundleIdentifier": "net.whatsapp.WhatsApp",
        "bundleVersion": "810014850",
        "isAppClip": false,
        "isDeveloperApp": false,
        "isFirstParty": false,
        "isHidden": false,
        "isInternal": false,
        "isRemovable": true,
        "name": "\u200eWhatsApp",
        "path": "/private/var/containers/Bundle/Application/A2E2F67A-57EC-46BD-AEA5-3AADBC27E069/WhatsApp.app",
        "version": "25.30.73"
    }
]
```

## Backups

Encrypted iPhone backups contain WiFi passwords. These aren't in regular unencrypted backups.

Backup password is for encryption and unique to the device.

Backup to the dir `iphone-backup` (takes ~5 mins)

```
time idevicebackup2 backup iphone-backup
```

If the direcrtory is empty it will take a full backup, otherwise its an incremental backup.

iCloud backups Apps & Data, Settings, and Wallet (ie: cards). Readding your cards will require entering their security code.

## Restore

Restore:

```
idevicebackup2 -i restore --remove --system --settings iphone-backup-full
```

`--remove` is needed to restore apps see [#664](https://github.com/libimobiledevice/libimobiledevice/issues/1664#issuecomment-3463270836) which will be asynchronously restored after the device boots. `--system --settings` [mimic iTunes](https://github.com/libimobiledevice/libimobiledevice/issues/841#issuecomment-529468091).

> ERROR: Could not receive from mobilebackup2 (-4)

Try resetting the phone into a clean state and then progress until you reach the [Transfer Your Apps & Data screen](https://support.apple.com/en-in/105132#:~:text=Restore%20or%20transfer%20your%20data%20and%20apps). Select `From Mac or PC` then run idevicebackup2 restore.

See also [iPhone Backups](iphone-backups.md).

### Whatsapp

Install [WhatsApp-Chat-Exporter](https://github.com/KnugiHK/WhatsApp-Chat-Exporter):

```
uv tool install whatsapp-chat-exporter --with git+https://github.com/KnugiHK/iphone_backup_decrypt
```

Extract whatsapp database from iphone backup into current dir (~2 mins):

```
wtsexporter -i -c -b ~/Documents/iphone-backup/00008020-001058E80A08002E/
```

See also

- [How to decrypt an encrypted Apple iTunes iPhone backup?](https://stackoverflow.com/a/13793043/149412)

## Logs

Tail logs matching anything matching `backup`:

```
idevicesyslog -m backup
```

## Troubleshooting

> ERROR: No device found!

Ensure the usbmuxd service has started. It should [automatically be started](https://wiki.archlinux.org/title/IOS#Usbmux_daemon) by udev when an device is plugged in.

> usbmuxd[7501]: libusb: error [get_usbfs_fd] libusb couldn't open USB device /dev/bus/usb/001/003, errno=13
> usbmuxd[7501]: libusb: error [get_usbfs_fd] libusb requires write access to USB device nodes
> usbmuxd[7501]: [14:08:34.973][2] Could not open device 1-3: LIBUSB_ERROR_ACCESS
> usbmuxd[7501]: [14:08:34.973][3] Initialization complete

This can happen if usbmuxd is installed, and manually started, whilst a device is plugged in.
Reconnect the device so usbmuxd is triggered by the udev rule.

> ERROR: Could not connect to lockdownd: Password protected (-17)

You haven't paired yet. On the device follow the "Trust This Computer?" popup to trust your computer.

> pymobiledevice3.exceptions.PasswordRequiredError

The phone is locked. Unlock it.

> pymobiledevice3.exceptions.TunneldConnectionError

Start a tunnel.

> Underlying error: The operation couldn’t be completed. (OSStatus error -36 - Failed to write backup file: 28) (NSOSStatusErrorDomain/-36).

Try the backup again.

## References

- [ArchWiki iOS](https://wiki.archlinux.org/title/IOS)
