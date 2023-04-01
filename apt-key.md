# apt-key

apt-key add has been deprecated for security reasons, see the [apt-key man page](https://manpages.debian.org/testing/apt/apt-key.8.en.html#DEPRECATION) and also this [good explanation](https://askubuntu.com/a/1307181/6127) and the [Debian Wiki - Instructions to connect to a third-party repository](https://wiki.debian.org/DebianRepository/UseThirdParty).

An alternative:

```shell
add-ppa-repo() {
    # scope exports to sub-shell
    (
        GNUPGHOME=$(mktemp -d)
        export GNUPGHOME

        package="${1#ppa:}"
        [[ -n "$package" ]] || { echo "Missing package param" && return ;}
        package_ubuntu="${package//\//-ubuntu-}"
        keyfile="/etc/apt/keyrings/$package_ubuntu.gpg"

        keyid="$2"
        [[ -n "$keyid" ]] || { echo "Missing keyid param" && return ;}

        mkdir -m 0755 -p "$(dirname "$keyfile")"

        gpg --batch --no-options --no-default-keyring --keyring "$keyfile" --keyserver hkp://keyserver.ubuntu.com:80 --recv-key "$keyid"
        source /etc/os-release
        echo "deb [signed-by=$keyfile] http://ppa.launchpad.net/$package/ubuntu $VERSION_CODENAME main" > "/etc/apt/sources.list.d/$package_ubuntu-$VERSION_CODENAME.list"

        rm -rf "$GNUPGHOME"
    )
}
```
