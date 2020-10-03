# git branch


<pre>!![[Branches|http://progit.org/book/ch3-1.html]]

Even if you don't use branches within your local repo/codebase, you will need to understand how they work because interactions with remotes occurs on branches.

When we need to be precise, we will use the word &quot;branch&quot; to mean a line of development, and &quot;branch head&quot; (or just &quot;head&quot;) to mean a reference to the most recent commit on a branch. However, when no confusion will result, we often just use the term &quot;branch&quot; both for branches and for branch heads.

Branches (and tags) are pointers (ie: references) to commits. Because a branch in Git is simply a lightweight movable pointer to a commit it is very cheap. Whatever is the current branch pointer will be automatically advanced to point to future commits.

The branch/commit you are currently on is the special pointer called HEAD.

All references are named with a slash-separated path name starting with &quot;refs&quot;; the names we’ve been using so far are actually shorthand:

* The branch &quot;test&quot; is short for &quot;refs/heads/test&quot;.
* The tag &quot;v2.6.18&quot; is short for &quot;refs/tags/v2.6.18&quot;.
* &quot;origin/master&quot; is short for &quot;refs/remotes/origin/master&quot;. 

The full name is occasionally useful if, for example, there ever exists a tag and a branch with the same name.

In a nutshell you can create a branch with {{{git branch}}}, switch the working directory and that branch context with {{{git checkout}}}, record commit snapshots while in that context, then can switch back and forth easily. When you switch branches, Git replaces your working directory with the snapshot of the latest commit on that branch You merge branches together with git merge. You can easily merge multiple times from the same branch over time, or alternately you can choose to delete a branch immediately after merging it. 

''Branch workflow'' - there a many different possible workflows such as this one used by some Git users: have only code that is entirely stable in their master branch — possibly only code that has been or will be released. They have another parallel branch named develop or next that they work from or use to test stability — it isn’t necessarily always stable, but whenever it gets to a stable state, it can be merged into master. It’s used to pull in topic branches (short-lived branches) when they’re ready, to make sure they pass all the tests and don’t introduce bugs. This workflow is explained further [[here|http://progit.org/book/ch3-4.html]].

{{{git branch -a}}} to display all branches, including remote branches (tracked locally or not)

{{{git branch -r}}} show remote branches (tracked locally or not)

{{{git show-ref}}} shows all references, ie: all branches and tags with their SHA1

{{{git branch BRANCHNAME}}} creates a new branch reference pointing to the current HEAD. 

{{{git branch -f master master~1}}} &quot;rollback&quot; the master branch so it now points to the previous commit




List branches merged into master
```
git branch --merged master | grep -v master
```

List branch not merged into master
```
git  --no-merged master
```

Delete branches merged into master
```
git branch --merged master | grep -v master | xargs git branch -d
```

Show any remote-tracking references (ie: origin/*) that no longer exist on the remote.
```
git remote prune origin --dry-run
```

Delete remote-tracking references (ie: origin/*). Local branches will remain
```
git remote prune origin
```
