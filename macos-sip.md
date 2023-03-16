# macOS System Integrity Protection (SIP)

OS X El Captain introduced [System Integrity Protection](https://derflounder.wordpress.com/2015/10/01/system-integrity-protection-adding-another-layer-to-apples-security-model/) which limits the actions that the root user can perform on protected parts of the Mac operating system.

`csrutil status` will tell you if SIP is enabled.

## Disable SIP for dtrace

To enable dtrace to work with SIP:

- Enter Recovery Mode:
  - Intel: Reboot the mac. Hold ⌘R during reboot.
  - Apple silicon: Shut down. Press and hold the power button on your Mac until “Loading startup options” appears. Click Options, then click Continue. For more info, see [here](https://support.apple.com/en-au/guide/mac-help/mchl82829c17/mac).
- From the Utilities menu, run Terminal
- Run `csrutil enable --without dtrace` which should report:

  ```
  csrutil: Requesting an unsupported configuration. This is likely to break in the future and leave your machine in an unknown state.
  Turning off System Integrity Protection requires modifying system security.
  Allow booting unsigned operating systems and any kernel extensions for OS "Macintosh HD"? [y/n]:
  ```

- Choose `y` to proceed.
- You'll be asked to provide an authorized user and their password.
- Reboot the mac.

After doing this `csrutil status` will report:

```
System Integrity Protection status: unknown (Custom Configuration).

Configuration:
        Apple Internal: disabled
        Kext Signing: enabled
        Filesystem Protections: enabled
        Debugging Restrictions: enabled
        DTrace Restrictions: disabled
        NVRAM Protections: enabled
        BaseSystem Verification: enabled
        Boot-arg Restrictions: enabled
        Kernel Integrity Protections: disabled
        Authenticated Root Requirement: enabled

This is an unsupported configuration, likely to break in the future and leave your machine in an unknown state.
```
