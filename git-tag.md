# Git tags

To fetch tags
```
git fetch --tags
git pull
```

To push a single tag
```
git push origin <tag_name>
```

To see tags
```
git tag 
```

To delete tag locally and on remote
```
git tag -d build-4980
git push --delete origin build-4980
```

To get diff of commit for tag1
```
git show tag1
```

To get SHA1 of the commit for tag1
```
git rev-list -1 tag1
```


