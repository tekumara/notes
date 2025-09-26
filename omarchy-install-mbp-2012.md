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

Perform an offline install of the [broadcom wireless firmware](https://wiki.archlinux.org/title/MacBookPro10,x#Wi-Fi) as follows.

On a separate computer:

1. Download from mirror [b43-fwcutter](https://archlinux.org/packages/core/x86_64/b43-fwcutter/)
1. Download snapshot and sources of the AUR [b43-firmwave package](https://aur.archlinux.org/packages/b43-firmware)
1. Copy to USB

On the target:

1. Mount the USB: `sudo mkdir -p /mnt/usb && sudo mount /dev/sdb1 /mnt/usb`
1. Install b43-fwcutter: `sudo pacman -U --noconfirm b43-fwcutter-019-6-x86_64.pkg.tar.zst`
1. Make and install the b43-firmware package:

   ```
   tar -xvf /mnt/usb/b43-firmware.tar -C /tmp/
   cp /mnt/usb/broadcom-wl-6.30.163.46.tar.bz2 /tmp/b43-firmware/
   cd /tmp/b43-firmware
   # point source at local file so we don't try to download it
   sed -i -E 's|https://.*/(broadcom-wl.6.30.163.46.tar.bz2)|\1|' PKGBUILD
   makepkg -si --noconfirm
   ```

1. Restart
1. Run `impala`, or click on the WiFi network icon top right, and connect to your WiFi network.

## Enable SSHD

To enable remote logins using password:

```
sudo systemctl enable sshd
sudo systemctl start sshd
```

## GPU

NVIDIA GeForce GT 650M GPU is supported by the NVIDIA 470.xx Legacy drivers. See [Unix Driver Archive](https://www.nvidia.com/en-us/drivers/unix/).

Remove latest drivers and install 390 which supports [GeForce 600 series](https://github.com/korvahannu/arch-nvidia-drivers-installation-guide):

```
pacman -Rns nvidia-dkms lib32-nvidia-utils nvidia-utils
yay -S nvidia-390xx-dkms nvidia-390xx-utils lib32-nvidia-390xx-utils
```

## Blank screen

Check logs:

```
journalctl | grep -i hypr
```

Check displays:

```
lspci -d ::03xx
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

## Troubleshooting

For hardware issues check `dmesg`.

## Suspend / resume

Won't resuming from suspend (issued via laptop lid close, `systemctl suspend` or Menu -> System -> Suspend).

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

## Not waking from sleep

To fix waking from s3 sleep install the nvidia 390 drivers.

Alternatively, switch to s2idle however this doesn't save as much battery in theory (I haven't verified this empirically).

## Boot loader

MBP 10.1 uses EFI. Omarchy installs a EFI boot partition mounted at /boot containing [Limine](https://wiki.archlinux.org/title/Limine). See also [Docs Addition: Limine + Snapper](https://github.com/basecamp/omarchy/issues/1068). GRUB, systemd-boot, and rEFInd are all alternatives to Limine.

TODO: auto-boot into omarchy
