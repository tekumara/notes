# rsync

```sh
rsync -a --stats ----info=progress2 source dest/
```

`-a` turns on archive mode. Basically this causes rsync to recurse the directory copying all the files and directories and preserving things like case, permissions, and ownership on the target. (Note: Ownership may not be preserved if you are not logged in as the root user.) Equivalent to -rlptgoD (ie: recursive, recreate symlinks, copy permissions, copy modification times, copy group owner, copy file owner, copy character & block device files & named sockets & fifos)
the end. Without -v only errors are displayed.

A trailing slash on the source changes this behaviour to avoid creating an additional directory level at the destination. You can think of a trailing / on a source as meaning "copy the contents of this directory" as opposed to "copy the directory by name", but in both cases the attributes of the containing directory are transferred to the containing directory on the destination. In other words, each of the following commands copies the files in the same way, including their setting of the attributes of /dest/foo:

```sh
rsync -ai /src/foo /dest
rsync -ai /src/foo/ /dest/foo
```

rsync will copy hidden files/dir by default.

To copy all non-hidden files in the current directory recursively, use \*, eg:

```sh
rsync -a * /dest/
```

## Display options

- `-i` show itemized changes for every file (e.g., added, updated, deleted)
- `-v` Turn on verbose mode, ie: display name of successfully copied files and a stats summary at the end
- `--stats` detailed stats at the end
- `--info=progress2` progress bar showing speed

## Other options

| option            | description                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| --progress        | show progress of transfer                                                                               |
| --stats           | show final stats for transfer                                                                           |
| -n                | dry-run, don't do the copy                                                                              |
| -i                | list changes (if any) that are being made.                                                              |
| -r                | recursive                                                                                               |
| -l                | recreate symlinks on dest                                                                               |
| -t, --times       | copy modification times                                                                                 |
| --del or --delete | delete destination files that don't exist on source                                                     |
| -h                | output numbers in a human-readable format                                                               |
| -X                | preserve extended attributes                                                                            |
| -S                | handle sparse files efficiently so they take up less space on destination                               |
| -H                | recreate hardlinks in destination                                                                       |
| -z                | Turns on compression during the transfer. This option compresses the data when copied over the network. |

## Compare files

Show files that will have changes applied (excluding permissions and file/group owner differences)

```
rsync -nirlt --del /data/Music/ /media/LittleMac/Music/
```

eg:

```
*deleting   01 Another Town.mp3
>f+++++++++ 1-01 Fidelity.mp3
>f..tp..... 01 Daylight.mp3
```

ie: 1) a file being deleted, 2) a file being added, and 3) a timestamp (t) and permission (p) change

## Dest dir with space

This will copy into _~/Library/Application_ on the dest, not _~/Library/Application Support/_

```
rsync -ritlz ~/Library/Application\ Support/my-app beebop.local:~/Library/Application\ Support/
```

- Use quotes together with \ instead, eg: beebop.local:"~/Library/Application\ Support/".
- use `-s` on newer versions of rsync.

([ref](https://unix.stackexchange.com/questions/104618/how-to-rsync-over-ssh-when-directory-names-have-spaces))

## rsync from ext4 source to a NTFS destination

Permissions on a NTFS destination will typically differ from a ext4 source. NTFS permissions cannot be set. So using `-a` will unnecessarily attempt to set them. Therefore, it will be (slightly) more efficient to use `-rlt` rather than `-a` when copying from a ext4 source to NTFS destination.
