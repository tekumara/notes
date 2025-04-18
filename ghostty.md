# ghostty

Show configuration options:

```
ghostty +show-config --docs --default | less
```

Show all actions with docs:

```
ghostty +list-actions --docs | less
```

In lieu of [search](https://github.com/ghostty-org/ghostty/issues/189), `⌘+shift+j` places scrollback in a temp file and then pastes that file to the terminal.

Clear scrollback `⌘+K`.

## Missing features

Missing features that iTerm2 has:

- [Search scrollback](https://github.com/ghostty-org/ghostty/issues/189)
- [Include scrollback history in state restoration](https://github.com/ghostty-org/ghostty/issues/1847) ie: restore tab's terminal contents on startup aka session restoration
