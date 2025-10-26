# git sparse checkout

Clone repo with sparse-checkout enabled automatically. It checks out only the top-level directory initially (in “cone mode”), rather than the entire working tree.

```sh
git clone --sparse $repo
```

To incrementally expand what's checked out:

```sh
git sparse-checkout add $path
```

## Related

`git clone --no-checkout` clones without checking out any files into the working dir or enabling sparse checkout.
