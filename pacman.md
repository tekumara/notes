# pacman

Search **installed** packages containing `nvidia` in name or description

```
pacman -Qs nvidia
```

Search for packages in the sync databases (includes uninstalled) containing regex `stow` in name or description:

```
pacman -Ss stow
```

List files installed by broadcom-wl:

```
pacman -Ql broadcom-wl
```

Uninstall nvidia and dependencies, don't keep backups anything:

```
sudo pacman -Rns nvidia-dkms
```

Sync (ie: update) package database

```
sudo pacman -Sy
```

Show packages out of date:

```
pacman -Qu
```

Full system upgrade:

```
sudo pacman -Syu
```

## Make dependencies

When a package has a make dependency it is needed to build the package, but not install it.

eg: broadcom-wl dependencies are:

> linux
> broadcom-wl-dkms=6.30.223.271 (_make_)
> linux-headers (_make_)

ie: it is built from broadcom-wl-dkms, but this isn't added during install.
