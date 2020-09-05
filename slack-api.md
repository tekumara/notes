# Slack API

## Authentication

See https://api.slack.com/web#authentication

To get a token see [Create and regenerate API tokens](https://get.slack.help/hc/en-us/articles/215770388-Create-and-regenerate-API-tokens)

## Stars API

NB: these are now called saved messages.

eg: [list starred messages](https://api.slack.com/methods/stars.list) in the order they were starred, most recent first, with 1000 per page:

```
curl -H 'Authorization: Bearer xoxp-XXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' https://slack.com/api/stars.list\?count\=1000
```

To see the channel, text and link, in the order it was posted:

```
jq -r '.items | sort_by(.message.ts) | .[] | [.channel, .message.text, .message.permalink]' stars.json > stars-text.json
```

## Channel history

eg: [list channel history](https://api.slack.com/methods/conversations.history) from a specific `ts` (inclusive), in order of `ts`, with user id and message text:

```
curl -H 'Authorization: Bearer xoxp-XXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' https://slack.com/api/conversations.history\?channel\=C04G07S1R\&oldest\=1524585770.000886\&inclusive\=true\&limit\=1000 | jq -r '.messages[] | [.user,.text] | @tsv' | tail -r
```

The channel ID can be found via [conversations.list](https://api.slack.com/methods/conversations.list)

```
curl -H 'Authorization: Bearer xoxp-XXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' https://slack.com/api/conversations.list | jq -r '.channels[] | [.id,.name] | @tsv'
```

## Search

eg: To get the `ts` of a message you can [search messages](https://api.slack.com/methods/search.messages)

```
curl -H 'Authorization: Bearer xoxp-XXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' https://slack.com/api/search.messages\?query\=foobar
```
