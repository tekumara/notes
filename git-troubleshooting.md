# git troubleshooting

## cannot lock ref

eg:

```
❯ gpl
From github.com:tekumara/myrepo
 * [new branch]          WORK-1311                                    -> origin/JAX-1311
 * [new branch]          work-1311                                    -> origin/jax-1311
error: cannot lock ref 'refs/remotes/origin/jax-1311': Unable to create '../myrepo/.git/refs/remotes/origin/work-1311.lock': File exists.
```

Because there are two versions - a lower and uppercase one. Delete the branch on the remote.
