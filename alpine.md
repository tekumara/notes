# alpine

Linux binaries complied against glibc will fail on alpine with `not found`, eg:

```
/aws/install: line 78: /aws/dist/aws: not found
```

Alpine uses musl libc instead. Compile you binary with musl, or install glibc on alpine.

See [awscli version 2 on alpine linux](https://stackoverflow.com/questions/60298619/awscli-version-2-on-alpine-linux)
