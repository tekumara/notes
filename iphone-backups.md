# iPhone Backups

## System Data

System Data builds up over time (e.g., my phone accumulated 32.46 GB).

A factory reset and restore clears accumulated System Data (down to about ~5Gb on my phone).

During restore, System Data temporarily holds backup files. When apps first launch and restore their data from backup, System Data usage drops.

## Restore

### Computer vs iCloud

Computer restores are triggered from another device, eg: via Finder or iTunes or idevicebackup2.

iCloud restores are better if you want to minimise disk usage, and are easier to perform, but they are not a full restore of app data, unlike a computer restore, eg:

- local photos, Orion browser tabs and downloads are retained by a computer restore but not an iCloud restore.
- when restoring the same set of WhatsApp chats from iCloud, I ended up with 3Gb of data, vs 5Gb from a Computer restore.

### In-App Restores

Some apps have their own backup/restore mechanism with iCloud.
These will need to be triggered in-app after an iCloud restore, but aren't needed for a computer restore.

#### WhatsApp

If not using Computer backup, **create an explicit iCloud backup in WhatsApp before resetting or transferring phones**.

On restore, your security code will change. Computer restores will be treated as a phone transfer, so you'll have to reauthenticate your number.

#### Orion browser

Only syncs reading list and bookmarks to iCloud. Open tabs are NOT synced.

#### Wallet

Restored via both iCloud and computer restores (need to double check this works without an iCloud account connected) but need to be manually reactivated.

#### Signal

Computer backup nor iCloud backup does not contain chat history. Needs old phone to transfer chats to the new phone.

## References

- [Backup methods for iPhone or iPad](https://support.apple.com/en-us/108771)
