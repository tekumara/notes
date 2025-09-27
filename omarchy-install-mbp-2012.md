# Omarchy install on mac book pro 2012

Omarchy install on [MacBook Pro (Retina, 15-inch, Mid 2012)](https://support.apple.com/en-us/112576).

## TTY2

Press Ctrl+Opt+F2 to get a text tty.

## Keyboard layout

British Mac keyboard - select English US or Australian to get Shift+2 to generate `@` instead of `"`.

## Applications look too small

Modify ~/.config/hypr/monitors.conf and set the monitor scale to 2:

```
sed -i 's|^monitor=.*|monitor=,preferred,auto,2|' ~/.config/hypr/monitors.conf
```

## Natural scrolling

Enable natural scrolling:

```
# uncomments natural_scroll = true
sed -i '/natural_scroll/s/# *//' ~/.config/hypr/input.conf
```

## WiFi

If clicking on WiFi does nothing, and `ip link` will returns `wlan0` device, then you are missing WiFi device drivers.

### Broadcom b43 firmware install

See [Broadcom b43 firmware install](https://github.com/tekumara/setup-arch/blob/main/install/b43firmware.md).

## Enable SSHD

To enable remote logins using password:

```
sudo systemctl enable sshd
sudo systemctl start sshd
```

## GPU

The 2012 MacBook Pro has two graphics processors:

- Intel integrated GPU (for basic graphics)
- Dedicated NVIDIA [GeForce GT 650M](https://en.wikipedia.org/wiki/GeForce_600_series) GPU (for better performance)

Without working drivers, the dedicated GPU can't manage power correctly, preventing the laptop from suspending.

### The NVIDIA Driver Problem

Omarchy comes with modern NVIDIA drivers (nvidia-dkms), but these don't work with the older GeForce GT 650M which is only supported by [legacy NVIDIA 470.xx drivers](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/). However the legacy drivers only support the EGLStreams buffer api and not the modern [GBM buffer API that Hyprland](https://wiki.archlinux.org/title/Wayland#Requirements) requires.

The open-source [Nouveau](https://wiki.archlinux.org/title/Nouveau) drivers provide power management, allowing suspend/resume. They support the GBM buffer API, although I'm yet to test that.

To switch to Nouveau drivers, remove the nvidia drivers:

1. Edit `/etc/mkinitcpio.conf` and remove these modules from the `MODULES=(...)` line:

   - `nvidia`
   - `nvidia_modeset`
   - `nvidia_uvm`
   - `nvidia_drm`

2. Uninstall the NVIDIA drivers:

   ```
   sudo pacman -Rns nvidia-dkms lib32-nvidia-utils nvidia-utils
   ```

The reboot the Nouveau kernel module will run.

## Blank screen

Check logs:

```
journalctl | grep -i hypr
```

Check displays:

```
lspci -d ::03xx -nn
ls -l /dev/dri/by-path
```

Enable logging:

```
echo debug:disable_logs = false >> ~/.config/hypr/hyprland.conf
```

Check logs:

```
ls $XDG_RUNTIME_DIR/hypr/*/hyprland.log
```

See [Hyprland Wiki Multi-GPU](https://wiki.hypr.land/Configuring/Multi-GPU/)

## Screen saver

Modify timeouts:

```
nvim ~/.config/hypr/hypridle.config
```

## Suspend / resume

Suspend is issued via laptop lid close, `systemctl suspend` or Menu -> System -> Suspend. By default this will trigger deep aka s3 aka suspend to ram.

Suspend / resume messages will be issued by ACPI and visible in dmesg/journalctl.

If not resuming from suspend use the Nouveau drivers (see [GPU](#gpu) above).

Alternatively, switch to s2idle however this doesn't save as much battery because the dedicated GPU will still be running.

### Check sleep states

Check [sleep states](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method):

```
cat /sys/power/mem_sleep
s2idle [deep]
```

ie: available modes are s2idle and deep, and deep will be used. deep = s3 (suspend to ram).

To check if [S0ix is advertised by the UEFI](https://docs.anduinos.com/Skills/System-Management/Diagnose-Sleep.html#21-querying-acpi-tables):

```
sudo pacman -S acpica
cd /tmp
sudo acpidump -b
iasl -d *.dat 2> /dev/null

# if 1 is returns, S0ix is supported
grep "Low Power S0 Idle" facp.dsl
```

If not supported then s2idle will be a shallow software-based suspend.

See [Diagnose Sleep on Linux](https://docs.anduinos.com/Skills/System-Management/Diagnose-Sleep.html) for more info.

## Boot loader

MBP 10.1 uses EFI. Omarchy installs a EFI boot partition mounted at /boot containing [Limine](https://wiki.archlinux.org/title/Limine). See also [Docs Addition: Limine + Snapper](https://github.com/basecamp/omarchy/issues/1068). GRUB, systemd-boot, and rEFInd are all alternatives to Limine.

TODO: auto-boot into omarchy

## Troubleshooting

For hardware issues check `dmesg`.
