# apt package management
/etc/apt/sources.list

## Package CLI tools

Show a list of all installed packages
`dpkg --get-selections`

Finding what package owns a file
`dpkg -S FILENAME`

Display package description/summary/details of installed package
`dpkg -s PACKAGENAME`

Show package(s) and version only
`dpkg-query -W python python3.5`

Show package version and dependencies
`dpkg-query -W -f='${binary:Package}\t${Version}\t${Depends}\n' kafkacat`

List packages matching wildcard
`dpkg-query -l "python*"`

Display installed files of a package
`dpkg -L PACKAGENAME`

Install a .deb file/package
`dpkg -i PACKAGENAME`

Display package details for packages, including those available in repos that aren't installed
`apt-cache show PACKAGENAME`

Search for package or package description
`apt-cache search "Text-to-search"`

Show all package versions available across all repos, with the repo url
`apt-cache madison PACKAGENAME`

Install a specific version
`sudo apt-get install ansible=2.2.1.0-1ppa~trusty`

## Blocked updates

Blocked updates are updates that will change the status (possibly removing) another installed package, or install additional new packages.

They will not be installed if you do a `sudo apt-get upgrade`. Instead they will be listed as packages "kept back".

The following will install them and automatically resolve the status changes (eg: by removing other packages/adding new packages):

`sudo apt-get dist-upgrade`
`sudo aptitude safe-upgrade`
`sudo aptitide dist-upgrade`

For more info see below for differences between apt-get upgrade and apt-get dist-upgrade .

## Aptitude vs. apt-get

http://pthree.org/2007/08/12/aptitude-vs-apt-get/

*Historically apt-get wouldn't remove depencies when removing a package, this has now been fixed with the "apt-get autoremove’ option.
*Aptitude comes with built in interactive ncurses interface. Apt-get doesn't, but you can use dselect instead.
*Aptitude logs its actions to /var/log/aptitude, apt-get logs to /var/log/dpkg
*If you use the "interactive" UI of aptitude (by just typing "aptitude"), you can highlight a package and then press Shift + c and this will fetch the changelog for that package and show it in your default pager.
*By default, aptitude is installing also recommends programs (i.e. programs recommends by other programs), so, by defoult, it will download and install more programs/libraries than apt-get. you may solve this 'problem' by typing

`sudo aptitude --without-recommends install program_name`

## Apt-get
## !upgrade
`sudo apt-get upgrade`
           upgrade is used to install the newest versions of all packages currently installed on the system from
           the sources enumerated in /etc/apt/sources.list. Packages currently installed with new versions
           available are retrieved and upgraded; under no circumstances are currently installed packages removed,
           or packages not already installed retrieved and installed. New versions of currently installed packages
           that cannot be upgraded without changing the install status of another package will be left at their
           current version. An update must be performed first so that apt-get knows that new versions of packages
           are available.

## !dist-upgrade
`sudo apt-get dist-upgrade`
           dist-upgrade in addition to performing the function of upgrade, also intelligently handles changing
           dependencies with new versions of packages; apt-get has a "smart" conflict resolution system, and it
           will attempt to upgrade the most important packages at the expense of less important ones if necessary.
           So, dist-upgrade command may remove some packages. The /etc/apt/sources.list file contains a list of
           locations from which to retrieve desired package files. See also apt_preferences(5) for a mechanism for
           overriding the general settings for individual packages.


## Aptitude

## !Interactive mode

C - see changelog. Will display a changelog in some instances where KPackageKit can't.

## !Simulation only
`sudo aptitude -s`

## !Updating list of available packages
`sudo aptitude update`
Connects to sources in /etc/apt/sources.list and fetches list of available packages.

(this is equivalent to “apt-get update”)

## !safe-upgrade
`sudo aptitude safe-upgrade`
           Upgrades installed packages to their most recent version. Installed packages will not be removed unless
           they are unused (see the section “Managing Automatically Installed Packages” in the aptitude reference
           manual). Packages which are not currently installed may be installed to resolve dependencies unless the
           "no-new-installs" command-line option is supplied.

           It is sometimes necessary to remove one package in order to upgrade another; this command is not able
           to upgrade packages in such situations. Use the full-upgrade command to upgrade as many packages as
           possible.

## !full-upgrade
`sudo aptitude full-upgrade`
`sudo aptitude dist-upgrade`
           Upgrades installed packages to their most recent version, removing or installing packages as necessary.
           This command is less conservative than safe-upgrade and thus more likely to perform unwanted actions.
           However, it is capable of upgrading packages that safe-upgrade cannot upgrade.

       Note
           This command was originally named dist-upgrade for historical reasons, and aptitude still recognizes
           dist-upgrade as a synonym for full-upgrade.


## With a proxy

apt-get will use your http_proxy and ftp_proxy environment variables, but make sure /etc/sudoers (edit with sudo visudo) has the following line
```
Defaults env_keep = "http_proxy ftp_proxy" 
```

[ref](http://askubuntu.com/questions/7470/how-to-run-sudo-apt-get-update-through-proxy-in-commandline)

