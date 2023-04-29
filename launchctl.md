# launchctl

Show process details including environment variables:

```
sudo launchctl procinfo $pid
```

List all launchd jobs

```
launchctl list
```

launchctl setenv will set the env for all GUI apps.

to persist over restarts, so you'll need `launchtl setenv SSH_AUTH_SOCK mysocket` in a launch agent at startup
