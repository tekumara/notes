# tar & zip

## tar

list files in archive:

```
tar -tvf archive.tar.gz
```

### compress

compress with gzip:

```
tar -zcvf archive.tar.gz --exclude ".idea" <files>
```

compress with xz:

```
tar -cfJ archive.tar.xz <files>
```

compress with bzip2:

```
tar -cfj archive.tar.bz2 <files>
```

compress with zstd:

```
tar --use-compress-program zstd -T0 -cf cache.tzst -P -C /home/runner/work/aec/aec --files-from manifest.txt
```

create archive in current dir, but change to /tmp before compression so files aren't prefixed with /tmp/

```
tar -zcvf spark-apps.tar.gz -C /tmp spark-apps
```

The archive will contain

```
spark-apps/
spark-apps/application_1522545774711_0001
spark-apps/application_1522545774711_0002
```

## decompress

decompress in the current directory, and keep the original file:

```
tar -zxvf /tmp/archive_name.tar.gz
```

decompress (in this case bzip2)

```
tar -xvf archive_name.bz2
```

decompress to /tmp

```
tar -xvf archive_name.tar.gz -C /tmp
```

decompress a single file (stackit) from the archive

```
tar zxf /tmp/stackit.tar.gz -C /usr/bin stackit    
```

decompress first lines of a tar.bz2

```
tar -xOjf file.tar.bz2 | head
```

decompress but remove leading directory (in this case the first 2 path components)

```
tar -xvf archive_name.tar.gz -C /tmp --strip-components=2
```

`--keep-newer-files` won't overwrite files with the same age or newer
but tar is not great for multiple files, because it doesn't have an index so can't easily efficiently skip large files in the archive when they already exist, so there will still be a perf hit when a file already exists.

tar doesn't have a nice syntax for extracting multiple tars in one command see http://stackoverflow.com/questions/583889/how-can-you-untar-more-than-one-file-at-a-time

## zip

compress:

```
 zip -r archive_name.zip directory_to_compress
```
