# Git reset

Resets current branch to `<commit>` and depending on the mode may update the index (staging area) and working dir:

- soft:
- mixed (default): reset index
- hard: reset index, reset working directory

`git reset HEAD .` - mixed (default), ie: resets the index (staging area) to HEAD. Does not alter working directory. This unstages any staged changes. Its effect is the opposite of git add. NB: HEAD can be omitted as its the default commit and . can be omitted because its the default path, eg: `git reset`

`git reset --hard HEAD` - has the same affect as `git checkout HEAD .` Removes staged and unstaged changes (but not untracked files). Cannot be used with paths (use `git checkout HEAD <path>` instead)

`git reset --hard HEAD~1` - remove the last commit. sets the current branch HEAD, and working directory and index and to the previous commit.

`git reset --merge` to abort a merge or cherry pick with conflicts. NB: this will leave the merged files as merged in the working tree.

`git reset --hard origin/master` - reset currently checked out branch and working directory to origin/master

NB: Even a hard reset won't remove untracked files. Use `git clean` instead.

`git checkout HEAD -- lib/commons-pool-1.5.5.jar` revert any changes to the file commons-pool-1.5.5.jar

`git clean -f -d -n` remove all untracked files and directories (dry-run, remove -n for real)

To change another branch to point to another commit, without affecting the current working tree use branch instead:

`git branch -f master origin/master`
