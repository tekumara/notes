# git rewrite author

Configured author:

```
git config --global user.name
git config --global user.email
```

Rewrite the email address of all commits to the configured author:

```
git rebase -r --root --exec "git commit --amend --no-edit --reset-author --allow-empty"
```

Rewrite the email address of all commits to an arbitrary author:

Install git filter-repo:

- `brew install git-filter-repo` or
- `pipx install git-filter-repo`

```
git-filter-repo --email-callback 'return "125105+tekumara@users.noreply.github.com".encode("utf8")'
```
