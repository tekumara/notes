# Using git annex to sync 2 directories

```
# Setup test dirs a and b
mkdir a
echo a1 > a/a1
echo a2 > a/a2
echo common > a/common
mkdir b
echo b1 > b/b1
echo b2 > b/b2

# copied file will have different timestamp unless "cp -p" is used. If the timestamp is different then the WORM backend will treat this as a different file.
# NB: when copying in dolphin, the timestamp is preserved.
cp -p a/common b/  

# Setup git and git annex in a
cd a
git init
git annex init a
git annex add .
git add .
git commit -m"a initial"

# Setup git in a 
cd ../b
git clone -n ../a new          # clone a, but don't checkout HEAD when complete. origin will point to a
mv new/.git .
rmdir new
git reset # reset git index to b's wd - hangover from cloning from 'a'

# Setup git-annex in 'b'.
git annex init b                 # This merges a's (origin's) git-annex branch into the b's newly created git-annex branch.
git annex add .                #Add files. Because we are using WORM, the symlinks for common will be different

# See the files in a that are not in the current working directory of b. The will be marked for deletion.
git diff --numstat --name-only --diff-filter=D
git diff --numstat --name-only --diff-filter=D | xargs git checkout   # check them out

# Once the symlinks for unique  files of a are added to the working directory of b, we can use git annex to get them
git annex get . 

# b now contains the unison of a and b, but common is showing as modified because its symlink is different
git status

git remote add a ../a
cd ../a
git remote add b ../b

# get the master and git-annex branches of b
git fetch b

# the merge of git-annex and b/git-annex will happy automatically, but we need to execute the merge of master ourselves
# the merge will add b1 and b2, and overwrite the existing common symlink with the symlink from b
git merge b/master

# fetch b1, b2 and common
get annex get .
```
