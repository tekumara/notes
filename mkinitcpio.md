# mkinitcpio

Build ramdisk on a system with limine:

```
sudo limine-mkinitcpio
```

## Troubleshooting

```
==> ERROR: module not found: 'nvidia'
==> ERROR: module not found: 'nvidia_modeset'
==> ERROR: module not found: 'nvidia_uvm'
==> ERROR: module not found: 'nvidia_drm'
==> Generating module dependencies
==> Creating zstd-compressed initcpio image
==> WARNING: errors were encountered during the build. The image may not be complete.
==> Creating unified kernel image: '/tmp/staging_uki.efi'
  -> Using cmdline file: '/tmp/kernel-cmdline'
==> Unified kernel image generation successful
 Error: mkinitcpio failed for kernel 6.16.8-arch2-1, skipping.
```

During the post-transaction mkinitcpio run, it still tried to bundle the NVIDIA kernel modules `nvidia`, `nvidia_modeset`, `nvidia_uvm`, and `nvidia_drm`. Those names normally come from the `MODULES=(...)` stanza in `/etc/mkinitcpio.conf`.

Strip the NVIDIA leftovers from your mkinitcpio config and then rerun mkinitcpio.
