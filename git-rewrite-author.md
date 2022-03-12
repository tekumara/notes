# git rewrite author

Install git filter-repo:

- `brew install git-filter-repo` or
- `pipx install git-filter-repo`

Rewrite the email address of all commits:

```
git-filter-repo --email-callback 'return "125105+tekumara@users.noreply.github.com".encode("utf8")'
```
