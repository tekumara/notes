# cloud init

cloud-init runs as root, to view the logs:

```
sudo less /var/log/cloud-init-output.log
```

view user data for current instance:

```
sudo cat /var/lib/cloud/instance/user-data.txt
```

(previous instance instantiations are available in /var/lib/cloud/instances/)

## Package modules

The [Package Update Upgrade Install](https://cloudinit.readthedocs.io/en/latest/reference/modules.html#package-update-upgrade-install) module can be specified in cloud config and will run before any user data scripts.

## User data

User data scripts (`text/x-shellscript`) are executed during first boot at "rc.local-like" level ie: very late in the boot sequence ([ref](https://github.com/canonical/cloud-init/blob/main/doc/userdata.txt)).

User data scripts are stored in _/var/lib/cloud/instance/scripts/_. A single script is stored with the filename `part-001`.
Scripts have `rwx` for root only.

## MIME multi-part

Each part in a [mime multi-part file](https://cloudinit.readthedocs.io/en/latest/explanation/format.html#mime-multi-part-archive) will be stored on disk in _/var/lib/cloud/instance/scripts/_ using the filename provided in the part, or as files named `part-XXX` if no filename is specified. `text/x-shellscript` parts are executed in alphanumeric order according to their filename **as stored on disk**.

If one script has a non-zero exit code, cloud init will still run the other scripts.

See [cloud-init-example](https://github.com/ukayani/cloud-init-example) for an ordering example.

## Write arbitrary files

Write arbitrary files via the [`write_files` key](https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files) in the cloud-config file. ([example](https://cloudinit.readthedocs.io/en/latest/reference/examples.html#writing-out-arbitrary-files)).
