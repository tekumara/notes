# yay

Build and install packages from the Arch User Repository (AUR) and official repository packages.

A drop-in replacement for pacman. For the most part, you can replace any `sudo pacman` commands with `yay`.

eg:

Install, reinstall or upgrade a package:

```
yay -S <package_name>
```

This upgrades `-git` packages and re-installs packages if up to date.

Install or upgrade a package only if its not up to date (this won't upgrade `-git` packages):

```
yay -S --needed <package_name>
```

Show packages out of date:

```
pacman -Qu
```

Full system upgrade:

```
yay -Syu
```

Rebuild eternalterminal-server

```
yay -S --rebuild eternalterminal-server
```

Once installed there is no distinction between packages installed through yay or pacman. To list all packages installed from outside the sync database (ie: from AUR) use yay or pacman here:

```
pacman -Qm
```

Show build dir (defaults to ~/.cache/yay):

```
yay -Pg | jq .buildDir
```

Show info on package


```
yay -Si rustic
```
