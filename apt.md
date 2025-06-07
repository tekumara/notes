# apt package management

Update the package lists

```
apt-get update
```

Install a .deb file/package

```
dpkg -i PACKAGENAME
```

Install a specific version

```
apt-get install ansible=2.2.1.0-1ppa~trusty
```

## Inspect installed packages

Show a list of all installed packages

```
dpkg --get-selections
```

Display installed files of a package

```
dpkg -L PACKAGENAME
```

Find which package owns a file

```
dpkg -S FILENAME
```

Display package description/summary/details of installed package

```
dpkg -s PACKAGENAME
```

Show package(s) and version only

```
dpkg-query -W "*xv*"
```

Show package version and dependencies

```
dpkg-query -W -f='${binary:Package}\t${Version}\t${Depends}\n' curl
```

List packages matching wildcard

```
dpkg-query -l "python*"
```

## Inspect .deb file

List contents

```
dpkg -c file.deb
```

Manually extract

```
dpkg-deb -xv file.deb /dest/path/
```

## Inspect repo cache

Display package details for packages, including those available in repos that aren't installed

```
apt-cache show PACKAGENAME
```

Search for package or package description

```
apt-cache search "Text-to-search"`
```

Show all package versions, and their url, across all repos

```
apt-cache showpkg PACKAGENAME
```

Show package dependents

```
apt-cache rdepends curl
```

Show package dependents that are currently installed

```
apt-cache rdepends --installed curl
```

## Dependency tree

Show transitive dependencies as a dot graph

```
debtree curl
```

## Blocked updates

Blocked updates are updates that will change the status (possibly removing) another installed package, or install additional new packages.

They will not be installed if you do a `sudo apt-get upgrade`. Instead they will be listed as packages "kept back".

The following will install them and automatically resolve the status changes (eg: by removing other packages/adding new packages):

```
sudo apt-get dist-upgrade
```

## With a proxy

apt-get will use your http_proxy and ftp_proxy environment variables, but make sure /etc/sudoers (edit with sudo visudo) has the following line

```
Defaults env_keep = "http_proxy ftp_proxy"
```

[ref](http://askubuntu.com/questions/7470/how-to-run-sudo-apt-get-update-through-proxy-in-commandline)

## unmet dependencies

eg:

```
ubuntu@ip-10-97-36-125:~$ sudo apt-get install nvidia-open-570
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 nvidia-persistenced : Depends: libnvidia-cfg1 (= 575.57.08-0ubuntu1)
E: Unable to correct problems, you have held broken packages.
```

Can't meet this dependency because `libnvidia-compute-570` depends on `libnvidia-cfg1-570`:

```
$ debtree nvidia-open-570 | grep libnvidia-cfg1
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
        "libnvidia-compute-570" -> "libnvidia-cfg1-570" [color=blue,label="(= 570.148.08-1ubuntu1)"];
        "libnvidia-cfg1-570" -> "libnvidia-cfg1-any" [color=red];
        "nvidia-persistenced" -> "libnvidia-cfg1" [color=blue,label="(= 575.57.08-0ubuntu1)"];
```

Downgrade `nvidia-persistenced` so it doesn't ask for `libnvidia-cfg1`, and also pin `nvidia-open-570` at the same time:

```
sudo apt-get install nvidia-open-570=570.148.08-1ubuntu1 nvidia-persistenced=570.148.08-1ubuntu1
```

## Source

- [salsa.debian.org](https://salsa.debian.org/apt-team/apt)
- [github clone](https://github.com/live-clones/apt)
