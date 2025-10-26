# xen

Xen is a thin hypervisor that takes control before any OS runs. Originally based on [paravirtualisation](<https://wiki.xenproject.org/wiki/Paravirtualization_(PV)>) which modified the guest OS with kernel and driver support for virtualisation. It now supports hardware-asssited virtualisation (HVM) for CPU virtualisation. It integrates QEMU for disk, network etc. virtualisation. It's fast, but so is QEMU+KVM which has never required modified guest OS kernels.

See

- [Understanding the Virtualization Spectrum](https://wiki.xenproject.org/wiki/Understanding_the_Virtualization_Spectrum)
- [Difference between QEMU-KVM and Xen Virt-manager](https://superuser.com/a/170815/12874)
- [Xen or KVM?](https://www.reddit.com/r/debian/comments/k9zgh5/xen_or_kvm/)
