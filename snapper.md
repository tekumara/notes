# snapper

List configs

```
snapper list-configs
```

List snapshots

```
sudo snapper list
```

Create snapshot

```
sudo snapper -c root create --description "manual snapshot"
```

Show files changes between snapshot 9 and the current state:

```
sudo snapper -c home status 9..0
```

Show diff of .bash_history contents between snapshot 9 and the current state

```
sudo snapper -c home diff 9..0  ~/.bash_history
```

Undo changes made between and the current state, ie: reverts current state to 9:

```
sudo snapper -c home undochange 9..0
```

Sync with boot loader

```
limine-snapper-sync
```
