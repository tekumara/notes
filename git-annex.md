# Git annex

## Git annex backends

Git annex supports WORM and SHA backends:
* WORM - WORM ("Write Once, Read Many") This assumes that any file with the same basename, size, and modification time has the same content. This is the the least expensive backend, recommended for really large files or slow systems.
* SHA256 - This allows verifying that the file content is right, and can avoid duplicates of files with the same content. Its need to generate checksums can make it slower for large files. 
* SHA1 - Smaller hash than SHA256 for those who want a checksum but are less concerned about collisions

The default backend is WORM.

To change the backend for subsequently added files:
```
echo '* annex.backend=SHA1' > .gitattributes
git add .gitattributes
git commit -m'use SHA1 backend'
```

To change the symlinks for files that are already WORM to SHA, first change the backend as above. Then execute:

```
git annex unlock .
git annex add .
git commit -m"changed files to SHA1"
```

## Git annex components

git-annex branch
* contains a log file for each file in the annex which identifies the repos that contain the file.
  eg: `WORM-s7-m1324513993--common.log`
```
  1324514244.00039s 1 40360636-2c34-11e1-9a8e-9f8292affb75
  1324516751.029023s 1 4d57673c-2c3a-11e1-9335-77b5992243ba
```
  This examples shows a file called "common" that exists in 2 git-annex repos, identified by the UUID at the end of each line.
`git annex whereis common` uses the common symlink to identify the log file contents and displays it.
* contains the file uuid.log, which contains the unique ID and name of this git-annex repo, and other repos known to this repo.

master branch
* maintains the tree, ie: the symlinks into the annex\objects. You can merge master with other repos and you will get their symlinks. However the symlinks won't point to any actual file until you do a git annex get.

annex\objects
* the directory that actually contains the files.

## Git annex operations

`git annex init` creates a git-annex branch with 2 commits:
"branch created" with no changes
"update" with a uuid.log file

* NB: if origin/git-annex exists when creating a git-annex branch, then it will be merged in. Because git-annex is empty this means loading up git-annex with the contents of origin/git-annex.
 
`git annex add` moves the file to the annex/objects dir and adds a symlink pointing to it, posts a commit on the git-annex branch of a log file for the added file, stages the symlink in the index

`git commit` commits the symlink on the master branch

`get annex merge` merges any remotes git-annex branches into the git-annex branch. Normally this will happen automatically

`git annex get`
* gets a file from an annex repo and places it in the annex/objects directory
* updates the git-annex branch to indicate that this repo now has a copy of this file

If this fails, eg:
```
get myfile (not available) 
  No other repository is known to contain the file.
failed
git-annex: 1 failed
```
this may be because the git-annex branch doesn't know about the file. If it is in another repo, then you will need to merge in that repo's git-annex branch first before you can get it.

## Resolving conflicts

If when you merge one master into the other you get conflicts, the meaning depends on which backend you are using:
*WORM: a conflict on a WORM symlink means the files have a different size or timestamp
*SHA: a conflict on a SHA symlink means the files have different contents

If you are using the WORM backend and getting merge conflicts on files that are the same, but have different timestamps, you probably need to use an SHA backend. See above on how to change the backend.

For all other conflicts, you can resolve them using the usual [Git merge resolution techniques](http://kernel.mirrors.pair.com/pub/software/scm/git/docs/user-manual.html#resolving-a-merge). Because the conflict is over a symlink, rather than the contents of a file, then you will want to keep either the local or remote symlink.

`git status` will show the unmerged files which have the conflicts/
`git diff --theirs unmerged-file`    will compare the local symlink to the remote.

To keep the local symlink just add the symlink and commit
```
git add unmerged-file
git commit -m"merged"
```

To use the remote symlink:
```
git checkout --ours unmerged-file
git add unmerged-file
git commit -m"merged"
```
