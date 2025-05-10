# sudo

Bash only: export apt-get for use in subshells and all scripts we invoke

```
export -f apt-get

sudo -E ...
```

> - sudo /tmp/setup-nvidia/install/system.sh
>   sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper

Configure passwordless sudo with:

```
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
```

NB: even with passwordless sudo it will ask for a password if the file you are trying to run doesn't exist.
