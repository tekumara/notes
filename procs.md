# procs

Show rss for chrome

```
procs --insert rss chrome.app
```

Sum rss for chrome (NB: must all be same unit, eg: `M`)

```
procs --insert rss --only rss chrome.app| grep -o '[0-9.]\+' | paste -sd+ - | bc
```

Create custom config file (macos):

```
mkdir ~/Library/Preferences/com.github.dalance.procs/
procs --gen-config > ~/Library/Preferences/com.github.dalance.procs/config.toml
```
