# Slack API

## SDKs

- [bolt-python](https://github.com/SlackAPI/bolt-python) - A framework to build Slack apps using Python, see the [tutorial](https://slack.dev/bolt-python/tutorial/getting-started). Good for bots that need to listen to events. Supports [Socket Mode](https://api.slack.com/apis/connections/socket) which allows the app to communicate with Slack without exposing a public HTTP request URL. Apps using socket mode can’t be publicly distributed.

- [python-slack-sdk](https://github.com/slackapi/python-slack-sdk) - Slack Developer Kit for Python. Good for making requests to the slack API, eg: post a message.

- [Incoming webhooks](https://slack.com/help/articles/115005265063-Incoming-webhooks-for-Slack) - Exposes a URL that can be used to post messages to a specific channel.

## Authentication

See https://api.slack.com/web#authentication

To get a token see [Create and regenerate API tokens](https://get.slack.help/hc/en-us/articles/215770388-Create-and-regenerate-API-tokens)

## Stars API

NB: these are now called saved items.

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
