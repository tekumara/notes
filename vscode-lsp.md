# vscode lsp

## Troubleshooting

> Extension doesn't activate

`activationEvents` in _package.json_ is not empty. It defines what activates the extension, eg:

```json
"activationEvents": [
    "onLanguage:plaintext"
]
```

See [Activation Events](https://code.visualstudio.com/api/references/activation-events)

## References

[Example - Using Language Servers](https://vscode-docs.readthedocs.io/en/stable/extensions/example-language-server/)
