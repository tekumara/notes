# nfs

Metadata operations are the bottleneck in NFS because they require a network call, see [Potential Enhancements for NFS](https://www.usenix.org/legacy/publications/library/proceedings/fast04/tech/full_papers/radkov/radkov_html/node26.html). This is driven by the close-to-open consistency model. For a local filesystem the [metadata ops are all in memory](https://news.ycombinator.com/item?id=29397271) until fsynced.

## Close-to-open cache consistency

Ensures that any changes made to a file by one client are visible to another client the next time that file is opened.

Implementation

- Any `open()` is a round trip to the server to check the local mtime (GETATTR) against the server's mtime. If stale, it will fetch the latest version of the file.
- While the file is open any writes are buffered locally. On `close()` or `fsync()` the client flushes the updates to the server and updates the files mtime.

Why NFS chooses this model

- It avoids a network round-trip for every read() or write(); latency hits only at open()/close().
- It preserves POSIX semantics for the common pattern “open → write → close ; open → read”.
- It scales: many clients can read their cached copy at full speed until the writer closes the file.

Delegations in NFSv4 allow the server to grant a client a read- or write-delegation to a file so that future opens need not re-validate until another client asks for access, reducing open() latency even further. [Directory delegations](https://news.ycombinator.com/item?id=42174546) would be even better.

Limitations

It explicitly permits staleness while
a) another client still has the file open, or
b) another client re-opens it but skips the GETATTR due to its attribute-cache still being valid (because `acregmax` hasn't elapsed)

So two writers can overwrite each other’s edits leading to a lost update anomaly. To avoid this file locking, renames, or other synchronization mechanism is needed.

## mount options

- `-t nfs` use the NFS filesystem driver.
- `nfsvers=3` speak the NFSv3 protocol.
- `actimeo=60` cache file and directory attributes for up to 60 s on the client; fewer RPCs → faster metadata ops, but coherency is relaxed for one minute.
- `nconnect=16` open 16 parallel TCP connections to the server; [helps throughput](https://medium.com/@emilypotyraj/use-nconnect-to-effortlessly-increase-nfs-performance-4ceb46c64089) (Kernel 5.3+).
- `hard` if the server disappears, I/O blocks and retries forever (safer than “soft”, which can return I/O errors). [Be careful with soft mounts](https://serverfault.com/a/19465/126276).
- `rsize=1048576` / `wsize=1048576` 1 MiB read/write transfer size → fewer round trips and better wire efficiency.
- `async` let the client acknowledge writes before they are flushed to the server; higher performance, small risk of data loss on a crash.
- `fsc` enable the NFS client “FS-Cache” layer so data/metadata can be written to a local cache device (often /var/cache/fscache) and re-read without hitting the wire again. See [4.11. Enabling client-side caching of NFS content](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/managing_file_systems/mounting-nfs-shares_managing-file-systems#enabling-client-side-caching-of-nfs-content_mounting-nfs-shares)
- `noatime,nodiratime,relatime` fewer metadata ops
- `nocto` - [alternative heuristics for change detection](https://serverfault.com/questions/456767/why-does-the-nocto-nfs-mount-option-in-linux-not-prevent-flush-on-close)

## tools

See RPC and metadata operation counts:

```
nfsstat -c
```
