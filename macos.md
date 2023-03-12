# MacOS

## Losing internet/network connection

The WiFi was still connected. Going to `System Preferences -> Network -> Wi-Fi -> Advanced -> TCP/IP -> Renew DHCP Lease -> OK` fixed it for me.

## External USB drive with exfat partition not mounting

If the partition isn't mounting it may be because `fsck_exfat` is running in the background, check with `ps -Af | grep fsck`
`fsck_exfat` will run when the disk wasn't cleanly unmounted previously.
Just wait until it has finished cleaning the partition.

Also check Disk Utility. Try and manually mount it from there. If you get `com.apple.DiskManagement.disenter error -119930872.` try and run First Aid, which will start fsck.

## Emojis for keys

⌘ Command (or Cmd) - this is the place of interest emoji
⇧ Shift
⌥ Option (or Alt)
⌃ Control (or Ctrl)

## Delete

Fn + Delete

## Temperature and fan speed

```
sudo powermetrics --samplers smc -i1 -n1
```

## Bluetooth name

Set using

```
scutil --set ComputerName mymac
```

Connect your bluetooth device. After pairing you can revert to the old name if needed for your enterprise connectivity software.

## Quarantine

To remove the quarantine flag:

```
xattr -d com.apple.quarantine <your-file>
```

## Installing updates

To install recommended update:

```
softwareupdate -i -r
```

eg:

```
$ softwareupdate -i -r
Software Update Tool

Finding available software

Downloaded Command Line Tools for Xcode
Installing Command Line Tools for Xcode
```

## You are making changes to your Certificate Trust Settings

Look at the process tree for the `/usr/bin/security` process to see what's calling it, eg:

```
ps -Af | grep "security"
pstree -p 17714
```

You are making changes to your Certificate Trust Settings = cert is being deleted
You are making changes to the System Certificate Trust Settings = cert is being added

## List USB devices

```
system_profiler SPUSBDataTypesystem_profiler SPUSBDataType
```

## Find which process owns a window

See [lswin.py](https://github.com/glyph/mac_list_windows_pids)

## Logs

Stream logs for docker:

```
pred='process matches ".*(ocker|vpnkit).*" || (process in {"taskgated-helper", "launchservicesd", "kernel"} && eventMessage contains[c] "docker")'
/usr/bin/log stream --style syslog --level=debug --color=always --predicate "$pred"
```

NB: `contains[c]` means "contains case insensitive". See [Predicate Format String Syntax](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html)

Collect the last hour of logs (1h) in a file:

```
/usr/bin/log show --debug --info --style syslog --last 1h --predicate "$pred" >/tmp/logs.txt
```

Or use the console ([example](https://docs.docker.com/desktop/troubleshoot/overview/#check-the-logs)).

