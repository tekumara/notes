# localhost tld

## Browsers

`*.localhost` is resolved to 127.0.0.1 by Firefox and Chrome.

## MacOS

The default MacOS resolver does not resolve `*.localhost` to 127.0.0.1

Alternatives:

- Install and configure `dnsmasq` as a resolver instead ([ex1](https://gist.github.com/eloypnd/5efc3b590e7c738630fdcf0c10b68072), [ex2](https://firxworx.com/blog/it-devops/sysadmin/using-dnsmasq-on-macos-to-setup-a-local-domain-for-development/)).
- Use [domains that resolve to 127.0.0.1](https://gist.github.com/tinogomes/c425aa2a56d289f16a1f4fcb8a65ea65) eg:
  - `*.vcap.me`
  - `*.localtest.me`

## Linux

[nss-myhostname](https://www.freedesktop.org/software/systemd/man/nss-myhostname.html) ships with many distros and resolves `*.localhost` to 127.0.0.1.

To install on Debian/Ubuntu:

```
sudo apt install libnss-myhostname
```
