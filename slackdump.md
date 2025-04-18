# slackdump

Install:

```
brew install slackdump
```

Use `Enterprise Mode` if you are using Slack Enterprise Grid.

eg:

Dump the channel CXXXXXXXXXX

```
slackdump dump -enterprise -time-from 2024-04-01T00:00:00 -update-links CXXXXXXXXXX
```

## Extract from dump

Extract all message and thread text for a given user from dump.json

```
jq --arg user_id W1234567890 '[.messages[] | select(.user == $user_id) | .text] + [.messages[].slackdump_thread_replies[]? | select(.user == $user_id) | .text]' dump.json
```

See also [slackdump2html](https://github.com/kununu/slackdump2html)
