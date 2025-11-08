# iPhone Backups

## System Data

System Data builds up over time on your phone. Example: my phone accumulated 32.46 GB of System Data.

A factory reset and restore will clear out accumulated System Data.

During restore System Data temporarily holds backup files during the restore process. Apps rehydrate from backup on first launch, causing System Data usage to drop.

## Restore

### Computer vs iCloud

Computer restores are triggered from another device, eg: via Finder or iTunes or idevicebackup2.

iCloud restores are better if you want to minimise disk usage, and are easier to perform, but they are not a full restore of app data, unlike a computer restore, eg: local photos, Orion browser tabs are retained by a computer restore but not an iCloud restore.

### In-App Restores

Some apps have their own restore mechanism from iCloud.
These will need to be triggered after an iCloud restore, but aren't needed for a computer restore.

#### WhatsApp

WhatsApp chats and media are backed up and restored in app. **Make an explicit backup in WhatsApp before resetting or transferring phones**.

On restore, your security code will change. Computer restores will be treated as a phone transfer, so you'll have to reauthenticate your number.

#### Orion browser

Only syncs reading list and bookmarks to iCloud. Does NOT sync open tabs.

### Wallet

Stored temporarily on iCloud between resets/transfers. NOT included in computer backups.

## References

- [Backup methods for iPhone or iPad](https://support.apple.com/en-us/108771)
