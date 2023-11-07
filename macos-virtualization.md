# macos virtualization

## Virtualbox

Brew only has the intel binaries:

```
brew install virtualbox
```

m1 arm64 binaries aren't been actively maintained, and only [exist for older builds](https://www.virtualbox.org/wiki/Download_Old_Builds_7_0).

## UTM

To install [utmapp/UTM](https://github.com/utmapp/UTM) and [CrystalFetch](https://github.com/TuringSoftware/CrystalFetch):

```
brew install utm crystalfetch
```

Use CrystalFetch to download Windows ISOs see the [guide](https://docs.getutm.app/guides/windows/#crystalfetch).

When the VM starts press any key to boot from the installer CD/DVD otherwise the UEFI boot loader will appear.

### Configuration

To reverse mouse scrolling: UTM -> Settings -> Input -> Invert scrolling

