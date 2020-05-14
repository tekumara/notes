# Git LFS

`git lfs install` creates the following hooks in the git global config:
```
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
```
`git lfs uninstall` removes them

If you installed git lfs as a system package (eg: a .deb from packagecloud) then the above hooks will be installed into the git system config (ie: `/etc/gitconfig`)

`git lfs install --skip-smudge` Skips automatic downloading of objects on clone or pull. This requires a manual `git lfs pull` every time a new commit is checked out on your repository.

`git lfs checkout` checks out LFS files. If the above hooks are installed, this happens automatically. You'll only need to run this if git-lfs is installed after a repo has been cloned.

## Git LFS failures

When the git lfs smudge filter fails it can leave a repo with a dirty working tree.
Reset the working tree, and uninstall the filters.


