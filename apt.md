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
dpkg-query -W python python3.5
```

Show package version and dependencies

```
dpkg-query -W -f='${binary:Package}\t${Version}\t${Depends}\n' curl
```

Show package dependents

```
apt-cache rdepends curl
```

Show package dependents that are currently installed

```
apt-cache rdepends --installed curl
```

Show transitive dependencies at a dot graph

```
debtree curl
```

List packages matching wildcard

```
dpkg-query -l "python*"
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

Show all package versions, and thier url, across all repos

```
apt-cache showpkg PACKAGENAME
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
