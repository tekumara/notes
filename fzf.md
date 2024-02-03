# fzf

fzf doesn't take kindly to being started in a subshell, eg:

```
git checkout $(git branch | fzf)
```

Will stall until CTRL+C is pressed because its running in subshell. Use xargs instead, eg:

```
git branch | fzf | xargs git checkout
```
