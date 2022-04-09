# kim

```
kim builder install --selector kubernetes.io/hostname=k3d-kim-server-0
```

On init, kim will create some shared mounts in _/tmp_, _/var/lib/buildkit/_, and _/var/lib/rancher_, eg:

```
_DIR=/tmp
sh -c "(if mountpoint $_DIR; then set -x; nsenter -m -p -t 1 -- env PATH=$_PATH sh -c 'mount --make-rshared $_DIR'; fi) || true"

if mountpoint $_DIR; then set -x; nsenter -m -p -t 1 -- env PATH=$_PATH sh -c 'mount --make-rshared $_DIR'; fi
```
