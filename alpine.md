# alpine

Linux binaries complied against glibc will fail on alpine with `not found`, eg:

```
/aws/install: line 78: /aws/dist/aws: not found
```

Alpine uses musl libc instead. Compile your binary with musl, or install glibc on alpine.

