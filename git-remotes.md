# git remotes

## Synchronizing changes between repositories

Unlike centralized version control systems that have a client that is very different from a server, Git repositories are all basically equal and you simply synchronize between them.

Once you have a Git repository you can tell Git to either push any data that you have that is not in the remote repository up, or you can ask Git to fetch differences down from the other repo. Likewise, the remote repo can pull changes from your repo (same as pushing to the remote repo) and vice versa.

You can do this any time and it does not have to correspond with a commit or anything else. Generally you will do a number of commits locally, then fetch data from the online shared repository you cloned the project from to get up to date, merge any new work into the stuff you did, then push your changes back up.

Fetch/pull and push operations occur on branches between two repositories.

A _fast forward push_ sends a commit that is a descendant of the remote's HEAD.

## git remote

`git remote` - list, add and delete remote repositories. These are not necessary, but help make remote operations easier by mapping a remote URLs to an easy to remember alias.

`git remote -v ` list remote aliases and their details  
`git remote add origin git@github.com:tukushan/delme-git.git ` add a remote alias called _origin_

## git push

`git push upstream featureX` push current branch HEAD to specific remote branch  
`git push origin --delete featureY` delete the origin remote branch _featureX_
`git push -u origin --all` push all branches to origin, and add upstream tracking branches

## git fetch

Fetch will update local remote tracking branches (eg: _remotes/origin/master_ to match their remote branch, retrieving any commits that aren't already stored locally.

The branches to fetch from a remote by default, and the corresponding local remote tracking branch is configured by `remote.<remote-name>.fetch`, see `git config`. Example defaults, for two remotes, one called _origin_ and the other called _upstream_:

```
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
remote.upstream.fetch=+refs/heads/*:refs/remotes/upstream/*
```

`git fetch` fetch the latest commits on all remotes onto their respective local remote tracking branch.  
`git fetch origin` fetching the latest commits from the origin remote onto its local remote tracking branch.  
`git fetch origin master` fetch the latest commits on origin/master to the remote tracking branch _remotes/origin/master_. Local master will not be merged.  
`git fetch upstream master:master` fetch _upstream/master_ and do a fast-forward merge of local master.  
`git fetch -f upstream master:master` fetch _upstream/master_ and reset local master to point to it.  
`git fetch --all --prune` removes all obsolete tracking branches. Useful after branches have been deleted on the remote.

## git pull (a fetch and merge)

`git pull` fetch and merge

Show which branches are tracking which remote branches:

```
git branch -vv
```

or

```
git remote show origin
```
