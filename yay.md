# yay

Build and install packages from the Arch User Repository (AUR).

For the most part, you can replace any `sudo pacman` commands with `yay`.

eg:

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
