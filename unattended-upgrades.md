# unattended upgrades (debian/ubuntu)

Services:

- unattended-upgrades.service: Unattended Upgrades Shutdown. Just a helper that checks if an unattended upgrade is in progress during shutdown. If it is, the script will wait for the upgrade to finish before shutting down the system.
- [apt-daily.service](https://github.com/Webconverger/webc/blob/master/lib/systemd/system/apt-daily.service) - Daily apt download activities. Runs `/usr/lib/apt/apt.systemd.daily update`
- [apt-daily-upgrade.service](https://github.com/Webconverger/webc/blob/master/lib/systemd/system/apt-daily-upgrade.service) - Daily apt upgrade and clean activities. Runs `/usr/lib/apt/apt.systemd.daily install` (which runs unattended-upgrade).

Timers:

- [apt-daily.timer](https://github.com/Webconverger/webc/blob/master/lib/systemd/system/apt-daily.timer): apt-daily.service daily at 6, 18 + randomised delay of 12h.
- [apt-daily-upgrade.timer](https://github.com/Webconverger/webc/blob/master/lib/systemd/system/apt-daily-upgrade.timer): apt-daily-upgrade.service daily at 6 + randomised delay of 60 mins.

These timers are [persistent](https://www.freedesktop.org/software/systemd/man/systemd.timer.html#Persistent=) ie: they'll run on startup (with the randomised delay) if they missed a trigger while the system was powered down.

Service logs (shows when the service was run):

```
journalctl -u apt-daily-upgrade
```

Start the apt-daily-upgrade service now:

```
sudo systemctl start apt-daily-upgrade
```

## apt.systemd.daily

The [apt.systemd.daily shell script](https://github.com/Webconverger/webc/blob/master/usr/lib/apt/apt.systemd.daily) can:

- `update` package lists
- `install` packages, ie: run unattended upgrade

To run install:

```
sudo /usr/lib/apt/apt.systemd.daily install
```

The `install` subcommand will:

1. [abort](https://github.com/Webconverger/webc/blob/5ea9840f4c9e5bfeb8ee29de6e71d40dd387814b/usr/lib/apt/apt.systemd.daily#L332) if `APT::Periodic::Enable = 0`
1. [compare the stamp file's timestamp](https://github.com/Webconverger/webc/blob/5ea9840f4c9e5bfeb8ee29de6e71d40dd387814b/usr/lib/apt/apt.systemd.daily#L470) to `APT::Periodic::Unattended-Upgrade`. This is the minimal interval between runs in days, eg: `1` = every day, `0` = disabled. The stamp file is _/var/lib/apt/periodic/upgrade-stamp_.
1. If the time stamp is stale, run [unattended-upgrade](#unattended-upgrade).
1. cleans up the cache

Config locations:

- `APT::Periodic` stored in _/etc/apt/apt.conf.d/20auto-upgrades_
- `Unattended-Upgrade` stored in _/etc/apt/apt.conf.d/50unattended-upgrades_

To dump config:

```
apt-config dump APT::Periodic
apt-config dump Unattended-Upgrade
```

To enable verbose logging for apt daily:

```
echo 'APT::Periodic::Verbose "1";' | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades
```

## unattended-upgrade

[unattended-upgrade](https://github.com/mvo5/unattended-upgrades/blob/master/unattended-upgrade) installs a [subset of upgradeable packages](#upgradeable-packages) from the current package list. It does not automatically update the package list (ie: run `apt update`).

To run in dry run mode:

```
sudo unattended-upgrades --dry-run
```

unattended-upgrade by default does not output to stdout but logs to:

- _/var/log/unattended-upgrades/unattended-upgrades.log_
- _/var/log/unattended-upgrades/unattended-upgrades-dpkg.log_ for package updates

To output to stdout, run in verbose mode:

```
sudo unattended-upgrades --dry-run -v
```

To enable debug mode:

```
sudo unattended-upgrades --dry-run -v -d
```

To set verbose mode via configuration:

```
echo 'Unattended-Upgrade::Verbose "true";' | sudo tee -a /etc/apt/apt.conf.d/50unattended-upgrades
```

Whilst running its pid will be stored in _/var/run/unattended-upgrades.pid_.

## upgradeable packages

List all upgradable packages:

```
apt list --upgradable
```

According to the motd:n

```
/etc/update-motd.d/90-updates-available
```

unattended-upgrades only installs [upgradeable packages](https://github.com/mvo5/unattended-upgrades/blob/master/unattended-upgrade#L1789) from origins configured in `Unattended-Upgrade::Allowed-Origins` (see _/etc/apt/apt.conf.d/50unattended-upgrades_). By default this is only security updates, eg:

> Allowed origins are: o=Ubuntu,a=focal, o=Ubuntu,a=focal-security, o=UbuntuESMApps,a=focal-apps-security, o=UbuntuESM,a=focal-infra-security

If a package is held back it won't be upgraded.

List security updates:

```
apt list --upgradable | grep security
```

## Resources

- [Stack Overflow: How to run unattended-upgrades not daily but every few hours](https://unix.stackexchange.com/a/541426/2680)
- [Disable the timer on boot](https://github.com/geerlingguy/packer-boxes/issues/3#issuecomment-219257091)
- [Stop and disable the systemd units](https://github.com/actions/runner-images/pull/1761/files)
- [Randomly getting 'Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend)' through multiple runs](https://github.com/actions/runner-images/issues/1120)
- Check lock [using fuser](https://github.com/geerlingguy/packer-boxes/issues/7#issuecomment-425641793) or [inspecting stderr](https://github.com/actions/runner-images/blob/a2e5aef/images/linux/scripts/base/apt-mock.sh)
