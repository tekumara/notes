# Lastpass CLI

## Installation

- Mac: `brew install lastpass-cli --with-pinentry`
- Ubuntu: `sudo apt-get install lastpass-cli`

[pinentry](https://www.gnupg.org/related_software/pinentry/index.en.html) is optional. It pops up a dialog box on the terminal for secure master password entry, rather than inline. It tries to take care that the entered information is not swapped to disk or temporarily stored anywhere.

NB: Installing from [source](https://github.com/lastpass/lastpass-cli) won't include man pages.

## Setup

"An agent process (`lpass`) will be spawned in the background on a first successful command, and all subsequent commands will use the agent for decryption, instead of asking a user for a password. The agent will quit after one hour, unless the LPASS_AGENT_TIMEOUT environment variable is set to an alternative number of seconds in which to quit, or 0 to never quit."

To set the timeout to 12 hours:

```
# mac osx
echo LPASS_AGENT_TIMEOUT=43200 > ~/.lpass/env

# ubuntu
echo LPASS_AGENT_TIMEOUT=43200 > ~/.config/lpass/env
```

## Usage

Login

```
lpass login email@address
```

List sites, including user name:

```
lpass ls --format '%aN (%au) [id: %ai]'
```

Use fzf to select a site, then copy it's password to the clipboard

```
lpass show -c --password $(lpass ls --format '%aN (%au) [id: %ai]' | fzf | awk '{print $(NF)}' | sed 's/\]//g')
```

Copy password for site to clipboard

```
lpass show -c --password mysite.xyz
```
