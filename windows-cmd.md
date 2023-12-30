# windows cmd

## Windows Terminal

Can launch

- Windows PowerShell
- Command Prompt

## which

The equivalent of which on Windows 11 is:

- `where` - NB: requires the trailing `.exe` when run from PowerShell.
- `Get-Command` in PowerShell.

## ssh

Windows 11 ships with OpenSSH:

```
where ssh
C:\Windows\System32\OpenSSH\ssh.exe
```

## env vars (powershell)

To set an env var, eg:

```
$env:RUST_LOG='debug'
```

To list env vars:

```
dir env:
```
